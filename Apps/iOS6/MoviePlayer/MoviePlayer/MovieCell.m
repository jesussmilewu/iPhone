//
//  MovieCell.m
//  MoviePlayer
//
//  Created by Clemens Wagner on 09.06.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "MovieCell.h"
#import <QuartzCore/QuartzCore.h>

@interface MovieCell()

@property (nonatomic, weak) IBOutlet UIView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *textLabel;

@end

@implementation MovieCell

@synthesize image;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderColor = [self.tintColor CGColor];
    self.layer.borderWidth = 1.0;
}

- (void)setImage:(UIImage *)inImage {
    image = inImage;
    self.imageView.layer.contents = (id)inImage.CGImage;
}

- (NSString *)text {
    return self.textLabel.text;
}

- (void)setText:(NSString *)inText {
    self.textLabel.text = inText;
}

@end
