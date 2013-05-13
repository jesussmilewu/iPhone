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

#define USE_OFFLINE_CACHE 0

@implementation YouTubeAppDelegate

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inOptions {
#if USE_OFFLINE_CACHE
    NSArray *thePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *thePath = [thePaths[0] stringByAppendingPathComponent:@"CustomCache"];
    ResponseCache *theCache = [[ResponseCache alloc] initWithCapacity:10485760 path:thePath];

    [ResponseCache setSharedResponseCache:theCache];
    [NSURLProtocol registerClass:[HTTPProtocol class]];
#endif
    return YES;
}

@end