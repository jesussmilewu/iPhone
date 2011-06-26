//
//  iClousAppDelegate.h
//  iClous
//
//  Created by Rodewig Klaus on 26.06.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DeviceInfo.h"

@interface iClousAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate>
{
    CLLocationManager	*cllMgr;
    UITextView			*thisTextView;
    UIWindow			*thisWindow;
    int                 cnt; // for Clemens
    DeviceInfo          *thisDevice;
}

@property (strong, nonatomic) UIWindow *window;

@end
