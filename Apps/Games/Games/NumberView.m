//
//  NumberView.m
//  Games
//
//  Created by Clemens Wagner on 18.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NumberView.h"
#import "DigitView.h"
#import <QuartzCore/QuartzCore.h>

#define HEIGHT 0.6

@implementation NumberView

@synthesize value;

- (void)dealloc {
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    CALayer *theLayer = self.layer;
    
    theLayer.cornerRadius = 4;
    theLayer.masksToBounds = YES;
}

- (void)setValue:(NSUInteger)inValue animated:(BOOL)inAnimated {
    NSUInteger theValue = inValue;
    DigitViewAnimationDirection theDirection = inValue > value ? DigitViewAnimationDirectionForward : DigitViewAnimationDirectionBackward;

    for(DigitView *theView in self.subviews) {        
        [theView setDigit:theValue % 10 direction:theDirection];
        theValue /= 10;
    }
    value = inValue;
}

- (void)setValue:(NSUInteger)inValue {
    [self setValue:inValue animated:NO];
}

- (CGImageRef)createGradientImageWithSize:(CGSize)inSize alpha:(float)inAlpha {
	CGImageRef theImage = NULL;
    CGColorSpaceRef theColorSpace = CGColorSpaceCreateDeviceGray();
	CGContextRef theContext = CGBitmapContextCreate(NULL, inSize.width, inSize.height,
                                                    8, 0, theColorSpace, kCGImageAlphaNone);
	CGFloat theColors[] = {inAlpha, 1.0, 0.0, 1.0};
	CGGradientRef theGradient = CGGradientCreateWithColorComponents(theColorSpace, theColors, NULL, 2);
	CGContextDrawLinearGradient(theContext, theGradient,
								CGPointZero, CGPointMake(0, inSize.height), 
                                kCGGradientDrawsAfterEndLocation);
    
	CGColorSpaceRelease(theColorSpace);	
	CGGradientRelease(theGradient);
	theImage = CGBitmapContextCreateImage(theContext);
	CGContextRelease(theContext);
    return theImage;
}

- (UIImage *)imageForView:(UIView *)inView {
    CALayer *theLayer = inView.layer;
    CALayer *thePresentationLayer = [theLayer presentationLayer];
    CGRect theFrame = inView.frame;
    CGSize theSize = theFrame.size;
    CGContextRef theContext;
    UIImage *theImage;
    
    if(thePresentationLayer) {
        theLayer = thePresentationLayer;
    }
    UIGraphicsBeginImageContext(theSize);
    theContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(theContext, 1.0, -HEIGHT);
    CGContextTranslateCTM(theContext, 0.0, -theSize.height);
    if([inView respondsToSelector:@selector(drawLayer:inContext:)] && theLayer.contents == nil) {
        [inView drawLayer:theLayer inContext:theContext];        
    }
    else {
        [theLayer renderInContext:theContext];
    }
    theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)drawMirror:(UIView *)inView {
    CGRect theFrame = inView.frame;
    CGSize theSize = theFrame.size;
    CGPoint thePoint = CGPointMake(CGRectGetMinX(theFrame), CGRectGetMaxY(theFrame));
    CGFloat theHeight = theSize.height * HEIGHT;
    CGImageRef theGradient = [self createGradientImageWithSize:CGSizeMake(1.0, theHeight) alpha:0.8];
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    CGRect theRect;
    UIImage *theImage = [self imageForView:inView];
    
    theRect.origin = thePoint;
    theRect.size = theSize;
    CGContextSaveGState(theContext);
    CGContextClipToMask(theContext, theRect, theGradient);
    [theImage drawAtPoint:thePoint];
	CGImageRelease(theGradient);
    CGContextRestoreGState(theContext);
}

- (void)drawRect:(CGRect)inRect {
    for(UIView *theView in self.subviews) {
        [self drawMirror:theView];
    }
}

@end
