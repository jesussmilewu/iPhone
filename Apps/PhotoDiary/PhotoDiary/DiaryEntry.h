#import <CoreData/CoreData.h>

extern NSString * const kMediumTypeImage;
extern NSString * const kMediumTypeAudio;

@class Medium;

@interface DiaryEntry : NSManagedObject {
    @private
}

@property (nonatomic, retain) NSData *icon;
@property (nonatomic, retain) NSDate *creationTime;
@property (nonatomic, retain) NSDate *updateTime;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, copy) NSSet *media;

- (Medium *)mediumForType:(NSString *)inType;
- (void)deleteMediumForType:(NSString *)inType;

- (void)addMediaObject:(Medium *)inMedium;
- (void)removeMediaObject:(Medium *)inMedium;

@end