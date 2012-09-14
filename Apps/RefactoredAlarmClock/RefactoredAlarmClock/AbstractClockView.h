//
//  AbstractClockView.h
//  
//
//  Created by Clemens Wagner on 07.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbstractClockView : UIView

@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong, readonly) NSCalendar *calendar;

- (void)startAnimation;
- (void)stopAnimation;

@end
