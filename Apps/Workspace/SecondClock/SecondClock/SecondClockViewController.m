//
//  SecondClockViewController.m
//  SecondClock
//
//  Created by Clemens Wagner on 10.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SecondClockViewController.h"

@implementation SecondClockViewController

@synthesize clockView;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setClockView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    [self.clockView startAnimation];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [self.clockView stopAnimation];
	[super viewWillDisappear:inAnimated];
}

- (void)viewDidDisappear:(BOOL)inAnimated {
	[super viewDidDisappear:inAnimated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return YES;
}

@end
