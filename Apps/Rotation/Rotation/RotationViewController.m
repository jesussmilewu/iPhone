#import "RotationViewController.h"

@implementation RotationViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return rotationControl.selectedSegmentIndex || inInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)dealloc {
    [rotationControl release];
    [super dealloc];
}

@end
