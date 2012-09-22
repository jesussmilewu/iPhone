;//
//  AppDelegate.m
//  Top25Foo
//
//  Created by Klaus M. Rodewig on 01.08.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import <CoreFoundation/CoreFoundation.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    char foo = 127;
    NSLog(@"foo vorher: %i", foo);
    foo++;
    NSLog(@"foo nachher: %i", foo);
    
    int bar = 4294967295;
    NSLog(@"bar vorher: %u", bar);
    bar++;
    NSLog(@"bar nachher: %u", bar);
    
    int fooBar = 0;
    NSLog(@"bar vorher: %u", fooBar);
    fooBar--;
    NSLog(@"bar nachher: %u", fooBar);
    
    NSNumber *tschar = [NSNumber numberWithChar:257];
    NSLog(@"tschar: %i", [tschar charValue]);

    // SQL Injection
    NSString *user = @"foo";
    NSString *pass = @"' or 1=1--";
    NSString *query = [NSString stringWithFormat:@"select * from tbl.user where user='%@' and pass='%@'", user, pass];
//    NSString *sanitizedQuery = [NSString stringWithFormat:@"%@", [query UTF8String]];
//    NSLog(@"query: %@", query);
//    NSLog(@"query: %@", query);

    NSString *evilString = @"c:\foobar<script>alert(23)</script>";
    NSLog(@"evilString: %@", evilString);
    NSString *sanitizedString =[evilString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"sanitizedString: %@", sanitizedString);
    
//    NSURL* url = [NSURL URLWithString: escapedUrlString];
//    NSLog(@"The url is: %@", url);
    
    // Buffer Overflow
    char boo[4];
//    strcpy(boo, "AAAAAAAAAA");
    NSLog(@"Peng!");
    
    
    // sichere Passwort-Speicherung
    NSString *salt = @"foobar";
    NSString *passWithSalt = [NSString stringWithFormat:@"%@%@", salt, pass];
    unsigned char thePass[CC_SHA256_DIGEST_LENGTH];
    NSMutableString *theHash = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH];
    CC_SHA256([passWithSalt UTF8String], [passWithSalt lengthOfBytesUsingEncoding:NSUTF8StringEncoding], thePass);
    for(int i=0; i<CC_SHA256_DIGEST_LENGTH; i++){
        [theHash appendString:[NSString stringWithFormat:@"%02x", thePass[i]]];
    }
    NSLog(@"theHash: %@", theHash);
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
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
