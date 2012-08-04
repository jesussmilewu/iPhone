//
//  AutoLayoutViewController.m
//  AutoLayout
//
//  Created by Clemens Wagner on 29.07.12.
//  Copyright (c) 2012 Clemens Wagner. All rights reserved.
//

#import "AutoLayoutViewController.h"

@interface AutoLayoutViewController ()

@end

@implementation AutoLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect theFrame = CGRectMake(0.0, 0.0, 0.0, 0.0);
    UIView *theView = self.view;
    UIView *theLeft = [[UIView alloc] initWithFrame:theFrame];
    UIView *theMiddle = [[UIView alloc] initWithFrame:theFrame];
    UIView *theRight = [[UIView alloc] initWithFrame:theFrame];
    NSDictionary *theViews = @{ @"left" : theLeft, @"middle" : theMiddle, @"right" : theRight };
    NSArray *theConstraints;
    
    theLeft.translatesAutoresizingMaskIntoConstraints = NO;
    theMiddle.translatesAutoresizingMaskIntoConstraints = NO;
    theRight.translatesAutoresizingMaskIntoConstraints = NO;
    theLeft.backgroundColor = [UIColor redColor];
    theMiddle.backgroundColor = [UIColor yellowColor];
    theRight.backgroundColor = [UIColor greenColor];
    [theView addSubview:theLeft];
    [theView addSubview:theMiddle];
    [theView addSubview:theRight];
    theConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[left(>=50)]-[middle(==right)][right(==80)]-rightMargin-|"
                                                             options:NSLayoutFormatAlignAllTop
                                                             metrics:@{
                      @"leftMargin" : @30, @"rightMargin" : @20 }
                                                               views:theViews];
    [theView addConstraints:theConstraints];
    theConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[middle(==40,==right)]"
                                                             options:0
                                                             metrics:@{}
                                                               views:theViews];
    [theView addConstraints:theConstraints];
    [theView addConstraint:[NSLayoutConstraint constraintWithItem:theLeft attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:theLeft attribute:NSLayoutAttributeWidth multiplier:0.75 constant:0.0]];
}

@end
