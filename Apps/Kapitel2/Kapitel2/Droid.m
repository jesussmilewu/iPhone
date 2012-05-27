//
//  Tier.m
//  Kapitel2
//
//  Created by Rodewig Klaus on 27.05.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import "Droid.h"

@implementation Droid

@synthesize droidID;

- (id)initWithID:(NSNumber *)id
{
    NSLog(@"[+] %@.%@", self, NSStringFromSelector(_cmd));
    self = [super init];
    if(self != nil){
        self.droidID = [NSString stringWithFormat:@"0xDEADBEAF%02i", [id intValue]];
        NSLog(@"droidID: %@", droidID);
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"[+] %@.%@", self, NSStringFromSelector(_cmd));
    [super dealloc];
}
@end
