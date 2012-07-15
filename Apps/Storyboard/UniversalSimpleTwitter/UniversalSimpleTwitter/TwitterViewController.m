//
//  TwitterViewController.m
//  SimpleTwitter
//
//  Created by Clemens Wagner on 07.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterViewController.h"
#import "NSString+URLTools.h"

@interface TwitterViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (copy, nonatomic) NSArray *tweets;

- (NSURL *)createURL;
- (void)updateTweets;

@end

@implementation TwitterViewController

@synthesize searchBar;
@synthesize tweets;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIRefreshControl *theControl = self.refreshControl;
    
    if([theControl actionsForTarget:self forControlEvent:UIControlEventValueChanged] == nil) {
        [theControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    }
    self.searchBar.text = @"iOS";
    
}

- (void)didReceiveMemoryWarning {
    self.tweets = nil;
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    [self updateTweets];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return YES;
}

- (IBAction)refresh {
    [self updateTweets];
}

- (void)updateTweets {
    NSData *theData = [NSData dataWithContentsOfURL:self.createURL];
    NSError *theError = nil;
    NSDictionary *theResult = 
    [NSJSONSerialization JSONObjectWithData:theData options:0 error:&theError];
    
    self.tweets = [theResult valueForKey:@"results"];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (NSURL *)createURL {
    NSString *theQuery = [self.searchBar.text encodedStringForURLWithEncoding:kCFStringEncodingUTF8];
    NSString *theURL = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%@", theQuery];
                        
    NSLog(@"URL = %@", theURL);
    return [NSURL URLWithString:theURL];
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
