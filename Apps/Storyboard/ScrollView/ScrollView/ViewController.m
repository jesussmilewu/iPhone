//
//  ViewController.m
//  ScrollView
//
//  Created by Clemens Wagner on 20.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController()

@end

@implementation ViewController

@synthesize scrollView;
@synthesize contentView;

- (void)viewWillAppear:(BOOL)inAppear {
    [super viewWillAppear:inAppear];
    self.scrollView.contentSize = self.contentView.frame.size;
}

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)inScrollView {
    return self.contentView;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)inScrollView {
    return YES;
}

- (IBAction)zoomIn:(id)inRecognizer {
    CGFloat theScale = self.scrollView.zoomScale;
    [self.scrollView setZoomScale:theScale * 0.5 animated:YES];
}

@end
