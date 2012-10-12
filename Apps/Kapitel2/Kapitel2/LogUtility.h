//
//  LogUtility.h
//  Kapitel2
//
//  Created by Rodewig Klaus on 15.07.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol LogUtilityDelegate <NSObject>
-(void)finishedWithLogging;
@end

@interface LogUtility : NSObject
@property (nonatomic,weak) id<LogUtilityDelegate> delegate;

-(void)logToConsole:(NSString *)theMessage;

@end
