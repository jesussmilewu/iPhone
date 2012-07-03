//
//  DownloadViewController.m
//  Shop
//
//  Created by Clemens Wagner on 29.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DownloadViewController.h"
#import "UIViewController+SiteSchedule.h"
#import "NSDictionary+HTTPRequest.h"

static NSString * const kDownloadURL = @"http://nostromo.local/~clemens/SiteSchedule/small.xml";

@interface DownloadViewController()<NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITableViewCell *sitesCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *teamsCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *activitiesCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *updateCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *serverCell;

@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic) NSUInteger dataLength;
@property (strong, nonatomic) NSMutableData *data;

- (void)refreshServerCell;
- (void)refresh;
- (NSUInteger)countElementsForEntityNamed:(NSString *)inName;

@end

@implementation DownloadViewController

@synthesize managedObjectContext;
@synthesize sitesCell;
@synthesize teamsCell;
@synthesize activitiesCell;
@synthesize updateCell;
@synthesize serverCell;
@synthesize overlayView;
@synthesize progressView;

@synthesize dataLength;
@synthesize data;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.managedObjectContext = [self newManagedObjectContext];
    [self refreshServerCell];
}

- (void)viewDidUnload {
    self.managedObjectContext = nil;
    self.sitesCell = nil;
    self.updateCell = nil;
    self.serverCell = nil;
    self.overlayView = nil;
    self.progressView = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    [self refresh];
}

- (UIView *)overlayParentView {
    return self.view.window.rootViewController.view;
}

- (BOOL)overlayHidden {
    return self.overlayView.superview == nil;
}

- (void)setOverlayHidden:(BOOL)inHidden {
    if(inHidden) {
        [self.overlayView removeFromSuperview];
    }
    else {
        UIView *theView = self.overlayParentView;
        
        self.overlayView.frame = theView.bounds;
        [theView addSubview:self.overlayView];
    }
}

- (void)setOverlayHidden:(BOOL)inHidden animated:(BOOL)inAnimated {
    self.overlayView.frame = self.overlayParentView.bounds;
    [UIView transitionWithView:self.overlayParentView duration:0.75 
                       options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionLayoutSubviews
                    animations:^{
                        self.overlayHidden = inHidden;
                    }
                    completion:NULL];
}

- (void)refreshServerCell {
    NSURL *theURL = [NSURL URLWithString:kDownloadURL];
    NSDictionary *theFields = [NSDictionary dictionaryWithHeaderFieldsForURL:theURL];
    NSString *theText = [NSDateFormatter localizedStringFromDate:[theFields lastModified] 
                                                       dateStyle:NSDateFormatterShortStyle 
                                                       timeStyle:NSDateFormatterShortStyle];

    self.serverCell.detailTextLabel.text = theText;
}

- (void)refresh {
    NSString *theDateText = @"-";
    NSUInteger theCount;
    NSTimeInterval theTime = [[NSUserDefaults standardUserDefaults] doubleForKey:@"updateTime"];
    NSDate *theDate = theTime > 0.0 ? [NSDate dateWithTimeIntervalSinceReferenceDate:theTime] : nil;
    
    [self.managedObjectContext reset];
    theCount = [self countElementsForEntityNamed:@"Site"];
    self.sitesCell.detailTextLabel.text = [NSString stringWithFormat:@"%u", theCount];
    theCount = [self countElementsForEntityNamed:@"Team"];
    self.teamsCell.detailTextLabel.text = [NSString stringWithFormat:@"%u", theCount];
    theCount = [self countElementsForEntityNamed:@"Activity"];
    self.activitiesCell.detailTextLabel.text = [NSString stringWithFormat:@"%u", theCount];
    if(theDate != nil) {
        theDateText = [NSDateFormatter localizedStringFromDate:theDate 
                                                     dateStyle:NSDateFormatterShortStyle 
                                                     timeStyle:NSDateFormatterShortStyle];
    }
    self.updateCell.detailTextLabel.text = theDateText;
    if(!self.overlayHidden) {
        [self setOverlayHidden:YES animated:YES];
    }
}

- (NSUInteger)countElementsForEntityNamed:(NSString *)inName {
    NSFetchRequest *theRequest = [[NSFetchRequest alloc] init];
    
    theRequest.entity = [NSEntityDescription entityForName:inName 
                                    inManagedObjectContext:self.managedObjectContext];
    return [self.managedObjectContext countForFetchRequest:theRequest error:NULL];
}

- (void)startDownload {
    NSURL *theURL = [NSURL URLWithString:kDownloadURL];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL];
    
    [NSURLConnection connectionWithRequest:theRequest delegate:self];    
}

- (void)updateScheduleWithStream:(NSInputStream *)inStream {
    NSError *theError = [self.applicationDelegate updateWithInputStream:inStream];
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
    
    if(theError) {
        NSLog(@"updateSchedule: error = %@", theError);
    }
    [theDefaults setDouble:[NSDate timeIntervalSinceReferenceDate] forKey:@"updateTime"];
    [theDefaults synchronize];
    [self refresh];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)inTableView didSelectRowAtIndexPath:(NSIndexPath *)inIndexPath {
    [inTableView deselectRowAtIndexPath:inIndexPath animated:YES];
    if(inIndexPath.section == 1 && inIndexPath.row == 0) {
        [self setOverlayHidden:NO animated:YES];
        self.progressView.progress = 0.0;
        [self performSelector:@selector(startDownload) withObject:nil afterDelay:1.0];
    }
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)inConnection didReceiveResponse:(NSURLResponse *)inResponse {
    NSDictionary *theFields = [(id)inResponse allHeaderFields];
    
    self.dataLength = (NSUInteger) theFields.contentLength;
    self.data = [NSMutableData dataWithCapacity:self.dataLength];
    self.progressView.progress = 0.0;
}

- (void)connection:(NSURLConnection *)inConnection didReceiveData:(NSData *)inData {
    [self.data appendData:inData];
    self.progressView.progress = (double) self.data.length / (double) self.dataLength;
}

- (void)connection:(NSURLConnection *)inConnection didFailWithError:(NSError *)inError {
    self.data = nil;
    NSLog(@"error = %@", inError);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)inConnection {
    NSInputStream *theStream = [NSInputStream inputStreamWithData:self.data];
    
    [self performSelector:@selector(updateScheduleWithStream:) withObject:theStream afterDelay:0.5];
    self.data = nil;    
    [self setOverlayHidden:YES animated:YES];
}

@end
