#import "PieView.h"
#import "PieLayer.h"


@implementation PieView

+ (Class)layerClass {
    return [PieLayer class];
}

- (CGFloat)part {
    return [[(PieLayer *)self.layer part] floatValue];
}

- (void)setPart:(CGFloat)inPart {
    [(PieLayer *)self.layer setPart:[NSNumber numberWithFloat:inPart]];
}

@end
