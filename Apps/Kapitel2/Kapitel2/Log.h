//
//  LogUtility.h
//  Kapitel2
//
//  Created by Rodewig Klaus on 15.07.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol LogDelegate;

@interface Log : NSObject

<<<<<<< HEAD:Apps/Kapitel2/Kapitel2/LogUtility.h
@interface LogUtility : NSObject
@property (nonatomic,weak) id<LogUtilityDelegate> delegate;
=======
@property (nonatomic, weak) id<LogDelegate> delegate;
>>>>>>> 6cc8a5bf717bdf3814324db8a23a3cc8a5f6b337:Apps/Kapitel2/Kapitel2/Log.h

-(void)logToConsole:(NSString *)theMessage;

@end

@protocol LogDelegate<NSObject>

-(void)logDidFinishLogging:(Log *)inLog;

@end
