//
//  ModalAppDelegate.m
//  Modal
//
//  Created by Clemens Wagner on 23.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ModalAppDelegate.h"

#import "MainViewController.h"

@implementation ModalAppDelegate

@synthesize window;
@synthesize mainViewController;

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inOptions {
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
