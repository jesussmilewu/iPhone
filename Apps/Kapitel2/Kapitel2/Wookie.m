//
//  Wookie.m
//  Kapitel2
//
//  Created by Rodewig Klaus on 12.07.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import "Wookie.h"

@implementation Wookie

@synthesize myName;

- (id)initWithName:(NSString *)name
{
    NSLog(@"[+] %@.%@", self, NSStringFromSelector(_cmd));
    self = [super init];
    if(self != nil){
        self.myName = name;
    }
    return self;
}

-(void)sayName{
    NSLog(@"[+] %@.%@: %@", self, NSStringFromSelector(_cmd), self.myName);
}

@end
