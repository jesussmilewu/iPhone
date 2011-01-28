//
//  ReverseString.m
//  First Steps
//
//  Created by Klaus M. Rodewig on 17.01.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import "ReverseString.h"


@implementation NSString (ReverseString)

-(NSString*)reverse{
    DLOG(@"[+] reverseString:%@", self);
    
    NSMutableString *theReverse;
    theReverse = [NSMutableString stringWithCapacity:[self length]];
    

    for(int i = [self length]-1; i>=0; i--){
        [theReverse appendFormat:@"%c", [self characterAtIndex:i]];
    }
    DLOG(@"[+] theReverse: %@", theReverse);
    return theReverse;
}
@end
