#import "AlarmClockViewController.h"
#import "ClockControl.h"
#import "ClockView.h"

const NSTimeInterval kSecondsOfDay = 60.0 * 60.0 * 24.0;

@interface AlarmClockViewController()

- (void)updateClockView;

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
}

- (NSTimeInterval)startTimeOfCurrentDay {
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDateComponents *theComponents = [theCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit 
                                                     fromDate:[NSDate date]];
    NSDate *theDate = [theCalendar dateFromComponents:theComponents];
    
    return [theDate timeIntervalSinceReferenceDate];
}

- (void)updateControl {
    UIApplication *theApplication = [UIApplication sharedApplication];
	UILocalNotification *theNotification = [[theApplication scheduledLocalNotifications] lastObject];
    
    if([theNotification.fireDate compare:[NSDate date]] > NSOrderedSame) {
        NSTimeInterval theTime = [theNotification.fireDate timeIntervalSinceReferenceDate] - self.startTimeOfCurrentDay;
        
        self.clockControl.time = remainder(theTime, kSecondsOfDay / 2.0);
        self.clockControl.hidden = NO;
    }
    else {
        self.alarmSwitch.on = NO;
        self.clockControl.hidden = YES;
    }
    [self updateTimeLabel];
}

- (void)updateAlarmHand:(UIGestureRecognizer *)inRecognizer {
    CGPoint thePoint = [inRecognizer locationInView:clockControl];
    CGFloat theAngle = [clockControl angleWithPoint:thePoint];
    
    self.clockControl.angle = theAngle;
    [self.clockControl setNeedsDisplay];
    self.alarmSwitch.on = YES;
    [self updateTimeLabel];
    if(inRecognizer.state == UIGestureRecognizerStateEnded) {
        [self updateAlarm];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILongPressGestureRecognizer *theRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(updateAlarmHand:)];

    [self.clockView addGestureRecognizer:theRecognizer];
}

- (void)viewDidUnload {
    self.clockView = nil;
    self.clockControl = nil;
    self.alarmSwitch = nil;
    self.timeLabel = nil;    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    [self updateClockView];
    [self updateControl];
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
    
    [theDefaults addObserver:self forKeyPath:@"showDigits" options:0 context:nil];
    [theDefaults addObserver:self forKeyPath:@"partitionOfDial" options:0 context:nil];
    [self.clockView startAnimation];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
    
    [theDefaults removeObserver:self forKeyPath:@"showDigits"];
    [theDefaults removeObserver:self forKeyPath:@"partitionOfDial"];
    [self.clockView stopAnimation];
    [super viewWillDisappear:inAnimated];
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
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"playSound"]) {
        theNotification.soundName = @"ringtone.caf";
    }
    theNotification.applicationIconBadgeNumber = 1;
    theApplication.applicationIconBadgeNumber = 0;
    [theApplication scheduleLocalNotification:theNotification];
}

- (IBAction)updateAlarm {
    self.clockControl.hidden = !alarmSwitch.on;
    if(self.alarmSwitch.on) {
        [self createAlarm];
    }
    else {
        UIApplication *theApplication = [UIApplication sharedApplication];
        
        [theApplication cancelAllLocalNotifications];        
    }
}

- (IBAction)updateTimeLabel {
    self.timeLabel.hidden = clockControl.hidden;
    if(!self.timeLabel.hidden) {
        NSInteger theTime = round(self.clockControl.time / 60.0);
        NSInteger theMinutes = theTime % 60;
        NSInteger theHours = theTime / 60;
        
        timeLabel.text = [NSString stringWithFormat:@"%d:%02d", theHours, theMinutes];
    }
}

- (void)updateClockView {
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
    
    self.clockView.showDigits = [theDefaults boolForKey:@"showDigits"];
    self.clockView.partitionOfDial = [theDefaults integerForKey:@"partitionOfDial"];
    [self.clockView setNeedsDisplay];
}

- (void)observeValueForKeyPath:(NSString *)inKeyPath 
                      ofObject:(id)inObject 
                        change:(NSDictionary *)inChange 
                       context:(void *)inContext {
    [self updateClockView];    
}

@end
