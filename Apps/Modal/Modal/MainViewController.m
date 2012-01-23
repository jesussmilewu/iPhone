//
//  ModalMainViewController.m
//  Modal
//
//  Created by Clemens Wagner on 23.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

@synthesize modalController;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    self.modalController = nil;
    [super viewDidUnload];
}

- (IBAction)showInfo {
    static NSUInteger theCount = 1;
    ModalViewController *theController = self.modalController;

    theController.title = [NSString stringWithFormat:@"%u", theCount++];
    theController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:theController animated:YES];
}

#pragma mark ModalViewControllerDelegate

- (void)flipsideViewControllerDidFinish:(ModalViewController *)inController {
    [self dismissModalViewControllerAnimated:YES];
}

@end
