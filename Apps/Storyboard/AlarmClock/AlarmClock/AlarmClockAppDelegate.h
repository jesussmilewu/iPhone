#import <UIKit/UIKit.h>

/** AppDelegate der Wecker-App.
 
 Diese Klasse ist der von Xcode automatisch erzeugte Delegate von UIApplication

*/

@class AlarmClockViewController;

@interface AlarmClockAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) NSNumber *soundId;
@property (nonatomic, strong) IBOutlet UIWindow *window;

@end

