#import "DigitView.h"
#import <QuartzCore/QuartzCore.h>

@interface DigitLayer : CALayer {
    @private
}

@property (nonatomic) float digit;

@end

@implementation DigitView

@synthesize font;

+ (id)layerClass {
    return [DigitLayer class];
}

- (void)dealloc {
	self.font = nil;
	[super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.font = [UIFont fontWithName:@"Helvetica-Bold" size:32.0];
}

- (NSUInteger)digit {
    NSInteger theDigit = roundf([(DigitLayer *)self.layer digit]);

    theDigit %= 10;
    return theDigit < 0 ? theDigit + 10 : theDigit;
}

- (void)setDigit:(NSUInteger)inDigit {
    [self willChangeValueForKey:@"digit"];
    [(DigitLayer *)self.layer setDigit:inDigit % 10];
    [self didChangeValueForKey:@"digit"];
}

- (void)setDigit:(NSUInteger)inDigit direction:(DigitViewAnimationDirection)inDirection {
    NSUInteger theOldDigit = self.digit;
    NSUInteger theNewDigit = inDigit % 10;
    CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"digit"];
    
    theAnimation.fillMode = kCAFillModeBoth; 
    theAnimation.removedOnCompletion = YES;
    theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    theAnimation.duration = [[CATransaction valueForKey:kCATransactionAnimationDuration] floatValue];
    theAnimation.toValue = [NSNumber numberWithInt:theNewDigit];
    switch(inDirection) {
        case DigitViewAnimationDirectionBackward:
            theAnimation.fromValue = [NSNumber numberWithInt:theOldDigit < theNewDigit ? theOldDigit + 10 : theOldDigit];
            [self.layer addAnimation:theAnimation forKey:@"digit"];
            break;
        case DigitViewAnimationDirectionForward:
            theAnimation.fromValue = [NSNumber numberWithInt:theOldDigit > theNewDigit ? theOldDigit - 10 : theOldDigit];
            [self.layer addAnimation:theAnimation forKey:@"digit"];
            break;
        default:
            [self setNeedsDisplay];
            break;
    }
    self.digit = inDigit;
}

- (void)addOffset:(NSInteger)inOffset animated:(BOOL)inAnimated {
    float theOldDigit = self.digit;
    float theNewDigit = theOldDigit + inOffset;
    DigitLayer *theLayer = (DigitLayer *) self.layer;
    
    [theLayer setDigit:theNewDigit];
    if(inAnimated) {
        CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"digit"];
    
        theAnimation.fillMode = kCAFillModeBoth; 
        theAnimation.removedOnCompletion = YES;
        theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        theAnimation.fromValue = [NSNumber numberWithFloat:theOldDigit];
        theAnimation.toValue = [NSNumber numberWithFloat:theNewDigit];
        theAnimation.duration = [[CATransaction valueForKey:kCATransactionAnimationDuration] floatValue];
        [theLayer addAnimation:theAnimation forKey:@"digit"];
    }
    else {
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)inRect {
}

- (void)drawLayer:(CALayer *)inLayer inContext:(CGContextRef)inContext {
    CGRect theBounds = self.bounds;
    CGSize theSize = theBounds.size;
    float theDigit = [(DigitLayer *)inLayer digit];
    UIFont *theFont = self.font;
    CGSize theFontSize = [@"0" sizeWithFont:theFont];
    CGFloat theX = (theSize.width - theFontSize.width) / 2.0;
    CGFloat theY = (theSize.height - theFontSize.height) / 2.0 - theDigit * theSize.height - theFont.capHeight;
    
    CGContextSaveGState(inContext);
    CGContextClipToRect(inContext, theBounds);
    CGContextSetFillColorWithColor(inContext, self.backgroundColor.CGColor);
    CGContextFillRect(inContext, theBounds);
    CGContextSetRGBFillColor(inContext, 0.0, 0.0, 0.0, 1.0);
    CGContextSetRGBStrokeColor(inContext, 0.0, 0.0, 0.0, 1.0);
    CGContextScaleCTM(inContext, 1.0, -1.0);
    CGContextSelectFont(inContext, [theFont.fontName cStringUsingEncoding:NSMacOSRomanStringEncoding], 
                        theFont.pointSize, kCGEncodingMacRoman);
    CGContextSetTextMatrix(inContext, CGAffineTransformIdentity);
    for(int i = 0; i <= 10; ++i) {
        char theCharacter = '0' + (i % 10);
        
        CGContextShowTextAtPoint(inContext, theX, theY, &theCharacter, 1);
        theY += theSize.height;
    }
    CGContextRestoreGState(inContext);
}

@end

@implementation DigitLayer

@synthesize digit;

- (id)initWithLayer:(id)inLayer {
    self = [super initWithLayer:inLayer];
    if(self) {
        self.digit = [[inLayer valueForKey:@"digit"] floatValue];
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)inKey {
    return [inKey isEqualToString:@"digit"] || [super needsDisplayForKey:inKey];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[0x%x, %.3f, %d]", self, self.digit, self.needsDisplay]; 
}

@end

