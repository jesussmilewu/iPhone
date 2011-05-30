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

- (id<CAAction>)actionForLayer:(CALayer *)inLayer forKey:(NSString *)inKey {
    if([kPartKey isEqualToString:inKey]) {
        CABasicAnimation *theAnimation = (id)[super actionForLayer:inLayer forKey:@"opacity"];
        
        theAnimation.keyPath = inKey;
        theAnimation.fromValue = [inLayer valueForKey:kPartKey];
        theAnimation.toValue = nil;
        theAnimation.byValue = nil;
        return theAnimation;
    }
    else {
        return [super actionForLayer:inLayer forKey:inKey];
    }
}

@end
