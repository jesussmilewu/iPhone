#import <UIKit/UIKit.h>

@class PieViewController;

@interface PieAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet PieViewController *viewController;

@end
