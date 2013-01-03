//
//  UIColor+StringParsing.m
//  Markup
//
//  Created by Clemens Wagner on 03.01.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "UIColor+StringParsing.h"

@implementation UIColor(StringParsing)

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

+ (UIColor *)colorWithString:(NSString *)inString {
    UIColor *theColor = nil;
    
    if([inString hasPrefix:@"#"]) {
        NSScanner *theScanner = [NSScanner scannerWithString:[inString substringFromIndex:1]];
        NSUInteger theValue;

        if([theScanner scanHexInt:&theValue]) {
            NSUInteger theLength = inString.length - 1;
            NSUInteger theMask = theLength > 5 ? 0xFF : 0xF;
            NSUInteger theStart = theLength == 3 || theLength == 6 ? 1 : 0;
            CGFloat theComponents[4];

            theComponents[0] = 1.0;
            for(int i = theStart; i < 4; ++i) {
                theComponents[i] = (theValue & theMask) / (theMask + 1.0);
                theValue /= theMask + 1;
            }
            theColor = [UIColor colorWithRed:theComponents[3]
                                       green:theComponents[2]
                                        blue:theComponents[1]
                                       alpha:theComponents[0]];
        }
    }
    else {
        SEL theSelector = NSSelectorFromString([NSString stringWithFormat:@"%@Color", inString]);

        if([[UIColor class] respondsToSelector:theSelector]) {
            theColor = [[UIColor class] performSelector:theSelector];
        }
    }
    return theColor;
}

@end
