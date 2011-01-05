//
//  Fahrzeug.m
//  First Steps
//
//  Created by Klaus M. Rodewig on 05.01.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import "Fahrzeug.h"


@implementation Fahrzeug

- (id)init {
    NSLog(@"[+] [%@, %@]", self, NSStringFromSelector(_cmd));
    if ((self = [super init])) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"[+] [%@, %@]", self, NSStringFromSelector(_cmd));
    // Clean-up code here.
    
    [super dealloc];
}

@end
