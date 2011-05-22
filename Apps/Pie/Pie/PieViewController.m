#import "PieViewController.h"
#import <QuartzCore/QuartzCore.h>

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

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *theRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    CATransform3D theTransform = CATransform3DIdentity;
    
    theTransform.m34 = 1.0 / -1000;
    self.view.layer.sublayerTransform = theTransform;
    [self.pieView addGestureRecognizer:theRecognizer];
    [theRecognizer release];
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
        void (^theAnimation)(void) = ^{
            self.pieView.part = [(UISlider *)inSender value];
        };

        [UIView animateWithDuration:3 animations:theAnimation];
    }
}

- (void)handleTap:(UIGestureRecognizer *)inRecognizer {
    CALayer *theLayer = self.pieView.layer;
    CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    
    theAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    theAnimation.duration = 3.0;
    [theLayer addAnimation:theAnimation forKey:@"rotate"];
}

@end
