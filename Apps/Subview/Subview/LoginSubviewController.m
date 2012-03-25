//
//  LoginSubviewController.m
//  Subview
//
//  Created by Clemens Wagner on 25.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginSubviewController.h"

@implementation LoginSubviewController

@dynamic delegate;
@synthesize loginField;
@synthesize passwordField;
@synthesize loginButton;

- (IBAction)cancel {
    self.visible = NO;
    if([self.delegate respondsToSelector:@selector(loginSubviewControllerDidCancel:)]) {
        [self.delegate loginSubviewControllerDidCancel:self];
    }
}

- (IBAction)login {
    self.visible = NO;
    [self.delegate loginSubviewController:self 
                            loginWithUser:self.loginField.text 
                                 password:self.passwordField.text];
}

- (IBAction)textFieldChanged {
    self.loginButton.enabled = self.loginField.text.length > 5 && self.passwordField.text.length > 5;
}

- (void)subviewWillAppear {
    [super subviewWillAppear];
    self.loginField.text = @"";
    self.passwordField.text = @"";
    self.loginButton.enabled = NO;
}

- (void)subviewWillDisappear {
    [self.view endEditing:YES];
    [super subviewWillDisappear];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)inTextField {
    if(self.loginField == inTextField) {
        [self.passwordField becomeFirstResponder];
    }
    else {
        if(self.loginButton.enabled) {
            [self login];
        }
    }
    return NO;        
}

@end
