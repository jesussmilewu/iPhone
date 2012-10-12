//
//  ViewController.m
//  Kapitel2
//
//  Created by Rodewig Klaus on 15.03.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import "ViewController.h"
#import "Droid.h"

@interface ViewController()

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation ViewController

@synthesize countLabel;
@synthesize textView;
@synthesize model;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textView setText:nil];
    [self.countLabel setText:@"0"];
    [self writeLog:[NSString stringWithFormat:@"%@", NSStringFromSelector(_cmd)]];
    self.model = [[Model alloc] initWithName:@"LoremIpsum"];
    [self writeLog:[NSString stringWithFormat:@"Model.name: %@", [self.model name]]];
    
    Log *theLog = [[Log alloc] init];
    theLog.delegate = self;
    [theLog logToConsole:[self.model name]];
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    [self.model addObserver:self
                 forKeyPath:@"status"
                    options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context:NULL];
    [self.model addObserver:self
                 forKeyPath:@"countOfObjects"
                    options:NSKeyValueObservingOptionNew
                    context:NULL];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [self.model removeObserver:self forKeyPath:@"status"];
    [self.model removeObserver:self forKeyPath:@"countOfObjects"];    
    [super viewWillDisappear:inAnimated];
}


- (void)viewDidUnload {
    [self setTextView:nil];
    [self setCountLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


-(void)writeLog:(NSString *)inLogString {
    NSLog(@"[+] %@.%@", self, NSStringFromSelector(_cmd));
    NSDateFormatter *theFormatter = [[NSDateFormatter alloc] init];
    
    [theFormatter setDateFormat:@"HH:mm:ss.SSS"];
    [self.textView setText:[NSString stringWithFormat:@"%@\n%@ [+] %@",
                            [self.textView text],
                            [theFormatter stringFromDate:[NSDate date]], inLogString]];
}

- (void)observeValueForKeyPath:(NSString *)inKeyPath
                      ofObject:(id)inObject
                        change:(NSDictionary *)inChange
                       context:(void *)inContext {
    if([inKeyPath isEqualToString:@"status"]) {
        NSLog(@"[+] Old status:%@", [inChange valueForKey:NSKeyValueChangeOldKey]);
        NSLog(@"[+] New status:%@", [inChange valueForKey:NSKeyValueChangeNewKey]);
    }
    else {
        [self.countLabel setText:[NSString stringWithFormat:@"%d", [inObject countOfObjects]]];
    }
}

- (IBAction)listModel:(id)sender {
    [self.model listDroids];
}

- (IBAction)updateModel:(UIStepper *)sender {
    NSInteger theValue = [sender value];
    
    [self.model updateDroids:theValue];
    [self writeLog:[NSString stringWithFormat:@"countOfObjects = %d", [self.model countOfObjects]]];
}

-(void)logDidFinishLogging:(Log *)inLog {
    [self writeLog:@"Finished logging to console"];
}

@end
