//
//  ViewController.m
//  Subview
//
//  Created by Clemens Wagner on 25.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize loginSubviewController;

- (void)viewDidUnload {
    self.loginSubviewController = nil;
    [super viewDidUnload];
}

- (IBAction)showLogin:(id)inSender {
    self.loginSubviewController.visible = YES;
}

#pragma mark SubviewControllerDelegate

- (void)subviewControllerWillAppear:(SubviewController *)inController {
    NSLog(@"subviewControllerWillAppear");
}

- (void)subviewControllerWillDisappear:(SubviewController *)inController {
    NSLog(@"subviewControllerWillDisappear");    
}

#pragma mark LoginSubviewControllerDelegate

- (void)loginSubviewController:(LoginSubviewController *)inController 
                 loginWithUser:(NSString *)inUser 
                      password:(NSString *)inPassword {
    // Achtung: Sicherheitslücke!
    // Die Zugangsdaten stehen ungeschützt in der Log-Datei
    NSLog(@"login = %@, password = %@", inUser, inPassword);    
}
@end
