//
//  AbstractClockView.h
//  
//
//  Created by Clemens Wagner on 07.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbstractClockView : UIView

@property (nonatomic, retain) NSDate *time;
@property (nonatomic, retain, readonly) NSCalendar *calendar;

- (void)startAnimation;
- (void)stopAnimation;

@end
