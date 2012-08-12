//
//  LogoView.m
//  UniversalSimpleTwitter
//
//  Created by Clemens Wagner on 24.07.12.
//  Copyright (c) 2012 Clemens Wagner. All rights reserved.
//

#import "LogoView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LogoView

- (id)initWithFrame:(CGRect)inFrame {
    self = [super initWithFrame:inFrame];
    if (self) {
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
}

@end
