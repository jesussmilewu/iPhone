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

+ (OfflineCache *)sharedResponseCache;
+ (void)setSharedResponseCache:(OfflineCache *)inCache;

- (id)initWithCapacity:(NSUInteger)inCapacity path:(NSString *)inBaseDirectory;
- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)inRequest;
- (void)storeCachedResponse:(NSCachedURLResponse *)inResponse forRequest:(NSURLRequest *)inRequest;
- (void)removeAllCachedResponses;
- (void)removeCachedResponseForRequest:(NSURLRequest *)inRequest;

@end

@protocol OfflineCacheDelegate<NSObject>

@optional
- (NSString *)responseCache:(OfflineCache *)inCache searchKeyForRequest:(NSURLRequest *)inRequest;
- (BOOL)responseCache:(OfflineCache *)inCache requestInCache:(NSURLRequest *)inRequestInCache matchesRequest:(NSURLRequest *)inRequest;

@end