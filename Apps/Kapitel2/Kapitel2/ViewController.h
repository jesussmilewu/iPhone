//
//  ViewController.h
//  Kapitel2
//
//  Created by Rodewig Klaus on 15.03.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "LogUtility.h"

@interface ViewController : UIViewController <LogUtilityDelegate>
- (IBAction)iterateObjects:(id)sender;
- (IBAction)objectMaster:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *objectCount;
@property (retain, nonatomic) IBOutlet UIStepper *stepper;
@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (strong) Model *model;

@end
