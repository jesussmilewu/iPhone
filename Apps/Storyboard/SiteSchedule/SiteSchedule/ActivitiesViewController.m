//
//  ActivitiesViewController.m
//  SiteSchedule
//
//  Created by Clemens Wagner on 14.07.12.
//
//

#import "ActivitiesViewController.h"
#import "DetailsViewController.h"
#import "Model.h"

@interface ActivitiesViewController ()

@end

@implementation ActivitiesViewController

@synthesize activities;

- (void)setUnorderedActivities:(NSSet *)inSet {
    NSSortDescriptor *theDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"start" ascending:YES];
    
    self.activities = [inSet sortedArrayUsingDescriptors:[NSArray arrayWithObject:theDescriptor]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)inSegue sender:(id)inSender {
    if([inSegue.identifier isEqualToString:@"Details"]) {
        DetailsViewController *theController = inSegue.destinationViewController;
        NSIndexPath *theIndexPath = [self.tableView indexPathForSelectedRow];
        Activity *theActivity = [self.activities objectAtIndex:theIndexPath.row];
        
        theController.activity = theActivity;
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)inTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)inTableView numberOfRowsInSection:(NSInteger)inSection {
    return [self.activities count];
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)inIndexPath {
    UITableViewCell *theCell = [inTableView dequeueReusableCellWithIdentifier:@"Activity"];
    Activity *theActivity = [self.activities objectAtIndex:inIndexPath.row];
    
    theCell.textLabel.text = theActivity.team.name;
    theCell.detailTextLabel.text = theActivity.details;
    return theCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)inTableView didSelectRowAtIndexPath:(NSIndexPath *)inIndexPath {
}

@end
