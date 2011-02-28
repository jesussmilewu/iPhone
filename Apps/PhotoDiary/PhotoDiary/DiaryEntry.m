#import "DiaryEntry.h"
#import "Medium.h"

NSString * const kMediumTypeImage = @"image";
NSString * const kMediumTypeAudio = @"audio";

@interface NSManagedObject(CoreDataAccessors)

- (void)addMediaObject:(Medium *)inMedium;
- (void)removeMediaObject:(Medium *)inMedium;

@end

@implementation DiaryEntry

@dynamic icon;
@dynamic creationTime;
@dynamic updateTime;
@dynamic text;
@dynamic media;

- (void)awakeFromInsert {
    [super awakeFromInsert];
    NSDate *theDate = [NSDate date];
    
    [self setPrimitiveValue:theDate forKey:@"creationTime"];
    [self setPrimitiveValue:theDate forKey:@"updateTime"];
}

- (void)willSave {
    [super willSave];
    if(!self.isDeleted) {
        NSDate *theDate = [NSDate date];
        
        [self setPrimitiveValue:theDate forKey:@"updateTime"];
    }
}

- (void)addMediaObject:(Medium *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"media" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"media"] addObject:value];
    [self didChangeValueForKey:@"media" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeMediaObject:(Medium *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"media" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"media"] removeObject:value];
    [self didChangeValueForKey:@"media" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addMedia:(NSSet *)value {    
    [self willChangeValueForKey:@"media" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"media"] unionSet:value];
    [self didChangeValueForKey:@"media" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeMedia:(NSSet *)value {
    [self willChangeValueForKey:@"media" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"media"] minusSet:value];
    [self didChangeValueForKey:@"media" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (Medium *)mediumForType:(NSString *)inType {
    for(id theMedium in self.media) {
        if([[theMedium type] isEqualToString:inType]) {
            return theMedium;
        }
    }
    return nil;
}

- (void)deleteMediumForType:(NSString *)inType {
    Medium *theMedium = [self mediumForType:inType];

    if(theMedium != nil) {
        [self removeMediaObject:theMedium];
        [self.managedObjectContext deleteObject:theMedium];
    }
}

@end
