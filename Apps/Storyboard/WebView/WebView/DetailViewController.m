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

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)dealloc {
    self.webView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.backgroundColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadContent:(NSDictionary *)inItem {
    if(inItem[@"url"] != nil) {
        NSURL *theURL = [NSURL URLWithString:inItem[@"url"]];
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL];

        [self.webView loadRequest:theRequest];
    }
    else if(inItem[@"content"] != nil) {
        NSString *theContent = inItem[@"content"];
        NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"pages" withExtension:@"plist"];

        [self.webView loadHTMLString:theContent baseURL:theURL];
    }
    else {
        NSURL *theURL = [[NSBundle mainBundle] URLForResource:inItem[@"name"] withExtension:inItem[@"extension"]];
        NSData *theData = [NSData dataWithContentsOfURL:theURL];

        [self.webView loadData:theData
                      MIMEType:inItem[@"contentType"]
              textEncodingName:inItem[@"encoding"]
                       baseURL:theURL];
    }
    [self.activityIndicator startAnimating];
}

#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)inWebView {
    if(![self.activityIndicator isAnimating]) {
        [self.activityIndicator startAnimating];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)inWebView {
    [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)inWebView didFailLoadWithError:(NSError *)inError {
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                                       message:inError.localizedDescription
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    
    [self.activityIndicator stopAnimating];
    [theAlert show];
}

- (BOOL)webView:(UIWebView *)inWebView shouldStartLoadWithRequest:(NSURLRequest *)inRequest
 navigationType:(UIWebViewNavigationType)inType {
    NSString *thePath = [inRequest.URL path];

    return [thePath rangeOfString:@".gz"].location == NSNotFound && [thePath rangeOfString:@".zip"].location == NSNotFound;
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
