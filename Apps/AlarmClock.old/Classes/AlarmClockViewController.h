#import <UIKit/UIKit.h>

@class ClockView;
@class ClockControl;

@interface AlarmClockViewController : UIViewController {
	@private
    IBOutlet ClockView *clockView;
    IBOutlet ClockControl *clockControl;
    IBOutlet UISwitch *alarmSwitch;
    IBOutlet UILabel *timeLabel;
}

- (IBAction)updateAlarm;
- (IBAction)updateTimeLabel;

@end

