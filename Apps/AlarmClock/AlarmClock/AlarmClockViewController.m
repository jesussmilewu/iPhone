#import "AlarmClockViewController.h"
#import "ClockControl.h"
#import "ClockView.h"

const NSTimeInterval kSecondsOfDay = 60.0 * 60.0 * 24.0;

@interface AlarmClockViewController()

@property (nonatomic) BOOL alarmHidden;

@end

@implementation AlarmClockViewController

@synthesize clockView;
@synthesize clockControl;
@synthesize alarmSwitch;
@synthesize timeLabel;

- (void)dealloc {
    self.clockView = nil;
    self.clockControl = nil;
    self.alarmSwitch = nil;
    self.timeLabel = nil;    
    [super dealloc];
}

- (BOOL)alarmHidden {
    return self.clockControl.hidden;
}

- (void)setAlarmHidden:(BOOL)inAlarmHidden {
    self.alarmSwitch.on = !inAlarmHidden;
    self.clockControl.hidden = inAlarmHidden;
    self.timeLabel.hidden = inAlarmHidden;
}

- (NSTimeInterval)startTimeOfCurrentDay {
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDateComponents *theComponents = [theCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit 
                                                     fromDate:[NSDate date]];
    NSDate *theDate = [theCalendar dateFromComponents:theComponents];
    
    return [theDate timeIntervalSinceReferenceDate];
}

- (void)updateViews {
    UIApplication *theApplication = [UIApplication sharedApplication];
	UILocalNotification *theNotification = [[theApplication scheduledLocalNotifications] lastObject];
    
    if([theNotification.fireDate compare:[NSDate date]] > NSOrderedSame) {
        NSTimeInterval theTime = [theNotification.fireDate timeIntervalSinceReferenceDate] - self.startTimeOfCurrentDay;
        
        self.clockControl.time = remainder(theTime, kSecondsOfDay / 2.0);
        self.alarmHidden = NO;
    }
    else {
        self.alarmHidden = YES;
    }
    [self updateTimeLabel];
}

- (IBAction)updateAlarmHand:(UIGestureRecognizer *)inRecognizer {
    CGPoint thePoint = [inRecognizer locationInView:self.clockControl];
    CGFloat theAngle = [self.clockControl angleWithPoint:thePoint];
    
    self.clockControl.angle = theAngle;
    [self.clockControl setNeedsDisplay];
    self.alarmHidden = NO;
    [self updateTimeLabel];
    if(inRecognizer.state == UIGestureRecognizerStateEnded) {
        [self updateAlarm];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if(![self isViewLoaded]) {
        self.clockView = nil;
        self.clockControl = nil;
        self.alarmSwitch = nil;
        self.timeLabel = nil;        
    }
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    [self updateViews];
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    [self.clockView startAnimation];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [super viewWillDisappear:inAnimated];
    [self.clockView stopAnimation];
}

- (void)createAlarm {
    UIApplication *theApplication = [UIApplication sharedApplication];
    UILocalNotification *theNotification = [[UILocalNotification alloc] init];
    NSTimeInterval theTime = self.startTimeOfCurrentDay + self.clockControl.time;
    
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
    self.alarmHidden = !self.alarmSwitch.on;
    if(self.alarmSwitch.on) {
        [self createAlarm];
    }
    else {
        UIApplication *theApplication = [UIApplication sharedApplication];
        
        [theApplication cancelAllLocalNotifications];        
    }
}

- (IBAction)updateTimeLabel {
    NSInteger theTime = round(self.clockControl.time / 60.0);
    NSInteger theMinutes = theTime % 60;
    NSInteger theHours = theTime / 60;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%d:%02d", theHours, theMinutes];
}


@end
