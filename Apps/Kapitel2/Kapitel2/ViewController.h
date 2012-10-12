//
//  ViewController.h
//  Kapitel2
//
//  Created by Rodewig Klaus on 15.03.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "Log.h"

@interface ViewController : UIViewController <LogDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong) Model *model;

- (IBAction)updateModel:(UIStepper *)sender;

@end
