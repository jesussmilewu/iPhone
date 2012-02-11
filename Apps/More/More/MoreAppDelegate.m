#import "MoreAppDelegate.h"

@implementation MoreAppDelegate


@synthesize window;

@synthesize tabBarController;

- (void)restoreTabBar {
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *theIndexes = [theDefaults arrayForKey:@"tabBarItems"];
    NSArray *theViewControllers = self.tabBarController.viewControllers;
    
    if(theIndexes.count == theViewControllers.count) {
        NSMutableArray *theControllers = [NSMutableArray arrayWithCapacity:theIndexes.count];
        
        for(NSNumber *theIndex in theIndexes) {
            NSUInteger theValue = theIndex.unsignedIntValue;
            [theControllers addObject:[theViewControllers objectAtIndex:theValue]];
        }
        self.tabBarController.viewControllers = theControllers;
    }
}

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inLaunchOptions {
    NSArray *theControllers = self.tabBarController.viewControllers;
    NSUInteger theIndex = 0;
    
    for (UIViewController *theController in theControllers) {
        theController.tabBarItem.tag = theIndex++;
    }
    [self restoreTabBar];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc {
    self.window = nil;
    self.tabBarController = nil;
    [super dealloc];
}

# pragma mark UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)inController willEndCustomizingViewControllers:(NSArray *)inControllers changed:(BOOL)inChanged {
    if(inChanged) {
        NSArray *theIndexes = [inControllers valueForKeyPath:@"tabBarItem.tag"];
        NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
        
        [theDefaults setObject:theIndexes forKey:@"tabBarItems"];
        [theDefaults synchronize];
    }
}

@end
