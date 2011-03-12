#import <UIKit/UIKit.h>

@class AccessoryTableViewController;

@interface AccessoryTableViewAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet AccessoryTableViewController *viewController;

@end
