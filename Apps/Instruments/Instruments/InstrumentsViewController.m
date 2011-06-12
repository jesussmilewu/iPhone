#import "InstrumentsViewController.h"
#import "InstrumentsDemoObject.h"

@interface InstrumentsViewController()

@property (nonatomic, retain) NSMutableSet *zombies;
@property (nonatomic, retain) InstrumentsDemoObject *attributeLeak;
@property (nonatomic, retain) InstrumentsDemoObject *attributeZombie;

@end

@implementation InstrumentsViewController

@synthesize zombies;
@synthesize attributeLeak;
@synthesize attributeZombie;

- (void)dealloc {
    self.zombies = nil;
    self.attributeLeak = nil;
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

- (IBAction)makeAttributeLeak {
    attributeLeak = [[InstrumentsDemoObject object] retain];
}

- (IBAction)makeAttributeZombie {
    NSLog(@"attributeZombie = %@", attributeZombie);
    attributeZombie = [InstrumentsDemoObject object];
}



@end
