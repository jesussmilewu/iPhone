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
#import "StackLayout.h"

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
    UICollectionView *theView = self.collectionView;
    
    self.query = @"iOS";
    self.colors = @{ @"de" : [UIColor greenColor], @"en" : [UIColor yellowColor], @"fr" : [UIColor orangeColor] };
    [theView registerClass:[TweetCell class] forCellWithReuseIdentifier:@"Tweet"];
    if(![theView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        UINib *theNib = [UINib nibWithNibName:@"Searchbar" bundle:nil];
        
        [theView registerNib:theNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Searchbar"];
        theNib = [UINib nibWithNibName:@"Toolbar" bundle:nil];
        [theView registerNib:theNib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Toolbar"];
        theNib = [UINib nibWithNibName:@"Logo" bundle:nil];
        [theView.collectionViewLayout registerNib:theNib forDecorationViewOfKind:@"Logo"];
    }
    [self updateTweets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.tweets = nil;
}

- (void)updateTweets {
    UIApplication *theApplication = [UIApplication sharedApplication];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:self.createURL];
    NSOperationQueue *theQueue = [NSOperationQueue mainQueue];
    
    theApplication.networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:theRequest queue:theQueue completionHandler:^(NSURLResponse *inResponse, NSData *inData, NSError *inError) {
        if(inData == nil) {
            NSLog(@"error = %@", inError);
        }
        else {
            NSError *theError = nil;
            NSDictionary *theResult = [NSJSONSerialization JSONObjectWithData:inData options:0 error:&theError];
        
            self.tweets = [theResult valueForKey:@"results"];
            [self.collectionView reloadData];
            theApplication.networkActivityIndicatorVisible = NO;
        }
    }];
}

- (IBAction)refresh:(id)inSender {
    [self updateTweets];
}

- (NSURL *)createURL {
    NSString *theQuery = [self.query encodedStringForURLWithEncoding:kCFStringEncodingUTF8];
    NSString *theURL = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%@&rpp=20", theQuery];
    
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
    theCell.titleColor = theColor ? theColor : [UIColor redColor];
    return theCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)inCollectionView
           viewForSupplementaryElementOfKind:(NSString *)inKind atIndexPath:(NSIndexPath *)inIndexPath {
    UICollectionReusableView *theView = nil;
    
    if([UICollectionElementKindSectionHeader isEqualToString:inKind]) {
        theView = [inCollectionView dequeueReusableSupplementaryViewOfKind:inKind
                                                       withReuseIdentifier:@"Searchbar"
                                                              forIndexPath:inIndexPath];
        UISearchBar *theSearchBar = (UISearchBar *)[theView viewWithTag:10];
        
        theSearchBar.text = self.query;
        theSearchBar.delegate = self;
    }
    else if([UICollectionElementKindSectionFooter isEqualToString:inKind]) {
        theView = [inCollectionView dequeueReusableSupplementaryViewOfKind:inKind
                                                       withReuseIdentifier:@"Toolbar"
                                                              forIndexPath:inIndexPath];
    }
    return theView;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)inCollectionView didSelectItemAtIndexPath:(NSIndexPath *)inIndexPath {
    [inCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:inIndexPath, nil]];
}

- (void)collectionView:(UICollectionView *)inCollectionView didDeselectItemAtIndexPath:(NSIndexPath *)inIndexPath {
    [inCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:inIndexPath, nil]];
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
