//
//  NSDictionary+Extensions.m
//
//  Created by Clemens Wagner on 01.05.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+Extensions.h"
#import "NSDateFormatter+Extensions.h"

@implementation NSDictionary(Extensions)

+(id)dictionaryWithHeaderFieldsForURL:(NSURL *)inURL {
    NSDictionary *theResult = nil;

    if([@"http" isEqualToString:[inURL scheme]] || [@"https" isEqualToString:[inURL scheme]]) {
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:inURL];
        NSURLResponse *theResponse = nil;
        NSError *theError = nil;
    
        [theRequest setHTTPMethod:@"HEAD"];
        [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&theError];
        if(theError == nil && [theResponse respondsToSelector:@selector(allHeaderFields)]) {            
            theResult = [(id)theResponse allHeaderFields];
        }
    }
    return theResult;
}

- (NSDate *)lastModified {
    NSString *theDate = [self objectForKey:@"Last-Modified"];
    
    return [NSDateFormatter dateForRFC1123String:theDate];
}

- (NSString *)contentType {
    return [self objectForKey:@"Content-Type"];
}
- (size_t)contentLength {
    NSString *theLength = [self objectForKey:@"Content-Length"];
    
    return [theLength longLongValue];
}

@end