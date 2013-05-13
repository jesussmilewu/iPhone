//
//  ResponseCache.m
//  YouTubePlayer
//
//  Created by Clemens Wagner on 11.05.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "OfflineCache.h"
#import "FMDatabase.h"
#import "NSString+Extensions.h"

static const NSUInteger kInvalidSize = ~0U;

@interface OfflineCache()

@property (nonatomic, copy) NSString *baseDirectory;
@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, readwrite) NSUInteger size;

- (NSString *)databaseFile;
- (NSOperationQueue *)operationQueue;
- (BOOL)open;
- (void)close;
- (NSInteger)currentSize;
- (void)scheduleShrinkIfNeeded;
- (void)shrinkIfNeeded;

- (NSString *)searchKeyForRequest:(NSURLRequest *)inRequest;
- (BOOL)requestInCache:(NSURLRequest *)inCachedRequest matchesRequest:(NSURLRequest *)inRequest;
- (NSCachedURLResponse *)cachedResponseForId:(NSInteger)inId;
- (BOOL)findCachedResponseWithRequest:(NSURLRequest *)inRequest responseId:(NSInteger *)outId;

@end

@interface FMResultSet(ResponseCache)

- (id)decodedObjectForColumnIndex:(int)inIndex;

@end

@implementation OfflineCache

@synthesize capacity;
@synthesize size;

static OfflineCache *sharedResponseCache;

+ (OfflineCache *)sharedResponseCache {
    return sharedResponseCache;
}

+ (void)setSharedResponseCache:(OfflineCache *)inCache {
    sharedResponseCache = inCache;
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
    NSInteger theId;
    NSCachedURLResponse *theResponse = nil;

    if([self findCachedResponseWithRequest:inRequest responseId:&theId]) {
        theResponse = [self cachedResponseForId:theId];
    }
    NSLog(@"cachedResponseForRequest:%@ (%u)", inRequest.URL, theResponse.data.length);
    return theResponse;
}

- (void)storeCachedResponse:(NSCachedURLResponse *)inResponse forRequest:(NSURLRequest *)inRequest {
    NSData *theRequestData = [NSKeyedArchiver archivedDataWithRootObject:inRequest];
    NSData *theResponseData = [NSKeyedArchiver archivedDataWithRootObject:inResponse.response];
    NSData *theUserInfo = [NSKeyedArchiver archivedDataWithRootObject:inResponse.userInfo];
    NSInteger theId;

    NSLog(@"storeCachedResponse:%u forRequest:%@", inResponse.data.length, inRequest.URL);
    @synchronized(self.database) {
        if([self findCachedResponseWithRequest:inRequest responseId:&theId]) {
            if(![self.database executeUpdate:@"UPDATE response_cache SET last_access_time = CURRENT_TIMESTAMP, request = ?, response = ?, data = ?, user_info = ? WHERE id = ?"
                    withArgumentsInArray:@[
             theRequestData, theResponseData, inResponse.data, theUserInfo, @(theId)
                 ]]) {
                NSLog(@"error: %@", [self.database lastError]);
            }
        }
        else {
            NSString *theSearchKey = [self searchKeyForRequest:inRequest];

            if(![self.database executeUpdate:@"INSERT INTO response_cache (search_key, request, response, data, user_info) VALUES (?, ?, ?, ?, ?)"
                       withArgumentsInArray:@[ theSearchKey, theRequestData, theResponseData, inResponse.data, theUserInfo ]]) {
                NSLog(@"error: %@", [self.database lastError]);
            }
        }
        self.size = kInvalidSize;
        [self scheduleShrinkIfNeeded];
    }
}

- (void)removeAllCachedResponses {
    @synchronized(self.database) {
        [self.database executeUpdate:@"DELETE FROM response_cache"];
        self.size = 0;
    }
}

