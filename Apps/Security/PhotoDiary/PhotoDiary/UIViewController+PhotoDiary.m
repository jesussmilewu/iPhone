#import "UIViewController+PhotoDiary.h"

@implementation UIViewController (PhotoDiary)

- (PhotoDiaryAppDelegate *)applicationDelegate {
    return (id)[[UIApplication sharedApplication] delegate];
}

- (NSManagedObjectContext *)managedObjectContext {
    return self.applicationDelegate.managedObjectContext;
}

@end
