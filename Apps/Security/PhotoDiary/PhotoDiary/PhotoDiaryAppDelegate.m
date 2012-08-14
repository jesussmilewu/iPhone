#import "PhotoDiaryAppDelegate.h"
#import "PhotoDiaryViewController.h"

@interface PhotoDiaryAppDelegate()

@property (nonatomic, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readwrite) NSPersistentStoreCoordinator *storeCoordinator;

@end

@implementation PhotoDiaryAppDelegate

@synthesize window;
@synthesize overviewButton;
@synthesize viewController;
@synthesize managedObjectContext;

@synthesize managedObjectModel;
@synthesize storeCoordinator;

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inLaunchOptions {
    self.managedObjectContext = [[NSManagedObjectContext alloc] init];
    self.managedObjectContext.persistentStoreCoordinator = self.storeCoordinator;
    self.viewController = self.window.rootViewController;
    if([self.viewController isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *theController = (UISplitViewController *)self.viewController;
        UINavigationController *theDetailController = theController.viewControllers.lastObject;
        
        theController.delegate = [theDetailController.viewControllers objectAtIndex:0];
    }
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)inApplication {
    srand((unsigned) [NSDate timeIntervalSinceReferenceDate]);
}

- (NSURL *)applicationDocumentsURL {
    NSFileManager *theManager = [NSFileManager defaultManager];
    
    return [[theManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (NSManagedObjectModel *)managedObjectModel {
    if(managedObjectModel == nil) {
        NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        
        self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:theURL];    
    }
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)storeCoordinator {
    if(storeCoordinator == nil) {
        NSURL *theURL = [[self applicationDocumentsURL] URLByAppendingPathComponent:@"Diary.sqlite"];
        NSError *theError = nil;
        NSPersistentStoreCoordinator *theCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        if ([theCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil 
                                                   URL:theURL options:nil error:&theError]) {
            self.storeCoordinator = theCoordinator;
        }
        else {
            NSLog(@"storeCoordinator: %@", theError);
        }
    }
    return storeCoordinator;
}

- (void)showPhotoDiaryViewController:(id)inSender {
    
}

@end
