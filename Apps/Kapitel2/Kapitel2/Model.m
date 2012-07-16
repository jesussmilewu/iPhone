//
//  Model.m
//  Kapitel2
//
//  Created by Rodewig Klaus on 11.05.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import "Model.h"
#import "Droid.h"
#import "ProtocolDroid.h"
#import "AstroDroid.h"
#import "Wookie.h"

@implementation Model

@synthesize status, name, creation, objCount;

-(void)getObjects
{
    for(Droid *obj in objects){
        self.status = obj.droidID;
        self.status = [obj revMem:obj.droidID];
    }
    
    Wookie *chewie = [[Wookie alloc] initWithName:@"Chewbacca"];
    [objects addObject:chewie];
    for (id obj in objects) {
        [obj sayName];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        self.creation = [NSDate date];
        objects = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id)initWithName:(NSString *)inName{
    name = inName;
    return [self init];
}

-(NSNumber *)handleObject:(NSNumber *)stepperValue{
    if([stepperValue intValue] > [objects count]){
        if([stepperValue intValue] % 3 == 0) {
            Droid *newDroid = [[Droid alloc] initWithID:stepperValue];
            [objects addObject:newDroid];
        } else if([stepperValue intValue] % 3 == 1) {
            ProtocolDroid *newDroid = [[ProtocolDroid alloc] initWithID:stepperValue];
            [objects addObject:newDroid];
        } else if([stepperValue intValue] % 3 == 2) {
            AstroDroid *newDroid = [[AstroDroid alloc] initWithID:stepperValue];
            [objects addObject:newDroid];
        }
    } else if (([stepperValue intValue] < [objects count])) {
        [objects removeLastObject];
    }
    self.objCount = [NSNumber numberWithInt:[objects count]];
        
    return self.objCount;
}

@end

