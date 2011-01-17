#import <UIKit/UIKit.h>


@interface ClockControl : UIControl {
	@private
}

@property (nonatomic) NSTimeInterval time;
@property (nonatomic) CGFloat angle;
@property (nonatomic) CGFloat savedAngle;

- (CGFloat)angleWithPoint:(CGPoint)inPoint;

@end
