//
//  ReverseString.m
//  First Steps
//
//  Created by Klaus M. Rodewig on 17.01.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import "ReverseString.h"


@implementation NSString (ReverseString)

-(NSString*)reverseString:(NSString*)inString{
    DLOG(@"[+] reverseString:%@", inString);
    
    NSMutableString *tmp;
    tmp = [NSMutableString stringWithCapacity:[inString length]];
    

    for(int i = [inString length]-1; i>=0; i--){
        [tmp appendFormat:@"%c", [inString characterAtIndex:i]];
    }
    DLOG(@"[+] tmp: %@", tmp);
    return tmp;
}
@end
