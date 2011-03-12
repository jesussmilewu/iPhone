#import "AccessoryTableViewController.h"

static NSString *kCellTitles[] = {
    @"UITableViewCellAccessoryNone",
    @"UITableViewCellAccessoryDisclosureIndicator",
    @"UITableViewCellAccessoryDetailDisclosureButton",
    @"UITableViewCellAccessoryCheckmark",
    @"Custom View"
};
static UITableViewCellAccessoryType kAccessoryTypes[] = {
    UITableViewCellAccessoryNone,
    UITableViewCellAccessoryDisclosureIndicator,
    UITableViewCellAccessoryDetailDisclosureButton,
    UITableViewCellAccessoryCheckmark
};
static NSInteger kSize = 5;

@implementation AccessoryTableViewController

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)inTableView numberOfRowsInSection:(NSInteger)inSection {
    return kSize;
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)inIndexPath {
    NSString *theIdentifier = @"accessory-cell";
    UITableViewCell *theCell = [inTableView dequeueReusableCellWithIdentifier:theIdentifier];
    
    if(theCell == nil) {
        theCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:theIdentifier] autorelease];
        theCell.textLabel.font = [UIFont systemFontOfSize:12.0];
    }
    theCell.textLabel.text = kCellTitles[inIndexPath.row];
    if(inIndexPath.row < kSize - 1) {
        theCell.accessoryType = kAccessoryTypes[inIndexPath.row];
    }
    else {
        UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
        
        theView.backgroundColor = [UIColor greenColor];
        theCell.accessoryView = theView;
        [theView release];
    }
    return theCell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)inTableView didSelectRowAtIndexPath:(NSIndexPath *)inIndexPath {
    [inTableView deselectRowAtIndexPath:inIndexPath animated:YES];    
}

- (void)tableView:(UITableView *)inTableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)inIndexPath {
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Accessory Button Tapped", @"") 
                                                       message:[NSString stringWithFormat:@"indexPath=%@", inIndexPath]
                                                      delegate:nil 
                                             cancelButtonTitle:NSLocalizedString(@"OK", @"") 
                                             otherButtonTitles:nil];
    
    [theAlert show];
    [theAlert release];
}
@end
