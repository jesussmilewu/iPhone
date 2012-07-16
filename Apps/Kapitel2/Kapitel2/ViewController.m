//
//  ViewController.m
//  Kapitel2
//
//  Created by Rodewig Klaus on 15.03.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import "ViewController.h"
#import "Droid.h"

@class Model;

@implementation ViewController
@synthesize objectCount, stepper, textView, model;

-(void)finishedWithLogging{
    [self logger:@"Finished logging to console"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [textView setText:nil];
    [objectCount setText:@"0"];
    self.model = [[Model alloc] initWithName:@"LoremIpsum"];
    [self logger:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)]];
    [self logger:[NSString stringWithFormat:@"Model.name: %@", [self.model name]]];
    
    [stepper setMaximumValue:10.0];

    [self.model addObserver:self
                forKeyPath:@"status"
                   options:1
                   context:NULL];
    
    [self.model addObserver:self
                 forKeyPath:@"objCount"
                    options:1
                    context:NULL];
    
    LogUtility *consoleLog = [[LogUtility alloc] init];
    consoleLog.delegate = self;
    [consoleLog logToConsole:[self.model name]];
    
}

- (void)viewDidAppear:(BOOL)inAnimated
{
    [super viewDidAppear:inAnimated];
}

- (void)viewWillDisappear:(BOOL)inAnimated
{
    [self.model removeObserver:self forKeyPath:@"status"];
    [self.model removeObserver:self forKeyPath:@"objCount"];
    
    [super viewWillDisappear:inAnimated];
}


- (void)viewDidUnload
{
    [self setTextView:nil];
    [self setStepper:nil];
    [self setObjectCount:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [textView release];
    [stepper release];
    [objectCount release];
    [super dealloc];
}

-(void)logger:(NSString *)logString{    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss.SSS"];
        
    if([[NSString stringWithString:[textView text]] length] == 0)
        [textView setText:[NSString stringWithFormat:@"%@ [+] %@", [formatter stringFromDate:[NSDate date]],logString]];
    else
        [textView setText:[NSString stringWithFormat:@"%@\n%@ [+] %@", [textView text], [formatter stringFromDate:[NSDate date]],logString]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if([keyPath isEqualToString:@"status"])
        [self logger:[NSString stringWithFormat:@"model.status: %@", model.status]];
    else {
        [self logger:[NSString stringWithFormat:@"model.objCount: %@", model.objCount]];
        [objectCount setText:[NSString stringWithFormat:@"%@", model.objCount]];        
    }
}

- (IBAction)iterateObjects:(id)sender {
    [model getObjects];
}

- (IBAction)objectMaster:(id)sender {
    [model handleObject:[NSNumber numberWithDouble:stepper.value]];
}
@end
