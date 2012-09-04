#import <UIKit/UIKit.h>

@interface DigitView : UIView {
    @private
}

@property (nonatomic, strong) UIFont *font;
@property (nonatomic) NSUInteger digit;

- (void)setDigit:(NSUInteger)inDigit forward:(BOOL)inForward;
- (void)addOffset:(NSInteger)inOffset animated:(BOOL)inAnimated;

@end
