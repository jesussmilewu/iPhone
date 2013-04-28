//
//  DetailViewController.m
//  WebView
//
//  Created by Clemens Wagner on 02.04.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "DetailViewController.h"
#import "NSString+Template.h"

@interface DetailViewController ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
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

- (IBAction)deleteMetaTag {
    NSLog(@"delete = %@", [self.webView stringByEvaluatingJavaScriptFromString:@"$('meta').remove()"]);
}

- (IBAction)insertMetaTag {
    [self deleteMetaTag];
    NSLog(@"delete = %@", [self.webView stringByEvaluatingJavaScriptFromString:@"$('meta').remove()"]);
}

- (void)loadContent:(NSDictionary *)inItem {
    if(inItem[@"url"] != nil) {
        NSURL *theURL = [NSURL URLWithString:inItem[@"url"]];
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL];

        [self.webView loadRequest:theRequest];
    }
    else if(inItem[@"content"] != nil) {
        NSString *theContent = inItem[@"content"];
        NSURL *theURL = [[NSBundle mainBundle] bundleURL];

        [self.webView loadHTMLString:theContent baseURL:theURL];
    }
    else if(inItem[@"template"] != nil) {
        NSURL *theURL = [[NSBundle mainBundle] URLForResource:inItem[@"template"] withExtension:@"tmpl"];
        NSStringEncoding theEncoding = NSUTF8StringEncoding;
        NSError *theError = nil;
        NSString *theData = [NSString stringWithContentsOfURL:theURL
                                                 usedEncoding:&theEncoding
                                                        error:&theError];

        theData = [theData stringWithValuesOfObject:self];
        [self.webView loadHTMLString:theData baseURL:theURL];
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

- (NSString *)date {
    NSDateFormatter *theFormatter = [[NSDateFormatter alloc] init];
    NSString *theDate;

    theFormatter.locale = [NSLocale currentLocale];
    theFormatter.dateStyle = NSDateFormatterMediumStyle;
    theFormatter.timeStyle = NSDateFormatterNoStyle;
    theDate = [theFormatter stringFromDate:[NSDate date]];
    return [theDate stringByEscapingSpecialXMLCharacters];
}

- (id)valueForUndefinedKey:(NSString *)inKey {
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
    id theValue = [theDefaults objectForKey:inKey];

    return theValue == nil ? @"" : [[theValue description] stringByEscapingSpecialXMLCharacters];
}

- (IBAction)updateZoomScale:(id)inSlider {
    UIScrollView *theScrollView = self.webView.scrollView;
    CGFloat theScale = [(UISlider *)inSlider value];

    NSLog(@"scale = %.3f", theScale);
    [theScrollView setZoomScale:theScale animated:YES];
}

- (IBAction)scrollToTop {
    [self.webView.scrollView setContentOffset:CGPointZero animated:YES];
}

- (IBAction)scrollToCenter {
    UIScrollView *theScrollView = self.webView.scrollView;
    CGSize theContentSize = theScrollView.contentSize;
    CGSize theViewSize = theScrollView.bounds.size;
    CGPoint theOffset = CGPointMake(fmaxf(theContentSize.width - theViewSize.width, 0.0) / 2.0,
                                    fmaxf(theContentSize.height - theViewSize.height, 0.0) / 2.0);
    
    [theScrollView setContentOffset:theOffset animated:YES];
}

- (IBAction)scrollToBottom {
    UIScrollView *theScrollView = self.webView.scrollView;
    CGSize theContentSize = theScrollView.contentSize;
    CGSize theViewSize = theScrollView.bounds.size;
    CGPoint theOffset = CGPointMake(fmaxf(theContentSize.width - theViewSize.width, 0.0),
                                    fmaxf(theContentSize.height - theViewSize.height, 0.0));

    [theScrollView setContentOffset:theOffset animated:YES];
}

#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)inWebView {
    [self.slider setValue:0.0 animated:YES];
    if(![self.activityIndicator isAnimating]) {
        [self.activityIndicator startAnimating];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)inWebView {
    UIScrollView *theScrollView = self.webView.scrollView;
    
    [self.activityIndicator stopAnimating];
    NSLog(@"scrollView: [%.3f, %.3f]",
          theScrollView.minimumZoomScale, theScrollView.maximumZoomScale);
    self.slider.minimumValue = theScrollView.minimumZoomScale;
    self.slider.maximumValue = theScrollView.maximumZoomScale;
    self.slider.value = theScrollView.zoomScale;
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
