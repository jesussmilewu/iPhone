#import "ClockViewController.h"
#import "ClockView.h"

@implementation ClockViewController

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    if(clockSwitch.on) {
        [clockView startAnimation];
    }
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [super viewWillDisappear:inAnimated];
    [clockView stopAnimation];        
}

- (IBAction)switchAnimation:(UISwitch *)inSender {
    if(inSender.on) {
        [clockView startAnimation];
    }
    else {
        [clockView stopAnimation];        
    }
}

@end
