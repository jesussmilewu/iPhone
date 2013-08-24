//
//  ScrollViewViewController.m
//  AutolayoutScrollView
//
//  Created by Clemens Wagner on 24.08.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "ScrollViewViewController.h"

@interface ScrollViewViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *contentView;

@end

@implementation ScrollViewViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGSize theSize = self.contentView.frame.size;

    self.scrollView.contentSize = theSize;
}

@end