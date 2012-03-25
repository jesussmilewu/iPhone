#import <Foundation/Foundation.h>

@protocol SubviewControllerDelegate;

@interface SubviewController : NSObject

@property(nonatomic, assign) IBOutlet id<SubviewControllerDelegate> delegate;
@property(nonatomic) BOOL visible;
@property(nonatomic, copy) NSString *nibName;
@property(nonatomic, strong) IBOutlet UIView *view;
@property(nonatomic, assign) IBOutlet UIViewController *viewController;

- (void)loadView;
- (void)viewDidLoad;
- (void)subviewWillAppear;
- (void)subviewWillDisappear;

@end

@protocol SubviewControllerDelegate<NSObject>

@optional
- (void)subviewControllerWillAppear:(SubviewController *)inController;
- (void)subviewControllerWillDisappear:(SubviewController *)inController;

@end
