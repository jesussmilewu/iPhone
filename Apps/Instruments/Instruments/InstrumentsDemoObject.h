#import <Foundation/Foundation.h>

@interface InstrumentsDemoObject : NSObject {
    @private
}

@property (nonatomic, readonly) NSUInteger counter;

+ (id)object;

@end
