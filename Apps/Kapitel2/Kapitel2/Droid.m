//
//  Tier.m
//  Kapitel2
//
//  Created by Rodewig Klaus on 27.05.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import "Droid.h"
#import "NSString+ReverseString.h"

@implementation Droid

@synthesize droidID;

- (id)initWithID:(NSNumber *)id
{
    NSLog(@"[+] %@.%@", self, NSStringFromSelector(_cmd));
    self = [super init];
    if(self != nil){
        self.droidID = [NSString stringWithFormat:@"0xDEADBEEF%02i", [id intValue]];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"[+] %@.%@", self, NSStringFromSelector(_cmd));
    [super dealloc];
}

-(NSString *)revMem:(NSString *)text{
    NSLog(@"[+] %@.%@", self, NSStringFromSelector(_cmd));
    NSLog(@"rev: %@", [[NSString stringWithString:text] reversedString]);
    return [[NSString stringWithString:text] reversedString];
}

-(void)sayName{
    NSLog(@"[+] %@.%@: %@", self, NSStringFromSelector(_cmd), self.droidID);
}
@end
