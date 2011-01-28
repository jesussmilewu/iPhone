//
//  RotationAppDelegate.h
//  Rotation
//
//  Created by Clemens Wagner on 28.01.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RotationViewController;

@interface RotationAppDelegate : NSObject <UIApplicationDelegate> {
@private

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet RotationViewController *viewController;

@end
