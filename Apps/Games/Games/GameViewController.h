#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface GameViewController : UIViewController {
    @private
}

@property (nonatomic, retain) IBOutlet NSManagedObjectContext *managedObjectContext;

- (NSString *)game;
- (void)saveScore:(NSUInteger)inScore;

@end
