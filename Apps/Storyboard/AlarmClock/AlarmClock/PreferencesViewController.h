#import <UIKit/UIKit.h>
#import "ClockView.h"

@interface PreferencesViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UISwitch *digitsSwitch;
@property (strong, nonatomic) IBOutlet UISegmentedControl *partitionControl;
@property (strong, nonatomic) IBOutlet UISwitch *soundSwitch;

- (IBAction)savePreferences;
- (IBAction)restorePreferences;

@end