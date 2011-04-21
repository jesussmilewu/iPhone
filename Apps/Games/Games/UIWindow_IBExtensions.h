//
//  UIWindow_IBExtensions.h
//  Games
//
//  Created by Clemens Wagner on 13.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIWindow(IBExtensions)

@property(nonatomic,retain) IBOutlet UIViewController *rootViewController;

@end
