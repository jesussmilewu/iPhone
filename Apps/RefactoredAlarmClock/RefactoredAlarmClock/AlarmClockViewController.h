#import <UIKit/UIKit.h>

@class ClockView;
@class ClockControl;

@interface AlarmClockViewController : UIViewController

@property(nonatomic, unsafe_unretained) IBOutlet ClockView *clockView;
@property(nonatomic, unsafe_unretained) IBOutlet ClockControl *clockControl;
@property(nonatomic, unsafe_unretained) IBOutlet UISwitch *alarmSwitch;
@property(nonatomic, unsafe_unretained) IBOutlet UILabel *timeLabel;

- (IBAction)updateAlarm;
- (IBAction)updateTimeLabel;

@end

