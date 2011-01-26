#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SubviewController.h"

@class ItemViewController;
@class DiaryEntryCell;
@class SlideShowController;
@class AudioPlayer;

@interface PhotoDiaryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, SubviewControllerDelegate> {
    @private
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet ItemViewController *itemViewController;
@property (nonatomic, retain) IBOutlet NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet DiaryEntryCell *cellPrototype;
@property (nonatomic, retain) IBOutlet SlideShowController *slideShowController;
@property (nonatomic, retain) IBOutlet AudioPlayer *audioPlayer;

- (IBAction)showSlideShow;
- (IBAction)addItem;
- (IBAction)playSound:(id)inSender;

@end
