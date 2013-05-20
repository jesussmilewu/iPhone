//
//  OfflineCache.m
//  YouTubePlayer
//
//  Created by Clemens Wagner on 11.05.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "OfflineCache.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "NSString+Extensions.h"

#define USE_DELEGATE 0

static const NSUInteger kInvalidSize = ~0U;

@interface OfflineCache()

@property (nonatomic, copy) NSString *baseDirectory;
@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, readwrite) NSUInteger size;
@property (nonatomic) BOOL searchKeysAreUnique;

- (NSString *)databaseFile;
- (NSOperationQueue *)operationQueue;
- (BOOL)open;
- (void)close;
- (NSInteger)logicalSize;
- (void)scheduleShrinkIfNeeded;
- (void)shrinkIfNeeded;

- (NSString *)searchKeyForRequest:(NSURLRequest *)inRequest;
- (BOOL)cachedRequest:(NSURLRequest *)inCachedRequest isEqualToRequest:(NSURLRequest *)inRequest;
- (NSCachedURLResponse *)cachedResponseForId:(NSInteger)inId;
- (BOOL)cacheEntryId:(NSInteger *)outId withRequest:(NSURLRequest *)inRequest;

@end

@interface FMResultSet(OfflineCache)

- (id)decodedObjectForColumnIndex:(int)inIndex;

@end

@implementation OfflineCache

@synthesize delegate;
@synthesize capacity;
@synthesize size;

static OfflineCache *sharedOfflineCache;

+ (OfflineCache *)sharedOfflineCache {
    return sharedOfflineCache;
}

+ (void)setSharedOfflineCache:(OfflineCache *)inCache {
    sharedOfflineCache = inCache;
}

- (id)initWithCapacity:(NSUInteger)inCapacity path:(NSString *)inPath {
    self = [super init];
    if(self) {
        self.capacity = inCapacity;
        self.baseDirectory = inPath;
        self.size = kInvalidSize;
        if(![self open]) {
            self = nil;
        }
    }
    return self;
}

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)inRequest {
#if USE_DELEGATE
    NSCachedURLResponse *theResponse = nil;
    NSInteger theId;

    if([self cacheEntryId:&theId withRequest:inRequest]) {
        theResponse = [self cachedResponseForId:theId];
    }
    return theResponse;
#else
    NSString *theKey = [self searchKeyForRequest:inRequest];
    FMResultSet *theResultSet = [self.database executeQuery:@"SELECT response, data, user_info FROM cache_entry WHERE search_key = ?", theKey];

    if([theResultSet next]) {
        NSURLResponse *theResponse = [theResultSet decodedObjectForColumnIndex:0];
        NSData *theData = [theResultSet dataForColumnIndex:1];
        NSDictionary *theUserInfo = [theResultSet decodedObjectForColumnIndex:2];

        return [[NSCachedURLResponse alloc] initWithResponse:theResponse
                                                        data:theData
                                                    userInfo:theUserInfo
                                               storagePolicy:NSURLCacheStorageAllowed];
    }
    else {
        return nil;
    }
#endif
}

- (void)storeCachedResponse:(NSCachedURLResponse *)inResponse forRequest:(NSURLRequest *)inRequest {
    NSData *theRequestData = [NSKeyedArchiver archivedDataWithRootObject:inRequest];
    NSData *theResponseData = [NSKeyedArchiver archivedDataWithRootObject:inResponse.response];
    NSData *theUserInfo = [NSKeyedArchiver archivedDataWithRootObject:inResponse.userInfo];
    NSInteger theId;

    NSLog(@"storeCachedResponse:%u forRequest:%@", inResponse.data.length, inRequest.URL);
    @synchronized(self.database) {
        if([self cacheEntryId:&theId withRequest:inRequest]) {
            if(![self.database executeUpdate:@"UPDATE cache_entry SET last_access_time = CURRENT_TIMESTAMP, request = ?, response = ?, data = ?, user_info = ? WHERE id = ?", theRequestData, theResponseData, inResponse.data, theUserInfo, @(theId)]) {
                NSLog(@"error: %@", [self.database lastError]);
            }
        }
        else {
            NSString *theSearchKey = [self searchKeyForRequest:inRequest];

            if(![self.database executeUpdate:@"INSERT INTO cache_entry (search_key, request, response, data, user_info) VALUES (?, ?, ?, ?, ?)",
                 theSearchKey, theRequestData, theResponseData, inResponse.data, theUserInfo]) {
                NSLog(@"error: %@", [self.database lastError]);
            }
        }
        self.size = kInvalidSize;
        [self scheduleShrinkIfNeeded];
    }
}

