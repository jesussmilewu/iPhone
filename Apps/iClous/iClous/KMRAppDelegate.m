//
//  KMRAppDelegate.m
//  iclous
//
//  Created by Klaus Rodewig on 18.09.12.
//  Copyright (c) 2012 Foobar Ltd. All rights reserved.
//

#define CLOUDFILE @"iclous.txt"
#import "KMRAppDelegate.h"
#import "KMRViewController.h"
#import "CloudDoc.h"

@implementation KMRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[KMRViewController alloc] initWithNibName:@"KMRViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    // write local file
    NSString *theLocalText = @"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.";
    
    // check for iCloud
    self.theCloud = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.iCloudPath = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        if (self.iCloudPath) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"iCloud-Verzeichnis: %@", self.iCloudPath);
                self.theCloud = YES;
                [self loadFileFromCloud];

                
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"No iCloud");
                [self setTheCloud:NO];
            });
        }
    });
    
    return YES;
}

- (void)loadFileFromCloud{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    NSMetadataQuery *query = [[NSMetadataQuery alloc] init];
    _query = query;
    [query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == %@", NSMetadataItemFSNameKey, CLOUDFILE]; [query setPredicate:pred];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(queryDidFinishGathering:) name:NSMetadataQueryDidFinishGatheringNotification object:query];
    [query startQuery];
}

- (void)loadData:(NSMetadataQuery *)query {
    if ([query resultCount] == 1) {
        NSMetadataItem *item = [query resultAtIndex:0];
        NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
        CloudDoc *theDoc = [[CloudDoc alloc] initWithFileURL:url];
        self.cloudDoc = theDoc;
        [self.cloudDoc openWithCompletionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"iCloud document opened");
            } else {
                NSLog(@"failed opening document from iCloud"); }
        }];
    } else {
        NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent: @"Documents"] URLByAppendingPathComponent:CLOUDFILE];
        CloudDoc *theDoc = [[CloudDoc alloc] initWithFileURL:ubiquitousPackage];
        self.cloudDoc = theDoc;
        [theDoc saveToURL:[theDoc fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                [theDoc openWithCompletionHandler:^(BOOL success) {
                    NSLog(@"new document opened from iCloud");
                }];
            }
        }];
    }
}

- (void)queryDidFinishGathering:(NSNotification *)notification {
    NSMetadataQuery *query = [notification object];
    [query disableUpdates];
    [query stopQuery];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidFinishGatheringNotification object:query];
    _query = nil;
    [self loadData:query];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
