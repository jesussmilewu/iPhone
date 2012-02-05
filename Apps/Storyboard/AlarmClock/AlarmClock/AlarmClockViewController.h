#import <UIKit/UIKit.h>

@class ClockView;
@class ClockControl;

@interface AlarmClockViewController : UIViewController

@property(nonatomic, weak) IBOutlet ClockView *clockView;
@property(nonatomic, weak) IBOutlet ClockControl *clockControl;
@property(nonatomic, weak) IBOutlet UISwitch *alarmSwitch;
@property(nonatomic, weak) IBOutlet UILabel *timeLabel;

- (IBAction)updateAlarm;
- (IBAction)updateTimeLabel;

@end

