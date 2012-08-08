//
//  ViewController.m
//  VerySecure
//
//  Created by Klaus Rodewig on 08.08.12.
//  Copyright (c) 2012 Klaus Rodewig. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize nameField;
@synthesize passwordField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [passwordField setSecureTextEntry:YES];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setNameField:nil];
    [self setPasswordField:nil];
    [self setPasswordField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
