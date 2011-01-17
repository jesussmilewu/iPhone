//
//  main.m
//  First Steps
//
//  Created by Klaus M. Rodewig on 04.01.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fahrzeug.h"
#import "Automobil.h"
#import "ReverseString.h"

int main (int argc, const char * argv[]) {

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    // insert code here...
    
    
    NSString *reverse = [[NSString alloc] init];
    [reverse reverseString:@"foobar"];
    
    Fahrzeug *fahrzeug = [[Fahrzeug alloc] init];
    Automobil *automobil = [[Automobil alloc] init];
    [fahrzeug getId];
    [automobil getId];
    [fahrzeug autorelease];
    [automobil release];
    [pool drain];
    return 0;
}

