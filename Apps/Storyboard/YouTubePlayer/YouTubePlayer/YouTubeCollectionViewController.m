//
//  YouTubeCollectionViewController.m
//  UniversalYouTube
//
//  Created by Clemens Wagner on 04.05.2013.
//  Copyright (c) 2012 Clemens Wagner. All rights reserved.
//

#import "YouTubeCollectionViewController.h"
#import "NSString+Extensions.h"
#import "YouTubeCell.h"

#define USE_CACHING 0

@interface YouTubeCollectionViewController ()<UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

@property (copy, nonatomic) NSArray *items;

@end

@implementation YouTubeCollectionViewController

@synthesize query;
@synthesize items;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.query = @"iOS";
    [self updateItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.items = nil;
}

- (void)updateItemsWithData:(NSData *)inData {
    NSError *theError = nil;
    NSDictionary *theResult = [NSJSONSerialization JSONObjectWithData:inData options:0 error:&theError];

    self.items = [theResult valueForKeyPath:@"feed.entry"];
    [self.collectionView reloadData];
}

- (void)updateItems {
    UIApplication *theApplication = [UIApplication sharedApplication];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:self.createURL];
    NSOperationQueue *theQueue = [NSOperationQueue mainQueue];
    
    theApplication.networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:theRequest queue:theQueue completionHandler:^(NSURLResponse *inResponse, NSData *inData, NSError *inError) {
#if USE_CACHING
        NSURLCache *theCache = [NSURLCache sharedURLCache];
        NSCachedURLResponse *theResponse;
        
        if(inData == nil) {
            NSLog(@"error = %@", inError);
            theResponse = [theCache cachedResponseForRequest:theRequest];
        }
        else {
            theResponse = [[NSCachedURLResponse alloc] initWithResponse:inResponse data:inData];

            [theCache storeCachedResponse:theResponse forRequest:theRequest];
        }
        if(theResponse != nil) {
            [self updateItemsWithData:theResponse.data];
        }
#else
        if(inData == nil) {
            NSLog(@"error = %@", inError);
        }
        else {
            [self updateItemsWithData:inData];
        }
#endif
        theApplication.networkActivityIndicatorVisible = NO;
    }];
}

- (IBAction)refresh:(id)inSender {
    [self updateItems];
}

- (NSURL *)createURL {
    NSString *theQuery = [self.query encodedStringForURLWithEncoding:NSUTF8StringEncoding];
    NSString *theURL = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos?orderby=published&max-results=48&alt=json&q=%@", theQuery];
    
    NSLog(@"URL = %@", theURL);
    return [NSURL URLWithString:theURL];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)inCollectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)inCollectionView numberOfItemsInSection:(NSInteger)inSection {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)inCollectionView
                  cellForItemAtIndexPath:(NSIndexPath *)inIndexPath {
    YouTubeCell *theCell = [inCollectionView dequeueReusableCellWithReuseIdentifier:@"YouTube" forIndexPath:inIndexPath];
    UILabel *theTitleLabel = theCell.titleLabel;
    NSDictionary *theItem = self.items[inIndexPath.row];
    float theRating = [[theItem valueForKeyPath:@"gd$rating.average"] floatValue];
    NSArray *theThumbnails = [theItem valueForKeyPath:@"media$group.media$thumbnail"];
    UIColor *theColor;
    
    if(theRating < 1) {
        theColor = [UIColor darkGrayColor];
    }
    else {
        float theValue = (theRating - 1.0) / 4.0;
        
        theColor = [UIColor colorWithRed:1.0 - theValue green:theValue blue:0.0 alpha:1.0];
    }
    theTitleLabel.text = [theItem valueForKeyPath:@"title.$t"];
    theTitleLabel.backgroundColor = theColor;
    theCell.text = [theItem valueForKeyPath:@"content.$t"];
    theCell.image = nil;
    if([theThumbnails count] > 0) {
        NSOperationQueue *theQueue = [NSOperationQueue mainQueue];
        NSString *theURLString = [theThumbnails[0] objectForKey:@"url"];
        NSURL *theURL = [NSURL URLWithString:theURLString];
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL];

        [theCell startLoadAnimation];
        [NSURLConnection sendAsynchronousRequest:theRequest queue:theQueue
                               completionHandler:^(NSURLResponse *inResponse, NSData *inData, NSError *inError) {
                                   YouTubeCell *theCell = (YouTubeCell *)[inCollectionView cellForItemAtIndexPath:inIndexPath];

                                   if(inData == nil) {
                                       NSLog(@"%@: %@", theURL, inError);
                                   }
                                   else {
                                       theCell.image = [UIImage imageWithData:inData];
                                   }
                                   [theCell stopLoadAnimation];
                               }];
    }
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
    [inCollectionView reloadItemsAtIndexPaths:@[inIndexPath]];
}

- (void)collectionView:(UICollectionView *)inCollectionView didDeselectItemAtIndexPath:(NSIndexPath *)inIndexPath {
    [inCollectionView reloadItemsAtIndexPaths:@[inIndexPath]];
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)inSearchBar {
    [inSearchBar endEditing:YES];
    self.query = inSearchBar.text;
    [self updateItems];
}

@end