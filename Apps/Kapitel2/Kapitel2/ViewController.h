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

<<<<<<< HEAD
@interface ViewController : UIViewController <LogUtilityDelegate>
=======
@interface ViewController : UIViewController <LogDelegate>
>>>>>>> 6cc8a5bf717bdf3814324db8a23a3cc8a5f6b337

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong) Model *model;

- (IBAction)updateModel:(UIStepper *)sender;

@end
