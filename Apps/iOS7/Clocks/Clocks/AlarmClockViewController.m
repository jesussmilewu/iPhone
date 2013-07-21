//
//  AlarmClockViewController.m
//  Clocks
//
//  Created by Clemens Wagner on 21.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "AlarmClockViewController.h"
#import "ClockView.h"

@interface AlarmClockViewController ()

@property (strong, nonatomic) IBOutletCollection(ClockView) NSArray *clockViews;
@property (weak, nonatomic) IBOutlet UISwitch *animationSwitch;

- (IBAction)switchAnimation:(UISwitch *)inSender;

@end

@implementation AlarmClockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startAnimations {
    // for(ClockView *theView in self.view.subviews) { // Variante mit Containerview ohne Outlet-Collections
    // for(ClockView *theView in self.clockViews) {
    //     [theView startAnimation];
    // }
    [self.clockViews makeObjectsPerformSelector:@selector(startAnimation)];
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    [self switchAnimation:self.animationSwitch];
}

- (void)stopAnimations {
    // for(ClockView *theView in self.view.subviews) { // Variante mit Containerview ohne Outlet-Collections
    // for(ClockView *theView in self.clockViews) {
    //     [theView stopAnimation];
    // }
    [self.clockViews makeObjectsPerformSelector:@selector(stopAnimation)];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [self stopAnimations];
    [super viewWillDisappear:inAnimated];
}

- (IBAction)switchAnimation:(UISwitch *)inSender {
    if(inSender.on) {
        [self startAnimations];
    }
    else {
        [self stopAnimations];
    }
}

@end
