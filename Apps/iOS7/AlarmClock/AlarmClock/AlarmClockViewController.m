//
//  AlarmClockViewController.m
//  AlarmClock
//
//  Created by Clemens Wagner on 17.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "AlarmClockViewController.h"
#import "ClockView.h"
#import "ClockControl.h"

@interface AlarmClockViewController ()

@property (weak, nonatomic) IBOutlet ClockView *clockView;
@property (weak, nonatomic) IBOutlet ClockControl *clockControl;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (IBAction)updateTimeLabel;

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

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    [self.clockView startAnimation];
}
- (void)viewWillDisappear:(BOOL)inAnimated {
    [self.clockView stopAnimation];
    [super viewWillDisappear:inAnimated];
}

- (IBAction)updateTimeLabel {
    NSInteger theTime = round(self.clockControl.time / 60.0);
    NSInteger theMinutes = theTime % 60;
    NSInteger theHours = theTime / 60;

    self.timeLabel.text = [NSString stringWithFormat:@"%d:%02d", theHours, theMinutes];
}

@end
