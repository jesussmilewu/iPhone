#import "PieViewController.h"

@implementation PieViewController

@synthesize pieView;
@synthesize valueLabel;
@synthesize animationSwitch;

- (void)dealloc {
    self.pieView = nil;
    self.animationSwitch = nil;
    self.valueLabel = nil;
    [super dealloc];
}

- (void)viewDidUnload {
    self.pieView = nil;
    self.animationSwitch = nil;
    self.valueLabel = nil;
    [super viewDidUnload];
}

- (IBAction)sliderValueChanged:(id)inSender {
    float theValue = [(UISlider *)inSender value];
    
    self.valueLabel.text = [NSString stringWithFormat:@"%.1f%%", theValue * 100.0];
    if(!animationSwitch.on) {
        self.pieView.part = [(UISlider *)inSender value];                
    }
}

- (IBAction)sliderDidFinish:(id)inSender {
    if(animationSwitch.on) {
        [UIView animateWithDuration:5.0 animations:^{
            self.pieView.part = [(UISlider *)inSender value];        
        }];
    }
}

@end
