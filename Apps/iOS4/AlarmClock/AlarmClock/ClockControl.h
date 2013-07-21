#import <UIKit/UIKit.h>

@interface ClockControl : UIControl

@property (nonatomic) NSTimeInterval time;
@property (nonatomic) CGFloat angle;

- (CGFloat)angleWithPoint:(CGPoint)inPoint;

@end
