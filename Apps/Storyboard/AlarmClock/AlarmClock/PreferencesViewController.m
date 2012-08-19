#import "PreferencesViewController.h"

@implementation PreferencesViewController

@synthesize digitsSwitch;
@synthesize partitionControl;
@synthesize soundSwitch;

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    [self restorePreferences];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [self savePreferences];
    [super viewWillDisappear:inAnimated];
}

- (IBAction)savePreferences {
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
    
    [theDefaults setBool:self.digitsSwitch.on forKey:@"showDigits"];
    [theDefaults setInteger:self.partitionControl.selectedSegmentIndex 
                     forKey:@"partitionOfDial"];
    [theDefaults setBool:self.soundSwitch.on forKey:@"playSound"];
    [theDefaults synchronize];
}

- (IBAction)restorePreferences {
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
    
    [theDefaults synchronize];
    self.digitsSwitch.on = [theDefaults boolForKey:@"showDigits"];
    self.partitionControl.selectedSegmentIndex = [theDefaults integerForKey:@"partitionOfDial"];
    self.soundSwitch.on = [theDefaults boolForKey:@"playSound"];
}

@end