- (void)removeCachedResponseForRequest:(NSURLRequest *)inRequest {
    NSInteger theId;

    @synchronized(self.database) {
        if([self findCachedResponseWithRequest:inRequest responseId:&theId]) {
            [self.database executeUpdate:@"DELETE FROM response_cache WHERE id = ?", @(theId)];
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
        self.size = [self currentSize];
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

- (BOOL)open {
    NSFileManager *theManager = [NSFileManager new];
    NSError *theError = nil;

    if([theManager createDirectoryAtPath:self.baseDirectory withIntermediateDirectories:YES attributes:nil error:&theError]) {
        BOOL theExistsFlag = [theManager fileExistsAtPath:self.databaseFile];
        FMDatabase *theDatabase = [FMDatabase databaseWithPath:self.databaseFile];
        
        if([theDatabase open] && (theExistsFlag || [self createSchemaWithDatabase:theDatabase])) {
            self.database = theDatabase;
            [self scheduleShrinkIfNeeded];
            return YES;
        }
        else {
            [theDatabase close];
            if(![theManager removeItemAtPath:self.databaseFile error:&theError]) {
                NSLog(@"open: Can't remove file '%@'", self.databaseFile);
            }
            return NO;
        }
    }
    else {
        NSLog(@"open: %@", theError);
        return NO;
    }
}

- (void)close {
    [self.database close];
}

- (NSInteger)currentSize {
    @synchronized(self.database) {
        FMResultSet *theResultSet = [self.database executeQuery:@"SELECT SUM(LENGTH(data)) FROM response_cache"];

        return [theResultSet next] ? [theResultSet intForColumnIndex:0] : 0;
    }
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
            FMResultSet *theResultSet = [self.database executeQuery:@"SELECT id, LENGTH(data) FROM response_cache ORDER BY last_access_time LIMIT 1"];
            
            if([theResultSet next]) {
                NSInteger theId = [theResultSet intForColumnIndex:0];
                NSInteger theLength = [theResultSet intForColumnIndex:1];

                [theResultSet close];
                if([self.database executeUpdate:@"DELETE FROM response_cache WHERE id = ?", @(theId)]) {
                    self.size = theLength < self.size ? self.size - theLength : kInvalidSize;
                }
                [self scheduleShrinkIfNeeded];
            }
        }
    }
}

- (BOOL)requestInCache:(NSURLRequest *)inCachedRequest matchesRequest:(NSURLRequest *)inRequest {
    if([self.delegate respondsToSelector:@selector(responseCache:requestInCache:matchesRequest:)]) {
        return [self.delegate responseCache:self requestInCache:inCachedRequest matchesRequest:inRequest];
    }
    else {
        NSURL *theCachedURL = [inCachedRequest.URL standardizedURL];
        NSURL *theURL = [inRequest.URL standardizedURL];
        
        return [theCachedURL isEqual:theURL];
    }
}

- (NSString *)searchKeyForRequest:(NSURLRequest *)inRequest {
    if([self.delegate respondsToSelector:@selector(responseCache:searchKeyForRequest:)]) {
        return [self.delegate responseCache:self searchKeyForRequest:inRequest];
    }
    else {
        NSURL *theURL = [inRequest.URL standardizedURL];

        return [theURL absoluteString];
    }
}

- (NSCachedURLResponse *)cachedResponseForId:(NSInteger)inId {
    FMResultSet *theResultSet = [self.database executeQuery:@"SELECT response, data, user_info FROM response_cache WHERE id = ?", @(inId)];

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

- (BOOL)findCachedResponseWithRequest:(NSURLRequest *)inRequest responseId:(NSInteger *)outId {
    NSString *theSearchKey = [self searchKeyForRequest:inRequest];
    FMResultSet *theResultSet = [self.database executeQuery:@"SELECT id, request FROM response_cache WHERE search_key = ?", theSearchKey];

    while([theResultSet next]) {
        NSURLRequest *theCachedRequest = [theResultSet decodedObjectForColumnIndex:1];

        if([self requestInCache:theCachedRequest matchesRequest:inRequest]) {
            *outId = [theResultSet intForColumnIndex:0];
            return YES;
        }
    }
    return NO;
}


@end

@implementation FMResultSet(ResponseCache)

- (id)decodedObjectForColumnIndex:(int)inIndex {
    NSData *theData = [self dataForColumnIndex:inIndex];

    return theData == nil ? nil : [NSKeyedUnarchiver unarchiveObjectWithData:theData];
}

@end