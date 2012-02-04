#import "PreferencesViewController.h"

@implementation PreferencesViewController

@synthesize delegate;
@synthesize digitsSwitch;
@synthesize partitionControl;
@synthesize soundSwitch;


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    self.digitsSwitch = nil;
    self.partitionControl = nil;
    [self setSoundSwitch:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
    
    self.digitsSwitch.on = [theDefaults boolForKey:@"showDigits"];
    self.partitionControl.selectedSegmentIndex = [theDefaults integerForKey:@"partitionOfDial"];
    self.soundSwitch.on = [theDefaults boolForKey:@"playSound"];
}

- (IBAction)updatePreferences {
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
    
    [theDefaults setBool:self.digitsSwitch.on forKey:@"showDigits"];
    [theDefaults setInteger:self.partitionControl.selectedSegmentIndex 
                     forKey:@"partitionOfDial"];
    [theDefaults setBool:self.soundSwitch.on forKey:@"playSound"];
    [theDefaults synchronize];
    if(self.delegate) {
        [self.delegate preferencesViewControllerDidUpdatePreferences:self];
    }
}

@end
