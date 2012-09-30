#import "RotationViewController.h"

@implementation RotationViewController

@synthesize rotationControl;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    NSLog(@"shouldAutorotateToInterfaceOrientation: %d", self.rotationControl.selectedSegmentIndex);
    return self.rotationControl.selectedSegmentIndex || inInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    NSLog(@"shouldAutorotate: %d", self.rotationControl.selectedSegmentIndex);
    return self.rotationControl.selectedSegmentIndex;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
