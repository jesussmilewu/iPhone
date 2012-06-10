//
//  TwitterViewController.m
//  SimpleTwitter
//
//  Created by Clemens Wagner on 07.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterViewController.h"
#import "JSONKit.h"
#import "NSString+URLTools.h"

@interface TwitterViewController ()

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, copy) NSArray *tweets;

- (NSURL *)createURL;
- (void)updateTweets;

@end

@implementation TwitterViewController

@synthesize searchBar;
@synthesize tweets;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.text = @"iOS";
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.searchBar = nil;
    self.tweets = nil;
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    [self updateTweets];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return YES;
}

- (void)updateTweets {
    NSData *theData = [NSData dataWithContentsOfURL:self.createURL];
    NSDictionary *theResult = [theData objectFromJSONData];
    
    self.tweets = [theResult valueForKey:@"results"];
    [self.tableView reloadData];
}

- (NSURL *)createURL {
    NSString *theQuery = [self.searchBar.text encodedStringForURLWithEncoding:kCFStringEncodingUTF8];
    NSString *theURL = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%@", theQuery];
                        
    NSLog(@"URL = %@", theURL);
    return [NSURL URLWithString:theURL];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)inScrollView willDecelerate:(BOOL)inDecelerate {
    CGPoint theOffset = inScrollView.contentOffset;
    
    if(theOffset.y < -CGRectGetHeight(inScrollView.frame) / 4.0) {
        [self updateTweets];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)inTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)inTableView numberOfRowsInSection:(NSInteger)inSection {
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)inIndexPath {
    UITableViewCell *theCell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *theItem = [self.tweets objectAtIndex:inIndexPath.row];

    theCell.textLabel.text = [theItem objectForKey:@"from_user"];
    theCell.detailTextLabel.text = [theItem objectForKey:@"text"];
    return theCell;
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)inSearchBar {
    [inSearchBar endEditing:YES];
    [self updateTweets];
}

@end
