#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface HighScoreViewController : UITableViewController {
    @private
}

@property (nonatomic, retain) IBOutlet NSManagedObjectContext *managedObjectContext;

@end
