//
//  ModalMainViewController.m
//  Modal
//
//  Created by Clemens Wagner on 23.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

- (IBAction)showInfo {
    static NSUInteger theCount = 1;
    ModalViewController *theController = [self.storyboard instantiateViewControllerWithIdentifier:@"modalController"];
    
    theController.title = [NSString stringWithFormat:@"%u", theCount++];
    theController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:theController animated:YES completion:^{
        NSLog(@"finished");
    }];
}

@end
