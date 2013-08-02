//
//  AppDelegate.m
//  MAC
//
//  Created by Klaus Rodewig on 17.07.13.
//  Copyright (c) 2013 Foobar. All rights reserved.
//

#import "AppDelegate.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    /* Original source code courtesy John from iOSDeveloperTips.com */
    

    
        int mgmtInfoBase[6];
        char *msgBuffer = NULL;
        NSString *errorFlag = NULL;
        size_t length;
        // Setup the management Information Base (mib)
        mgmtInfoBase[0] = CTL_NET; // Request network subsystem
        mgmtInfoBase[1] = AF_ROUTE; // Routing table info
        mgmtInfoBase[2] = 0;
        mgmtInfoBase[3] = AF_LINK; // Request link layer information
        mgmtInfoBase[4] = NET_RT_IFLIST; // Request all configured interfaces
        // With all configured interfaces requested, get handle index
        if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
            errorFlag = @"if_nametoindex failure";
        // Get the size of the data available (store in len)
        else if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        // Alloc memory based on above call
        else if ((msgBuffer = malloc(length)) == NULL)
            errorFlag = @"buffer allocation failure";
        // Get system information, store in buffer
        else if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
        {
            free(msgBuffer);
            errorFlag = @"sysctl msgBuffer failure";
        }
        else
        {
            // Map msgbuffer to interface message structure
            struct if_msghdr *interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
            // Map to link-level socket structure
            struct sockaddr_dl *socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
            // Copy link layer address data in socket structure to an array
            unsigned char macAddress[6];
            memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
            // Read from char array into a string object, into traditional Mac address format
            NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                          macAddress[0], macAddress[1], macAddress[2], macAddress[3], macAddress[4], macAddress[5]];
            NSLog(@"Mac Address: %@", macAddressString);
            // Release the buffer memory
            free(msgBuffer);
            NSLog(@"mac: %@", macAddressString);
        }
        // Error...
        NSLog(@"Error: %@", errorFlag);

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
