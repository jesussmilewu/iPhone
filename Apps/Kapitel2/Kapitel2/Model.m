//
//  Model.m
//  Kapitel2
//
//  Created by Rodewig Klaus on 11.05.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import "Model.h"
#import "Droid.h"

@implementation Model

@synthesize status, name, creation, objCount;

-(void)getObjects
{
    NSLog(@"[+] %@.%@", self, NSStringFromSelector(_cmd));
    for(Droid *obj in objects){
        self.status = obj.droidID;
//        self.status = [obj revMem:obj.droidID];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"[+] %@.%@", self, NSStringFromSelector(_cmd));
        self.creation = [NSDate date];
        objects = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id)initWithName:(NSString *)inName{
    NSLog(@"[+] %@.%@", self, NSStringFromSelector(_cmd));
    name = inName;
    return [self init];
}

-(NSNumber *)handleObject:(NSNumber *)stepperValue{
    NSLog(@"[+] %@.%@", self, NSStringFromSelector(_cmd));
    NSLog(@"stepper.value: %i", [stepperValue intValue]);
    NSLog(@"[+] objects before: %i", [objects count]);
    
    if([stepperValue intValue] > [objects count]){
        Droid *newDroid = [[Droid alloc] initWithID:stepperValue];
        [objects addObject:newDroid];
    } else if (([stepperValue intValue] < [objects count])) {
        [objects removeLastObject];
    }
    self.objCount = [NSNumber numberWithInt:[objects count]];
    
    NSLog(@"[+] objects after: %i", [objects count]);
    
    return self.objCount;
}

@end

