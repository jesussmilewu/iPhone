//
//  YouTubeAppDelegate.m
//  YouTubePlayer
//
//  Created by Clemens Wagner on 04.05.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "YouTubeAppDelegate.h"
#import "OfflineHTTPProtocol.h"
#import "OfflineCache.h"

#define USE_OFFLINE_CACHE 1

@implementation YouTubeAppDelegate

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inOptions {
#if USE_OFFLINE_CACHE
    NSArray *thePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *thePath = [thePaths[0] stringByAppendingPathComponent:@"CustomCache"];
    OfflineCache *theCache = [[OfflineCache alloc] initWithCapacity:10485760 path:thePath];

    [OfflineCache setSharedOfflineCache:theCache];
    [NSURLProtocol registerClass:[OfflineHTTPProtocol class]];
#endif
    return YES;
}

@end