#import <UIKit/UIKit.h>

/** AppDelegate der Wecker-App.
 
 Diese Klasse ist der von Xcode automatisch erzeugte Delegate von UIApplication

*/

@class AlarmClockViewController;

@interface AlarmClockAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) NSNumber *soundId;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

