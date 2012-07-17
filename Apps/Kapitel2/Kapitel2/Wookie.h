//
//  Wookie.h
//  Kapitel2
//
//  Created by Rodewig Klaus on 12.07.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wookie : NSObject
@property(copy) NSString * myName;
-(void)sayName;
-(id)initWithName:(NSString *)name;
@end
