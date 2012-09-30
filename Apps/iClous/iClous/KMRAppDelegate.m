//
//  KMRAppDelegate.m
//  iclous
//
//  Created by Klaus Rodewig on 18.09.12.
//  Copyright (c) 2012 Foobar Ltd. All rights reserved.
//

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
    
    // check for iCloud
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *iCloud = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        if (iCloud) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"iCloud-Verzeichnis: %@", iCloud);
                NSURL *cloudFile = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
                NSURL *cloudURL = [[cloudFile URLByAppendingPathComponent: @"Documents"] URLByAppendingPathComponent:@"iclous.txt"];
                
                CloudDoc *theDoc = [[CloudDoc alloc] initWithFileURL:cloudURL];

                [theDoc setCloudText:@"Foobar"];
                [theDoc saveToURL:[theDoc fileURL] forSaveOperation:UIDocumentSaveForCreating
                completionHandler:^(BOOL success) {
                    [theDoc openWithCompletionHandler:^(BOOL success) {
                        NSLog(@"Cloud file created");
                        NSLog(@"Cloud-Text: %@", [theDoc cloudText]);
                    }];
                }];
                
                
                NSLog(@"Cloud file: %@", [self accessCloudFile]);
                [self setTheCloud:YES];
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
