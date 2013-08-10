//
//  RetinaViewController.m
//  Retina
//
//  Created by Clemens Wagner on 02.08.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "RetinaViewController.h"

@interface RetinaViewController ()

@property (nonatomic, retain) IBOutlet UILabel *displayLabel;

@end

@implementation RetinaViewController

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    float theScale = [[UIScreen mainScreen] scale];

    self.displayLabel.text = [NSString stringWithFormat:@"scale = %.2f (%@)",
                              theScale, theScale > 1.0 ? @"Retina" : @"Normal"];
}

@end