- (void)removeAllCachedResponses {
    @synchronized(self.database) {
        [self.database executeUpdate:@"DELETE FROM cache_entry"];
        self.size = 0;
    }
}

- (void)removeCachedResponseForRequest:(NSURLRequest *)inRequest {
    NSInteger theId;

    @synchronized(self.database) {
        if([self cacheEntryId:&theId withRequest:inRequest]) {
            [self.database executeUpdate:@"DELETE FROM cache_entry WHERE id = ?", @(theId)];
            self.size = kInvalidSize;
        }
    }
}

- (NSString *)databaseFile {
    return [self.baseDirectory stringByAppendingPathComponent:@"cache.db"];
}

- (NSOperationQueue *)operationQueue {
    return [NSOperationQueue mainQueue];
}

- (void)setCapacity:(NSUInteger)inCapacity {
    NSUInteger theCapacity = self.capacity;

    capacity = inCapacity;
    if(theCapacity > inCapacity) {
        [self scheduleShrinkIfNeeded];
    }
}

- (NSUInteger)size {
    if(size == kInvalidSize) {
        self.size = [self logicalSize];
    }
    return size;
}

- (BOOL)createSchemaWithDatabase:(FMDatabase *)inDatabase {
    NSString *theSchemaPath = [[NSBundle mainBundle] pathForResource:@"cache-schema" ofType:@"sql"];
    NSError *theError = nil;
    NSString *theSchema = [NSString stringWithContentsOfFile:theSchemaPath encoding:NSUTF8StringEncoding error:&theError];

    if(theSchema == nil) {
        NSLog(@"createSchema: %@", theError);
        return NO;
    }
    else {
        NSArray *theStatements = [theSchema componentsSeparatedByString:@";"];

        for(NSString *theStatement in theStatements) {
            NSString *theTrimmedStatement = [theStatement trim];

            if(theTrimmedStatement.length > 0 && ![inDatabase executeUpdate:theStatement]) {
                NSLog(@"createSchema: Invalid statement '%@'.", theStatement);
                return NO;
            }
        }
        self.size = 0;
        return YES;
    }
}

- (FMDatabase *)createDatabaseWithError:(NSError **)outError {
    NSFileManager *theManager = [NSFileManager defaultManager];
    FMDatabase *theDatabase = nil;

    if([theManager createDirectoryAtPath:self.baseDirectory withIntermediateDirectories:YES attributes:nil error:outError]) {
        if([theManager fileExistsAtPath:self.databaseFile]) {
            theDatabase = [FMDatabase databaseWithPath:self.databaseFile];
        }
        else {
            NSString *thePath = [[NSBundle mainBundle] pathForResource:@"cache" ofType:@"db"];

            if([theManager copyItemAtPath:thePath toPath:self.databaseFile error:outError]) {
                theDatabase = [FMDatabase databaseWithPath:self.databaseFile];
            }
        }
    }
    return theDatabase;
}

- (BOOL)open {
    NSError *theError = nil;
    FMDatabase *theDatabase = [self createDatabaseWithError:&theError];
        
    if([theDatabase open]) {
        self.database = theDatabase;
        [self scheduleShrinkIfNeeded];
        return YES;
    }
    else {
        NSLog(@"open: %@", theError);
        return NO;
    }
}

- (void)close {
    [self.database close];
}

- (NSInteger)logicalSize {
    @synchronized(self.database) {
        return [self.database intForQuery:@"SELECT SUM(LENGTH(data)) FROM cache_entry"];
    }
}

- (NSInteger)physicalSize {
    NSFileManager *theManager = [NSFileManager defaultManager];
    NSDictionary *theAttributes = [theManager attributesOfItemAtPath:self.databaseFile error:NULL];

    return theAttributes == nil ? kInvalidSize : theAttributes.fileSize;
}

