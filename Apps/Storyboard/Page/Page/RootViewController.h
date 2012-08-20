//
//  RootViewController.h
//  Page
//
//  Created by Clemens Wagner on 30.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *orientationControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *spineLocationControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *doubleSidedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *directionControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *animationControl;

- (IBAction)create;

@end
