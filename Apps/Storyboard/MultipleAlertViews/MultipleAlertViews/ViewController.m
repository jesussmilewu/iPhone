//
//  ViewController.m
//  MultipleAlertViews
//
//  Created by Clemens Wagner on 04.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

typedef void (^AlertViewCallback)(UIAlertView *inAlertView, NSUInteger inButton);

@interface ViewController()<UIAlertViewDelegate>

@property (nonatomic, copy) AlertViewCallback alertViewCallback;

@end

@implementation ViewController
@synthesize imageView;
@synthesize titleLabel;

@synthesize alertViewCallback;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
}

- (IBAction)chooseImage:(id)inSender {
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Choose Image", @"") 
                                                       message:NSLocalizedString(@"Please choose an image.", @"")
                                                      delegate:self 
                                             cancelButtonTitle:NSLocalizedString(@"Cancel", @"") 
                                             otherButtonTitles:NSLocalizedString(@"Dragonfly", @""), NSLocalizedString(@"Flower", @""), nil];
    
    self.alertViewCallback = ^(UIAlertView *inAlertView, NSUInteger inButton) {
        if(inButton > 0) {
            NSString *theName = inButton == 1 ? @"dragonfly.jpg" : @"flower.jpg";
            
            self.imageView.image = [UIImage imageNamed:theName];
        }
    };
    [theAlert show];
}

- (IBAction)chooseTitle:(id)inSender {
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Choose Title", @"") 
                                                       message:NSLocalizedString(@"Please choose a title.", @"")
                                                      delegate:self 
                                             cancelButtonTitle:NSLocalizedString(@"Cancel", @"") 
                                             otherButtonTitles:NSLocalizedString(@"Dragonfly", @""), NSLocalizedString(@"Flower", @""), nil];
    
    self.alertViewCallback = ^(UIAlertView *inAlertView, NSUInteger inButton) {
        if(inButton > 0) {
            self.titleLabel.text = inButton == 1 ? NSLocalizedString(@"Dragonfly", @"") : NSLocalizedString(@"Flower", @"");
        }
    };
    [theAlert show];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)inAlertView clickedButtonAtIndex:(NSInteger)inButton {
    AlertViewCallback theCallback = self.alertViewCallback;
    
    self.alertViewCallback = nil;
    theCallback(inAlertView, inButton);
}

@end
