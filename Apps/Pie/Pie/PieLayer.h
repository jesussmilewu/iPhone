#import <QuartzCore/QuartzCore.h>

extern NSString * const kPartKey;

@interface PieLayer : CALayer {
    @private
}

@property (nonatomic, retain) NSNumber *part;

@end
