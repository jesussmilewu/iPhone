#import "ClockViewController.h"
#import "ClockView.h"

@implementation ClockViewController

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [switchButton setTitle:[switchButton titleForState:UIControlStateHighlighted] forState:UIControlStateSelected | UIControlStateHighlighted];
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [super viewWillDisappear:inAnimated];
}

- (IBAction)switchAnimation:(UIButton *)inSender {
    inSender.selected = !inSender.selected;
    if(inSender.selected) {
        [clockView startAnimation];
    }
    else {
        [clockView stopAnimation];        
    }
}

@end
