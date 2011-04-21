#import "AlarmClockAppDelegate.h"
#import "AlarmClockViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface AlarmClockAppDelegate()

- (void)clearSound;

@end

@implementation AlarmClockAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize soundId;

#pragma mark -
#pragma mark Application lifecycle

- (void)dealloc {
    [self clearSound];
    self.viewController = nil;
    self.window = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)playSound {
    if(self.soundId == nil) {
        NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"ringtone" withExtension:@"caf"];
        SystemSoundID theId;
        
        if(AudioServicesCreateSystemSoundID((CFURLRef) theURL, &theId) == kAudioServicesNoError) {
            self.soundId = [NSNumber numberWithUnsignedInt:theId];
        }
    }
    if(self.soundId) {
        AudioServicesPlaySystemSound([self.soundId unsignedIntValue]);
    }
}

- (void)application:(UIApplication *)inApplication didReceiveLocalNotification:(UILocalNotification *)inNotification {
    if(inApplication.applicationState == UIApplicationStateActive) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:nil 
                                                           message:inNotification.alertBody 
                                                          delegate:nil 
                                                 cancelButtonTitle:NSLocalizedString(@"OK", @"Dismiss alert")
                                                 otherButtonTitles:nil];
        
        [theAlert show];
        [theAlert release];
    }
}

- (void)clearSound {
    if(self.soundId != nil) {
        AudioServicesDisposeSystemSoundID([self.soundId unsignedIntValue]);
        self.soundId = nil;
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [self clearSound];    
}

@end
