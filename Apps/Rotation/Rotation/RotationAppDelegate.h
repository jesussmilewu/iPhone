#import <UIKit/UIKit.h>

@class RotationViewController;

@interface RotationAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet RotationViewController *viewController;

@end
