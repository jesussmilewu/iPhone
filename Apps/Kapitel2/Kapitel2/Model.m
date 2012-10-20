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
#import "Wookiee.h"

@interface Model()

@property (strong, readwrite) NSString *name;
@property (nonatomic, strong) NSMutableArray *objects;

@end

@implementation Model

@synthesize status;
@synthesize name;
@synthesize creation;
@synthesize objects;

- (id)init {
    self = [super init];
    if (self) {
        self.creation = [NSDate date];
        self.objects = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id)initWithName:(NSString *)inName {
    self = [self init];
    if(self) {
        self.name = inName;
    }
    return self;
}

- (NSInteger)countOfObjects {
    return [self.objects count];
}

- (void)listDroids {
    Wookiee *theWookiee = [[Wookiee alloc] initWithName:@"Chewbacca"];
    
    [objects addObject:theWookiee];
    NSLog(@"[+] Current droids (%d):", [self countOfObjects]);
    for(id anItem in objects) {
        [anItem sayName];
    }
}

- (void)updateDroids:(NSInteger)inValue {
    [self willChangeValueForKey:@"countOfObjects"];
    if(inValue > [self.objects count]) {
        NSInteger theRemainder = inValue % 3;
        Droid *theDroid;
        
        if(theRemainder == 0) {
            theDroid = [[Droid alloc] initWithID:inValue];
        }
        else if(theRemainder == 1) {
            theDroid = [[ProtocolDroid alloc] initWithID:inValue];
        }
        else {
            theDroid = [[AstroDroid alloc] initWithID:inValue];
        }
        self.status = theDroid.droidID;
        [self.objects addObject:theDroid];
    }
    else if (inValue < [self.objects count]) {
        [self.objects removeLastObject];
    }
    [self didChangeValueForKey:@"countOfObjects"];
}

@end

