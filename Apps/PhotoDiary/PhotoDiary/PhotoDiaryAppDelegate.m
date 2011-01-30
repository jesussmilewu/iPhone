#import "PhotoDiaryAppDelegate.h"
#import "PhotoDiaryViewController.h"

@interface PhotoDiaryAppDelegate()

@property (nonatomic, retain, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readwrite) NSPersistentStoreCoordinator *storeCoordinator;

@end

@implementation PhotoDiaryAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize managedObjectContext;

@synthesize managedObjectModel;
@synthesize storeCoordinator;

- (void)dealloc {
    self.viewController = nil;
    self.window = nil;
    self.managedObjectContext = nil;
    self.managedObjectModel = nil;
    self.storeCoordinator = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inLaunchOptions {
    self.managedObjectContext.persistentStoreCoordinator = self.storeCoordinator;
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
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
        
        self.managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:theURL] autorelease];    
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
        [theCoordinator release];
    }
    return storeCoordinator;
}

@end
