#import "RotationAppDelegate.h"
#import "RotationViewController.h"

@implementation RotationAppDelegate

@synthesize window;
@synthesize viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

/*
- (NSUInteger)application:(UIApplication *)inApplication supportedInterfaceOrientationsForWindow:(UIWindow *)inWindow {
    return UIInterfaceOrientationMaskAll;
}
 */

@end
