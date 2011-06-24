//
//  iClousAppDelegate.h
//  iClous
//
//  Created by Rodewig Klaus on 24.06.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iClousViewController;

@interface iClousAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) iClousViewController *viewController;

@end
