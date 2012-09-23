//
//  KMRAppDelegate.h
//  iclous
//
//  Created by Klaus Rodewig on 18.09.12.
//  Copyright (c) 2012 Foobar Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KMRViewController;

@interface KMRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) KMRViewController *viewController;

@end
