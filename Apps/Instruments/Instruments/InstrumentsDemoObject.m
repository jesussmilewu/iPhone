#import "InstrumentsDemoObject.h"

static NSUInteger objectCounter = 1;

@implementation InstrumentsDemoObject

@synthesize counter;

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
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%u", counter];
}

@end
