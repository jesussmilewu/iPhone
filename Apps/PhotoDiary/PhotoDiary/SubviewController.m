#import "SubviewController.h"

@implementation SubviewController

@synthesize delegate;
@synthesize view;

- (void)dealloc {
    self.delegate = nil;
    [super dealloc];
}

- (void)addViewToViewController:(UIViewController *)inViewController {
    if(self.view.superview == nil) {
        UIView *theView = inViewController.view;
        
        self.view.frame = theView.bounds;
        [theView addSubview:self.view];
        [self setVisible:NO];
    }
}

- (BOOL)visible {
    return self.view.alpha > 0.01;
}

- (void)setVisible:(BOOL)inVisible {
    UIView *theView = self.view;
    SEL theSelector;
    
    theView.frame = theView.superview.bounds;
    if(inVisible) {
        theView.alpha = 1.0;
        theSelector = @selector(subviewControllerWillAppear:);
        [theView.superview bringSubviewToFront:theView];
    }
    else {
        theView.alpha = 0.0;
        theSelector = @selector(subviewControllerWillDisappear:);
    }
    [self clear];
    if([self.delegate respondsToSelector:theSelector]) {
        [self.delegate performSelector:theSelector withObject:self];
    }
}

- (void)setVisible:(BOOL)inVisible animated:(BOOL)inAnimated {
    if(inAnimated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        self.visible = inVisible;
        [UIView commitAnimations];
    }
    else {
        self.visible = inVisible;
    }
}

- (IBAction)clear {
}

@end
