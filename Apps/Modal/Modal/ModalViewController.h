//
//  ModalFlipsideViewController.h
//  Modal
//
//  Created by Clemens Wagner on 23.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModalViewController;

@interface ModalViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, copy) NSString *title;

- (IBAction)done;

@end
