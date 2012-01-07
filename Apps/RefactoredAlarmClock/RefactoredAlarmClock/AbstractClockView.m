//
//  AbstractClockView.m
//  
//
//  Created by Clemens Wagner on 07.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AbstractClockView.h"

@interface AbstractClockView()

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain, readwrite) NSCalendar *calendar;

@end

@implementation AbstractClockView

@synthesize time;
@synthesize calendar;
@synthesize timer;

- (id)initWithFrame:(CGRect)inFrame {
    self = [super initWithFrame:inFrame];
    if(self) {
        self.calendar = [NSCalendar currentCalendar];
        self.time = [NSDate date];
    }
    return self;
}

- (void)dealloc {
    [self stopAnimation];
    self.calendar = nil;
    self.time = nil;
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.calendar = [NSCalendar currentCalendar];
    self.time = [NSDate date];
}

- (void)startAnimation {
    if(self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];        
    }
}

- (void)stopAnimation {
    [self.timer invalidate];
    self.timer = nil;
}

@end
