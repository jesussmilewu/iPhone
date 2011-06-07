#import "GameViewController.h"
#import "Score.h"

@implementation GameViewController

@synthesize managedObjectContext;

- (void)dealloc {
    self.managedObjectContext = nil;
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
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inOrientation {
    return (inOrientation == UIInterfaceOrientationPortrait);
}

- (void)saveScore:(NSUInteger)inScore {
    if(inScore > 0) {
        Score *theScore = [NSEntityDescription insertNewObjectForEntityForName:@"Score"
                                                        inManagedObjectContext:self.managedObjectContext];
        

        theScore.score = [NSNumber numberWithUnsignedInteger:inScore];
        theScore.game = self.game;
        [self.managedObjectContext save:NULL];
    }
}

@end
