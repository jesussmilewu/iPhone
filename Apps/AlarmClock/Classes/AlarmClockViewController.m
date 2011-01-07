#import "AlarmClockViewController.h"
#import "ClockControl.h"
#import "ClockView.h"

const NSTimeInterval kSecondsOfDay = 60.0 * 60.0 * 24.0;

@implementation AlarmClockViewController

- (void)dealloc {
    [super dealloc];
}

- (NSTimeInterval)startTimeOfCurrentDay {
    NSTimeInterval theTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeZone *theTimeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval theOffset = theTimeZone.secondsFromGMT;
    
    return floor(theTime / kSecondsOfDay) * kSecondsOfDay - theOffset;
}

- (void)updateControl {
    UIApplication *theApplication = [UIApplication sharedApplication];
	UILocalNotification *theNotification = [[theApplication scheduledLocalNotifications] lastObject];
    
    if([theNotification.fireDate compare:[NSDate date]] > NSOrderedSame) {
        NSTimeInterval theTime = [theNotification.fireDate timeIntervalSinceReferenceDate] - self.startTimeOfCurrentDay;
        
        clockControl.time = remainder(theTime, kSecondsOfDay / 2.0);
        clockControl.hidden = NO;
    }
    else {
        alarmSwitch.on = NO;
        clockControl.hidden = YES;
    }
    [self updateTimeLabel];
}

- (void)updateAlarmHand:(UIGestureRecognizer *)inRecognizer {
    CGPoint thePoint = [inRecognizer locationInView:clockControl];
    CGFloat theAngle = [clockControl angleWithPoint:thePoint];
    
    clockControl.angle = theAngle;
    [clockControl setNeedsDisplay];
    alarmSwitch.on = YES;
    [self updateAlarm];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILongPressGestureRecognizer *theRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(updateAlarmHand:)];

    [clockView addGestureRecognizer:theRecognizer];
    [theRecognizer release];
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    [self updateControl];
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    [clockView startAnimation];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [super viewWillDisappear:inAnimated];
    [clockView stopAnimation];
}

- (void)createAlarm {
    UIApplication *theApplication = [UIApplication sharedApplication];
    UILocalNotification *theNotification = [[UILocalNotification alloc] init];
    NSTimeInterval theTime = self.startTimeOfCurrentDay + clockControl.time;
    
    while(theTime < [NSDate timeIntervalSinceReferenceDate]) {
        theTime += kSecondsOfDay / 2.0;
    }
    [theApplication cancelAllLocalNotifications];
    theNotification.fireDate = [NSDate dateWithTimeIntervalSinceReferenceDate:theTime];
    theNotification.timeZone = [NSTimeZone defaultTimeZone];
    theNotification.alertBody = NSLocalizedString(@"Wake up", @"Alarm message");
    theNotification.soundName = @"ringtone.caf";
    theNotification.applicationIconBadgeNumber = 1;
    theApplication.applicationIconBadgeNumber = 0;
    [theApplication scheduleLocalNotification:theNotification];
    [theNotification release];
}

- (IBAction)updateAlarm {
    clockControl.hidden = !alarmSwitch.on;
    if(alarmSwitch.on) {
        [self createAlarm];
    }
    else {
        UIApplication *theApplication = [UIApplication sharedApplication];
        
        [theApplication cancelAllLocalNotifications];        
    }
    [self updateTimeLabel];
}

- (IBAction)updateTimeLabel {
    timeLabel.hidden = clockControl.hidden;
    if(!timeLabel.hidden) {
        NSInteger theTime = round(clockControl.time / 60.0);
        NSInteger theMinutes = theTime % 60;
        NSInteger theHours = theTime / 60;
        
        timeLabel.text = [NSString stringWithFormat:@"%d:%02d", theHours, theMinutes];
    }
}


@end
