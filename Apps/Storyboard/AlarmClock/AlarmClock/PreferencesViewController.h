#import <UIKit/UIKit.h>
#import "ClockView.h"

@protocol PreferencesViewControllerDelegate;

@interface PreferencesViewController : UITableViewController

@property (weak, nonatomic) IBOutlet id<PreferencesViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UISwitch *digitsSwitch;
@property (strong, nonatomic) IBOutlet UISegmentedControl *partitionControl;
@property (strong, nonatomic) IBOutlet UISwitch *soundSwitch;

- (IBAction)updatePreferences;

@end

@protocol PreferencesViewControllerDelegate<NSObject>

- (void)preferencesViewControllerDidUpdatePreferences:(PreferencesViewController *)inController;

@end