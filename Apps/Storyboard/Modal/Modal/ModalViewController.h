//
//  ModalFlipsideViewController.h
//  Modal
//
//  Created by Clemens Wagner on 23.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModalFlipsideViewController;

@protocol ModalFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(ModalFlipsideViewController *)controller;
@end

@interface ModalFlipsideViewController : UIViewController

@property (weak, nonatomic) IBOutlet id <ModalFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
