//
//  FlipBookViewController.m
//  FlipBookAnimation
//
//  Created by Clemens Wagner on 28.08.12.
//  Copyright (c) 2012 Clemens Wagner. All rights reserved.
//

#import "FlipBookViewController.h"
#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>

@interface FlipBookViewController ()

@end

@implementation FlipBookViewController
@synthesize animationView;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *theImages = [self readAnimationImages];
    CALayer *theLayer = self.animationView.layer;
    CAKeyframeAnimation *theImageAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    CATransform3D theTransform = CATransform3DIdentity;
    
    theLayer.contents = [theImages objectAtIndex:0];
    theImageAnimation.values = theImages;
    theImageAnimation.repeatCount = HUGE_VALF;
    theImageAnimation.duration = 1.0;
    theAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    theAnimation.repeatCount = HUGE_VALF;
    theAnimation.duration = 8.0;
    [theLayer addAnimation:theImageAnimation forKey:@"contents"];
    [theLayer addAnimation:theAnimation forKey:@"transform.rotation.y"];
    theTransform.m34 = 0.00125;
    self.view.layer.sublayerTransform = theTransform;
}

- (NSArray *)readAnimationImages {
    NSBundle *theBundle = [NSBundle mainBundle];
    NSURL *theURL = [theBundle URLForResource:@"animated-image" withExtension:@"gif"];
    NSDictionary *theOptions = [NSDictionary dictionaryWithObjectsAndKeys:nil];
    CGImageSourceRef theSource = CGImageSourceCreateWithURL((__bridge CFURLRef) theURL,
                                                            (__bridge CFDictionaryRef)theOptions);
    size_t theCount = CGImageSourceGetCount(theSource);
    NSMutableArray *theResult = [NSMutableArray arrayWithCapacity:theCount];
    
    for(size_t i = 0; i < theCount; ++i) {
        CGImageRef theImage = CGImageSourceCreateImageAtIndex(theSource, i, (__bridge CFDictionaryRef)theOptions);
        
        [theResult addObject:(__bridge_transfer id)theImage];
    }
    return theResult;
}

@end
