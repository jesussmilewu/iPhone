//
//  AppDelegate.h
//  Speicher
//
//  Created by Rodewig Klaus on 17.07.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableArray *employees;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
