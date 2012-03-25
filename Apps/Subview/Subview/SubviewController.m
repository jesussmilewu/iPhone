#import "SubviewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SubviewController()

@end

@implementation SubviewController

@synthesize nibName;
@synthesize delegate;
@synthesize view;
@synthesize viewController;

- (NSString *)nibName {
    if(nibName == nil) {
        self.nibName = NSStringFromClass([self class]);
    }
    return nibName;
}

- (UIView *)view {
    if(view == nil) {
        [self loadView];
    }
    return view;
}

- (void)loadView {
    NSBundle *theBundle = [NSBundle mainBundle];

    [theBundle loadNibNamed:self.nibName owner:self options:nil];
    [self viewDidLoad];
}

- (void)viewDidLoad {
    CALayer *theLayer = self.view.layer;
    
    theLayer.cornerRadius = 10;
    theLayer.masksToBounds = YES;
}

- (UIView *)backgroundViewWithFrame:(CGRect)inFrame forView:(UIView *)inView {
    if(inView == nil) {
        NSLog(@"Error: Outlet view is not set for %@.", self);
        return nil;
    }
    else {
        CGRect theFrame = inView.frame;
        UIView *theBackgroundView = [[UIView alloc] initWithFrame:inFrame];
        
        theFrame.origin.x = (CGRectGetWidth(inFrame) - CGRectGetWidth(theFrame)) / 2.0;
        theFrame.origin.y = (CGRectGetHeight(inFrame) - CGRectGetHeight(theFrame)) / 3.0;
        theBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];        
        [theBackgroundView addSubview:inView];
        inView.frame = theFrame;
        return theBackgroundView;
    }
}

- (BOOL)visible {
    return view.superview != nil;
}

- (void)setVisible:(BOOL)inVisible {
    if(inVisible != self.visible) {
        if(inVisible) {
            UIView *theMainView = self.viewController.view;
            UIView *theView = [self backgroundViewWithFrame:theMainView.bounds
                                                    forView:self.view];
            
            [self subviewWillAppear];
            [theMainView addSubview:theView];
            if([self.delegate respondsToSelector:@selector(subviewControllerWillAppear:)]) {
                [self.delegate subviewControllerWillAppear:self];
            }
        }
        else {
            UIView *theView = self.view;
            
            [self subviewWillDisappear];
            [theView.superview removeFromSuperview];
            [theView removeFromSuperview];
            if([self.delegate respondsToSelector:@selector(subviewControllerWillDisappear:)]) {
                [self.delegate subviewControllerWillDisappear:self];
            }
        }
    }
}

- (void)subviewWillAppear {
}

- (void)subviewWillDisappear {
}

@end
