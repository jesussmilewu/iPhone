//
//  TwitterCollectionViewController.m
//  UniversalSimpleTwitter
//
//  Created by Clemens Wagner on 17.07.12.
//  Copyright (c) 2012 Clemens Wagner. All rights reserved.
//

#import "TwitterCollectionViewController.h"
#import "NSString+URLTools.h"
#import "TweetCell.h"

@interface TwitterCollectionViewController ()<UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

@property (copy, nonatomic) NSArray *tweets;
@property (copy, nonatomic) NSDictionary *colors;

@end

@implementation TwitterCollectionViewController

@synthesize query;
@synthesize tweets;
@synthesize colors;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.query = @"iOS";
    self.colors = @{ @"de" : [UIColor greenColor], @"en" : [UIColor yellowColor], @"fr" : [UIColor orangeColor] };
    [self.collectionView registerClass:[TweetCell class] forCellWithReuseIdentifier:@"Tweet"];
    [self updateTweets];
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.tweets = nil;
}

- (void)updateTweets {
    NSData *theData = [NSData dataWithContentsOfURL:self.createURL];
    NSError *theError = nil;
    NSDictionary *theResult =
    [NSJSONSerialization JSONObjectWithData:theData options:0 error:&theError];
    
    self.tweets = [theResult valueForKey:@"results"];
    [self.collectionView reloadData];
}

- (IBAction)refresh:(id)inSender {
    [self updateTweets];
}

- (NSURL *)createURL {
    NSString *theQuery = [self.query encodedStringForURLWithEncoding:kCFStringEncodingUTF8];
    NSString *theURL = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%@&rpp=50", theQuery];
    
    NSLog(@"URL = %@", theURL);
    return [NSURL URLWithString:theURL];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)inCollectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)inCollectionView numberOfItemsInSection:(NSInteger)inSection {
    return self.tweets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)inCollectionView
                  cellForItemAtIndexPath:(NSIndexPath *)inIndexPath {
    TweetCell *theCell = [inCollectionView dequeueReusableCellWithReuseIdentifier:@"Tweet" forIndexPath:inIndexPath];
    NSDictionary *theItem = [self.tweets objectAtIndex:inIndexPath.row];
    NSString *theCode = [theItem objectForKey:@"iso_language_code"];
    UIColor *theColor = [self.colors objectForKey:theCode];
    
    theCell.title = [theItem objectForKey:@"from_user"];
    theCell.text = [theItem objectForKey:@"text"];
    theCell.tintColor = theColor ? theColor : [UIColor redColor];
    return theCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)inCollectionView
           viewForSupplementaryElementOfKind:(NSString *)inKind atIndexPath:(NSIndexPath *)inIndexPath {
    UICollectionReusableView *theView = nil;
    
    if([UICollectionElementKindSectionHeader isEqualToString:inKind]) {
        theView = [inCollectionView dequeueReusableSupplementaryViewOfKind:inKind
                                                       withReuseIdentifier:@"Header"
                                                              forIndexPath:inIndexPath];
        UISearchBar *theSearchBar = (UISearchBar *)[theView viewWithTag:10];
        
        theSearchBar.text = self.query;
        theSearchBar.delegate = self;
    }
    else if([UICollectionElementKindSectionFooter isEqualToString:inKind]) {
        theView = [inCollectionView dequeueReusableSupplementaryViewOfKind:inKind
                                                       withReuseIdentifier:@"Footer"
                                                              forIndexPath:inIndexPath];
    }
    return theView;
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)inCollectionView layout:(UICollectionViewLayout *)inCollectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)inIndexPath {
    TweetCell *theCell = [[TweetCell alloc] initWithFrame:CGRectNull];
    NSDictionary *theItem = [self.tweets objectAtIndex:inIndexPath.row];
    CGSize theSize = CGSizeMake(244.0, MAXFLOAT);
    
    theCell.text = [theItem objectForKey:@"text"];
    return CGSizeMake(244.0, [theCell sizeThatFits:theSize].height);
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)inSearchBar {
    [inSearchBar endEditing:YES];
    self.query = inSearchBar.text;
    [self updateTweets];
}

@end
