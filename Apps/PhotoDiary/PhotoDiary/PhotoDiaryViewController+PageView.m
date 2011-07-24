#import "PhotoDiaryViewController+PageView.h"
#import "ItemViewController.h"

@implementation PhotoDiaryViewController(PageView)

- (ItemViewController *)itemViewControllerWithIndexPath:(NSIndexPath *)inIndexPath {
    DiaryEntry *theItem = [self entryForTableView:self.currentTableView atIndexPath:inIndexPath];
    ItemViewController *theController = [[ItemViewController alloc] init];
    
    theController.item = theItem;
    theController.indexPath = inIndexPath;
    return [theController autorelease];
}

- (void)pushItemAtIndexPath:(NSIndexPath *)inIndexPath {
    ItemViewController *theItemController = self.itemViewController;    
    DiaryEntry *theItem = [self entryForTableView:self.currentTableView atIndexPath:inIndexPath];
    
    theItemController.item = theItem;
    theItemController.indexPath = inIndexPath;
    [self.navigationController pushViewController:theItemController animated:YES];
}

#ifdef __IPHONE_5_0
- (void)displayItemAtIndexPath:(NSIndexPath *)inIndexPath {
    if(NSClassFromString(@"UIPageViewController") == nil) {
        [self pushItemAtIndexPath:inIndexPath];
    }
    else {
        ItemViewController *theItemController = self.itemViewController;    
        UIPageViewController *theController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        theItemController = [self itemViewControllerWithIndexPath:inIndexPath];
        theController.delegate = self;
        theController.dataSource = self;
        [theController setViewControllers:[[NSArray arrayWithObject:theItemController] retain]
                                direction:UIPageViewControllerNavigationDirectionForward 
                                 animated:NO completion:nil];
        [self.navigationController pushViewController:theController animated:YES];
        [theController release];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)inPageViewController 
      viewControllerBeforeViewController:(UIViewController *)inViewController {
    ItemViewController *theController = (ItemViewController *)inViewController;
    NSIndexPath *theIndexPath = theController.indexPath;

    if(theIndexPath.row > 0) {
        theIndexPath = [NSIndexPath indexPathForRow:theIndexPath.row - 1 inSection:theIndexPath.section];
        return [self itemViewControllerWithIndexPath:theIndexPath];
    }
    else {
        return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)inPageViewController 
       viewControllerAfterViewController:(UIViewController *)inViewController {
    ItemViewController *theController = (ItemViewController *)inViewController;
    NSIndexPath *theIndexPath = theController.indexPath;
    UITableView *theTableView = self.currentTableView;
    
    if(theIndexPath.row + 1 < [self tableView:theTableView numberOfRowsInSection:theIndexPath.section]) {
        theIndexPath = [NSIndexPath indexPathForRow:theIndexPath.row + 1 inSection:theIndexPath.section];
        return [self itemViewControllerWithIndexPath:theIndexPath];
    }
    else {
        return nil;
    }
}
#else
- (void)displayItemAtIndexPath:(NSIndexPath *)inIndexPath {
    [self pushItemAtIndexPath:inIndexPath];
}
#endif

@end
