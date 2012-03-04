//
//  ViewController.h
//  MultipleAlertViews
//
//  Created by Clemens Wagner on 04.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)chooseImage:(id)inSender;
- (IBAction)chooseTitle:(id)inSender;

@end
