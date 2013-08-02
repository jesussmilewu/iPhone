//
//  SegueViewController.m
//  Segue
//
//  Created by Clemens Wagner on 24.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "SegueViewController.h"
#import "ResultViewController.h"

@interface SegueViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation SegueViewController

- (void)prepareForSegue:(UIStoryboardSegue *)inSegue sender:(id)inSender {
    if([inSegue.identifier isEqualToString:@"dialog"]) {
        ResultViewController *theController = inSegue.destinationViewController;

        theController.birthDate = self.datePicker.date;
    }
}

@end
