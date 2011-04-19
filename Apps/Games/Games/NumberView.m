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

@end
