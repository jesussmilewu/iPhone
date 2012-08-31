#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface HighScoreViewController : UITableViewController

@property (nonatomic, weak) IBOutlet NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) IBOutlet UISegmentedControl *filterControl;

- (IBAction)filterChanged;
- (IBAction)clear;

@end
