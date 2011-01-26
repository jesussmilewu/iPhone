#import <UIKit/UIKit.h>

@interface ClockView : UIView {
	@private
}

@property (nonatomic, retain) NSDate *time;
@property (nonatomic, retain) NSCalendar *calendar;
@property (nonatomic, retain) NSTimer *timer;

- (void)startAnimation;
- (void)stopAnimation;

@end
