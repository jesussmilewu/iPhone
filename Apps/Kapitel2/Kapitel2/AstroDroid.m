//
//  AstroDroid.m
//  Kapitel2
//
//  Created by Rodewig Klaus on 12.07.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import "AstroDroid.h"

@implementation AstroDroid

@synthesize droidID;

- (id)initWithID:(NSNumber *)id
{
    NSLog(@"[+] %@.%@", self, NSStringFromSelector(_cmd));
    self = [super init];
    if(self != nil){
        self.droidID = [NSString stringWithFormat:@"0xBEEFCAFE%02i", [id intValue]];
    }
    return self;
}

-(void)sayName{
    NSLog(@"[-] %@.%@: %@", self, NSStringFromSelector(_cmd), self.droidID);
}


@end
