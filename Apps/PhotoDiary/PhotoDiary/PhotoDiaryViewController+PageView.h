#import "PhotoDiaryViewController.h"

@interface PhotoDiaryViewController(PageView)
#ifdef __IPHONE_5_0
<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
#endif

- (ItemViewController *)itemViewControllerWithIndexPath:(NSIndexPath *)inIndexPath;
- (void)displayItemAtIndexPath:(NSIndexPath *)inIndexPath;

@end
