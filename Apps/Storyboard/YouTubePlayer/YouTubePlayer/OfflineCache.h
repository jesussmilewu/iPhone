//
//  Cache.h
//  YouTubePlayer
//
//  Created by Clemens Wagner on 11.05.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OfflineCacheDelegate;

@interface OfflineCache : NSObject

@property (nonatomic, weak) id<OfflineCacheDelegate> delegate;
@property (nonatomic) NSUInteger capacity;
@property (nonatomic, readonly) NSUInteger size;

+ (OfflineCache *)sharedOfflineCache;
+ (void)setSharedOfflineCache:(OfflineCache *)inCache;

- (id)initWithCapacity:(NSUInteger)inCapacity path:(NSString *)inBaseDirectory;
- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)inRequest;
- (void)storeCachedResponse:(NSCachedURLResponse *)inResponse forRequest:(NSURLRequest *)inRequest;
- (void)removeAllCachedResponses;
- (void)removeCachedResponseForRequest:(NSURLRequest *)inRequest;

@end

@protocol OfflineCacheDelegate<NSObject>

@optional
- (BOOL)offlineCacheHasUniqueSearchKeys:(OfflineCache *)inCache;
- (BOOL)offlineCache:(OfflineCache *)inCache shouldStoreResponse:(NSCachedURLResponse *)inResponse forRequest:(NSURLRequest *)inRequest;
- (NSString *)offlineCache:(OfflineCache *)inCache searchKeyForRequest:(NSURLRequest *)inRequest;
- (BOOL)offlineCache:(OfflineCache *)inCache cachedRequest:(NSURLRequest *)inRequestInCache isEqualToRequest:(NSURLRequest *)inRequest;

@end