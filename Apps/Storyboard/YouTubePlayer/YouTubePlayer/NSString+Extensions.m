//
//  NSString+Extensions.m
//  YouTube
//
//  Created by Clemens Wagner on 10.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString(Extensions)

- (NSString *)encodedStringForURLWithEncoding:(NSStringEncoding)inEncoding {
    CFStringEncoding theEncoding = CFStringConvertNSStringEncodingToEncoding(inEncoding);
    CFStringRef theResult = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                    (__bridge CFStringRef) self, 
                                                                    NULL, 
                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]", 
                                                                    theEncoding);
    
    return (__bridge_transfer NSString *)theResult;
}

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
