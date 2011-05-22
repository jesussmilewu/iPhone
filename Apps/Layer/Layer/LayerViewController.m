#import "LayerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface LayerViewController()

@property (nonatomic, retain) CAScrollLayer *scrollLayer;

@end

@implementation LayerViewController

@synthesize scrollLayer;

- (void)dealloc {
    self.scrollLayer = nil;
    [super dealloc];
}

- (CAGradientLayer *)gradientLayerWithFrame:(CGRect)inFrame {
    CAGradientLayer *theLayer = [[CAGradientLayer alloc] init];
    NSArray *theColors = [NSArray arrayWithObjects:(id)[UIColor redColor].CGColor, 
                          [UIColor greenColor].CGColor, [UIColor blueColor].CGColor, nil];
    
    theLayer.frame = inFrame;
    theLayer.colors = theColors;
    theLayer.startPoint = CGPointMake(0.0, 0.0);
    theLayer.endPoint = CGPointMake(1.0, 1.0);
    return [theLayer autorelease];
}

- (CATextLayer *)textLayerWithFrame:(CGRect)inFrame {
    CATextLayer *theLayer = [[CATextLayer alloc] init];
    CGAffineTransform theIdentity = CGAffineTransformIdentity;
    CTFontRef theFont = CTFontCreateWithName((CFStringRef)@"Courier", 24.0, &theIdentity);
    
    theLayer.frame = inFrame;
    theLayer.font = theFont;
    theLayer.fontSize = 20.0;
    theLayer.backgroundColor = [UIColor whiteColor].CGColor;
    theLayer.foregroundColor = [UIColor blackColor].CGColor;
    theLayer.wrapped = YES;
    theLayer.string = @"Die heiße Zypernsonne quälte Max und Victoria ja böse auf dem Weg bis zur Küste.";
    CFRelease(theFont);
    return [theLayer autorelease];
}

- (CAScrollLayer *)scrollLayerWithFrame:(CGRect)inFrame {
    CAScrollLayer *theLayer = [[CAScrollLayer alloc] init];
    CATextLayer *theTextLayer = [self textLayerWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(inFrame), 4 * CGRectGetHeight(inFrame))];
        
    theLayer.frame = inFrame;
    [theLayer addSublayer:theTextLayer];
    theTextLayer.fontSize *= 2;
    theLayer.scrollMode = kCAScrollVertically;
    return [theLayer autorelease];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CALayer *theLayer = self.view.layer;
    
    self.scrollLayer = [self scrollLayerWithFrame:CGRectMake(10, 190, 300, 80)];
    [theLayer addSublayer:[self gradientLayerWithFrame:CGRectMake(10, 10, 300, 80)]];
    [theLayer addSublayer:[self textLayerWithFrame:CGRectMake(10, 100, 300, 80)]];
    [theLayer addSublayer:self.scrollLayer];
}

- (void)viewDidUnload {
    self.scrollLayer = nil;
    [super viewDidUnload];
}

- (IBAction)updateSliderValue:(id)inSender {
    CGFloat theOffset = [(UISlider *)inSender value];
    
    [self.scrollLayer scrollPoint:CGPointMake(0.0, theOffset)];
}

@end
