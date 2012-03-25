//
//  ViewController.h
//  Subview
//
//  Created by Clemens Wagner on 25.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginSubviewController.h"

@interface ViewController : UIViewController<LoginSubviewControllerDelegate>

@property (strong, nonatomic) IBOutlet LoginSubviewController *loginSubviewController;

- (IBAction)showLogin:(id)inSender;

@end
