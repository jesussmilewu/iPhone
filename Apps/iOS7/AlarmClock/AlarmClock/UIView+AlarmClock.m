//
//  UIView+AlarmClock.m
//  AlarmClock
//
//  Created by Clemens Wagner on 21.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "UIView+AlarmClock.h"

@implementation UIView (AlarmClock)

- (CGPoint)midPoint {
    CGRect theBounds = self.bounds;
    return CGPointMake(CGRectGetMidX(theBounds),
                       CGRectGetMidY(theBounds));
}

- (CGPoint)pointWithRadius:(CGFloat)inRadius angle:(CGFloat)inAngle {
    CGPoint theCenter = [self midPoint];
    return CGPointMake(theCenter.x + inRadius * sin(inAngle),
                       theCenter.y - inRadius * cos(inAngle));
}

@end
