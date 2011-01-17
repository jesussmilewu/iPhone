//
//  Automobil.m
//  First Steps
//
//  Created by Klaus M. Rodewig on 17.01.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import "Automobil.h"
#import <CommonCrypto/CommonDigest.h>


@implementation Automobil

-(NSString*)getId {
    DLOG(@"[+] %@", NSStringFromSelector(_cmd));
    NSMutableString *fzID = [[NSMutableString alloc] init];
    
    NSTimeInterval ti = [[NSDate date] timeIntervalSince1970];
    
    [fzID appendFormat:@"%@%0.2f%d%@%f", [self name], [[self preis] floatValue], [self geschwindigkeit], [[self baujahr] description], ti];
    
    unsigned char hashedChars[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512([fzID UTF8String],
              [fzID lengthOfBytesUsingEncoding:NSUTF8StringEncoding], 
              hashedChars);
    
    NSMutableString *hashedString;
    hashedString = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH];
    
    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; ++i) {
        [hashedString appendString:[NSString stringWithFormat:@"%02x", hashedChars[i]]];
    }
    
    DLOG(@"[+] ID 512: %@", hashedString);
    
    [fzID release];
    
    return hashedString;
}

- (id)init {
    DLOG(@"[+] %@", NSStringFromSelector(_cmd));
    if ((self = [super init])) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc {
    DLOG(@"[+] %@", NSStringFromSelector(_cmd));
    // Clean-up code here.
    
    [super dealloc];
}

@end
