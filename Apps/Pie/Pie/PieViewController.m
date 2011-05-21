#import "PieViewController.h"

@implementation PieViewController

@synthesize pieView;

- (void)dealloc {
    self.pieView = nil;
    [super dealloc];
}

- (void)viewDidUnload {
    self.pieView = nil;
    [super viewDidUnload];
}

- (IBAction)sliderValueChanged:(id)inSender {
}

- (IBAction)sliderDidFinish:(id)inSender {
    [UIView animateWithDuration:1.0 animations:^{
        self.pieView.part = [(UISlider *)inSender value];        
    }];
}

@end
