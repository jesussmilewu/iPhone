#import "RotationViewController.h"

@implementation RotationViewController

-(void)viewDidUnload {
    [rotationControl release];
    rotationControl = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return rotationControl.selectedSegmentIndex || inInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)dealloc {
    [rotationControl release];
    rotationControl = nil;
    [super dealloc];
}

@end
