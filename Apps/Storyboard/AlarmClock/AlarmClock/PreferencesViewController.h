#import <UIKit/UIKit.h>
#import "ClockView.h"

@interface PreferencesViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *digitsSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *partitionControl;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;

- (IBAction)savePreferences;
- (IBAction)restorePreferences;

@end