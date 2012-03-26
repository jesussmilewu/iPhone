//
//  ViewController.m
//  Kapitel2
//
//  Created by Rodewig Klaus on 15.03.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize textView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [textView setText:nil];
    [self logger:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)]];
}


- (void)viewDidUnload
{
    [self setTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [textView release];
    [super dealloc];
}

-(void)logger:(NSString *)logString{
    NSLog(@"[+] %@.%@", self, NSStringFromSelector(_cmd));
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss.SSS"];
        
    if([[NSString stringWithString:[textView text]] length] == 0)
        [textView setText:[NSString stringWithFormat:@"%@ [+] %@", [formatter stringFromDate:[NSDate date]],logString]];
    else
        [textView setText:[NSString stringWithFormat:@"%@\n%@ [+] %@", [textView text], [formatter stringFromDate:[NSDate date]],logString]];
}

@end
