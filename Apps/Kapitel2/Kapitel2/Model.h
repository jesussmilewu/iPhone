//
//  Model.h
//  Kapitel2
//
//  Created by Rodewig Klaus on 11.05.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property(strong) NSString *status;
@property(strong) NSDate *creation;
@property(strong) NSString *name;

- (NSInteger) countOfObjects;

-(id)initWithName:(NSString *)inName;

-(void)listDroids;
-(void)updateDroids:(NSInteger)inValue;

@end
