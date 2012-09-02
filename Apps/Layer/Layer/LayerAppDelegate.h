#import <UIKit/UIKit.h>

@class LayerViewController;

@interface LayerAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet LayerViewController *viewController;

@end
