#import "InstrumentsViewController.h"
#import "InstrumentsDemoObject.h"

@interface InstrumentsViewController()

@property (nonatomic, retain) NSMutableSet *zombies;

@end

@implementation InstrumentsViewController

@synthesize zombies;

- (void)dealloc {
    self.zombies = nil;
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.zombies = [NSMutableSet set];
}

- (IBAction)makeZombie {
    id theZombie = [InstrumentsDemoObject object];
    
    NSLog(@"zombies=%@", self.zombies);
    [self.zombies addObject:theZombie];
    [theZombie release];
}

- (IBAction)makeLeak {
    id theLeak = [[InstrumentsDemoObject alloc] init];
    
    NSLog(@"leak=%@", theLeak);
}

@end
