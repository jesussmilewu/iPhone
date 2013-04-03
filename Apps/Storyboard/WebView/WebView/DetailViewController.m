//
//  DetailViewController.m
//  WebView
//
//  Created by Clemens Wagner on 02.04.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.backgroundColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadContent:(NSDictionary *)inItem {
    NSString *theContent = inItem[@"content"];
    NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"style" withExtension:@"css"];
               
    [self.webView loadHTMLString:theContent baseURL:theURL];
    [self.activityIndicator startAnimating];
}

- (void)loadData:(NSDictionary *)inItem {
    NSURL *theURL = [[NSBundle mainBundle] URLForResource:inItem[@"name"] withExtension:inItem[@"extension"]];
    NSData *theData = [NSData dataWithContentsOfURL:theURL];

    [self.webView loadData:theData
                  MIMEType:inItem[@"contentType"]
          textEncodingName:inItem[@"encoding"]
                   baseURL:theURL];
    [self.activityIndicator startAnimating];
}

#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)inWebView {
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)inWebView {
    [self.activityIndicator stopAnimating];
}

#pragma mark - SplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)inSplitController
     willHideViewController:(UIViewController *)inViewController
          withBarButtonItem:(UIBarButtonItem *)inBarButtonItem
       forPopoverController:(UIPopoverController *)inPopoverController {
    inBarButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:inBarButtonItem animated:YES];
    self.masterPopoverController = inPopoverController;
}

- (void)splitViewController:(UISplitViewController *)inSplitController
     willShowViewController:(UIViewController *)inViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)inBarButtonItem {
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
