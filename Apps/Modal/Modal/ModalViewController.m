//
//  ModalFlipsideViewController.m
//  Modal
//
//  Created by Clemens Wagner on 23.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ModalViewController.h"

@implementation ModalViewController

@synthesize titleLabel;
@synthesize title;

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    self.titleLabel.text = self.title;
}

- (IBAction)done {
    [self dismissModalViewControllerAnimated:YES];
}

@end
