#import "GameViewController.h"
#import "Score.h"

@implementation GameViewController

@synthesize managedObjectContext;
@synthesize highscoreItem;

- (void)dealloc {
    self.managedObjectContext = nil;
    self.highscoreItem = nil;
    [super dealloc];
}

- (NSString *)game {
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    self.managedObjectContext = nil;
    self.highscoreItem = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inOrientation {
    return (inOrientation == UIInterfaceOrientationPortrait);
}

- (void)saveScore:(NSUInteger)inScore {
    if(inScore > 0) {
        UITabBarItem *theItem = self.highscoreItem;
        NSString *theValue = [NSString stringWithFormat:@"%d", [theItem.badgeValue intValue] + 1];
        Score *theScore = [NSEntityDescription insertNewObjectForEntityForName:@"Score"
                                                        inManagedObjectContext:self.managedObjectContext];
        

        theScore.score = [NSNumber numberWithUnsignedInteger:inScore];
        theScore.game = self.game;
        [self.managedObjectContext save:NULL];
        theItem.badgeValue = theValue;
    }
}

@end