- (void)scheduleShrinkIfNeeded {
    if(self.size > self.capacity) {
        NSOperation *theOperation = [NSBlockOperation blockOperationWithBlock:^{
            [self shrinkIfNeeded];
        }];

        theOperation.queuePriority = NSOperationQueuePriorityVeryLow;
        [self.operationQueue addOperation:theOperation];
    }
}

- (void)shrinkIfNeeded {
    @synchronized(self.database) {
        if(self.size > self.capacity) {
            FMResultSet *theResultSet = [self.database executeQuery:@"SELECT id, LENGTH(data) FROM cache_entry ORDER BY last_access_time LIMIT 1"];
            
            if([theResultSet next]) {
                NSInteger theId = [theResultSet intForColumnIndex:0];
                NSInteger theLength = [theResultSet intForColumnIndex:1];

                [theResultSet close];
                if([self.database executeUpdate:@"DELETE FROM cache_entry WHERE id = ?", @(theId)]) {
                    self.size = theLength < self.size ? self.size - theLength : kInvalidSize;
                }
                [self scheduleShrinkIfNeeded];
            }
        }
    }
}

- (BOOL)cachedRequest:(NSURLRequest *)inCachedRequest isEqualToRequest:(NSURLRequest *)inRequest {
#if USE_DELEGATE
    if([self.delegate respondsToSelector:@selector(offlineCache:cachedRequest:isEqualToRequest:)]) {
        return [self.delegate offlineCache:self cachedRequest:inCachedRequest isEqualToRequest:inRequest];
    }
    else
#endif
    if([inCachedRequest.HTTPMethod isEqualToString:inRequest.HTTPMethod]) {
        NSURL *theCachedURL = [inCachedRequest.URL standardizedURL];
        NSURL *theURL = [inRequest.URL standardizedURL];
        
        return [theCachedURL isEqual:theURL];
    }
    else {
        return NO;
    }
}

- (NSString *)searchKeyForRequest:(NSURLRequest *)inRequest {
#if USE_DELEGATE
    if([self.delegate respondsToSelector:@selector(offlineCache:searchKeyForRequest:)]) {
        return [self.delegate offlineCache:self searchKeyForRequest:inRequest];
    }
    else {
#endif
        NSURL *theURL = [inRequest.URL standardizedURL];

        return [NSString stringWithFormat:@"%@:%@", inRequest.HTTPMethod, theURL];
#if USE_DELEGATE
    }
#endif
}

- (NSCachedURLResponse *)cachedResponseForId:(NSInteger)inId {
    FMResultSet *theResultSet = [self.database executeQuery:@"SELECT response, data, user_info FROM cache_entry WHERE id = ?", @(inId)];

    if([theResultSet next]) {
        NSURLResponse *theResponse = [theResultSet decodedObjectForColumnIndex:0];
        NSData *theData = [theResultSet dataForColumnIndex:1];
        NSDictionary *theUserInfo = [theResultSet decodedObjectForColumnIndex:2];

        return [[NSCachedURLResponse alloc] initWithResponse:theResponse
                                                        data:theData
                                                    userInfo:theUserInfo
                                               storagePolicy:NSURLCacheStorageAllowed];
    }
    else {
        return nil;
    }
}

- (BOOL)cacheEntryId:(NSInteger *)outId withRequest:(NSURLRequest *)inRequest {
    NSString *theSearchKey = [self searchKeyForRequest:inRequest];
#if USE_DELEGATE
    FMResultSet *theResultSet = [self.database executeQuery:@"SELECT id, request FROM cache_entry WHERE search_key = ?", theSearchKey];

    while([theResultSet next]) {
        NSURLRequest *theCachedRequest = [theResultSet decodedObjectForColumnIndex:1];

        if([self cachedRequest:theCachedRequest isEqualToRequest:inRequest]) {
            *outId = [theResultSet intForColumnIndex:0];
            return YES;
        }
    }
    return NO;
#else
    *outId = [self.database intForQuery:@"SELECT id FROM cache_entry WHERE search_key = ?", theSearchKey];
    return *outId > 0;
#endif
}

@end

@implementation FMResultSet(OfflineCache)

- (id)decodedObjectForColumnIndex:(int)inIndex {
    NSData *theData = [self dataForColumnIndex:inIndex];

    return theData == nil ? nil : [NSKeyedUnarchiver unarchiveObjectWithData:theData];
}

@end