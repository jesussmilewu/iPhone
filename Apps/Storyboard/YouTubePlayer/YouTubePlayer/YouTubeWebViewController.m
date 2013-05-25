//
//  YouTubeWebViewController.m
//  YouTubePlayer
//
//  Created by Clemens Wagner on 25.05.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "YouTubeWebViewController.h"

@interface YouTubeWebViewController ()

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation YouTubeWebViewController

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    NSURL *theURL = [NSURL URLWithString:@"http://www.youtube.com/yt/dev/de/"];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL];

    [self.webView loadRequest:theRequest];
}

@end
