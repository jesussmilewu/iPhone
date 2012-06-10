//
//  Model.h
//  Kapitel2
//
//  Created by Rodewig Klaus on 11.05.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject{
    @private
        NSMutableArray *objects;
}
@property(retain) NSString *status;
@property(retain) NSDate *creation;
@property(retain) NSString *name;
@property(retain) NSNumber *objCount;

-(void)getObjects;
-(NSNumber *)handleObject:(NSNumber *)stepperValue;
@end
