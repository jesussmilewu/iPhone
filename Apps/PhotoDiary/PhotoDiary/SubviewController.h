#import <Foundation/Foundation.h>

@protocol SubviewControllerDelegate;

@interface SubviewController : NSObject {
    @private
}

@property(nonatomic, assign) IBOutlet id<SubviewControllerDelegate> delegate;
@property(nonatomic, retain) IBOutlet UIView *view;
@property(nonatomic) BOOL visible;

- (void)addViewToViewController:(UIViewController *)inViewController;
- (void)setVisible:(BOOL)inVisible animated:(BOOL)inAnimated;

- (IBAction)clear;

@end

@protocol SubviewControllerDelegate<NSObject>

@optional
- (void)subviewControllerWillAppear:(SubviewController *)inController;
- (void)subviewControllerWillDisappear:(SubviewController *)inController;

@end
