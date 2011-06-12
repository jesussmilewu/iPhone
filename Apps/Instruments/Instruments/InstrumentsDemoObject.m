#import "InstrumentsDemoObject.h"

static NSUInteger objectCounter = 1;

@interface InstrumentsDemoObject()

@property (nonatomic, retain) InstrumentsDemoObject *next;

@end

@implementation InstrumentsDemoObject

@synthesize counter;
@synthesize next;

+ (id)object {
    return [[[self alloc] init] autorelease];
}

- (id)init {
    self = [super init];
    if (self) {
        counter = objectCounter++;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc: %u", counter);
    self.next = nil;
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%u", counter];
}

@end
