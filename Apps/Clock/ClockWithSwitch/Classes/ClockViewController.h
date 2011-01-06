#import <UIKit/UIKit.h>

@class ClockView;

@interface ClockViewController : UIViewController {
	@private
    IBOutlet ClockView *clockView;
    IBOutlet UISwitch *clockSwitch;
}
- (IBAction)switchAnimation:(UISwitch *)inSender;

@end

