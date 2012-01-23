//
//  ModalMainViewController.h
//  Modal
//
//  Created by Clemens Wagner on 23.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ModalViewController.h"

@interface MainViewController : UIViewController

@property (nonatomic, strong) IBOutlet ModalViewController *modalController;

- (IBAction)showInfo;

@end
