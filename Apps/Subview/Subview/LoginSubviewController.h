//
//  LoginSubviewController.h
//  Subview
//
//  Created by Clemens Wagner on 25.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubviewController.h"

@class LoginSubviewController;

@protocol LoginSubviewControllerDelegate<SubviewControllerDelegate>

- (void)loginSubviewController:(LoginSubviewController *)inController 
                 loginWithUser:(NSString *)inUser password:(NSString *)inPass;

@optional
- (void)loginSubviewControllerDidCancel:(LoginSubviewController *)inController;  

@end

@interface LoginSubviewController : SubviewController<UITextFieldDelegate>

@property(nonatomic, assign) IBOutlet id<LoginSubviewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *loginField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)cancel;
- (IBAction)login;
- (IBAction)textFieldChanged;

@end

