//
//  Puzzle.m
//  Games
//
//  Created by Clemens Wagner on 11.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Puzzle.h"

NSString * const kPuzzleDidTiltNotification = @"kPuzzleDidTiltNotification";
NSString * const kPuzzleDidMoveNotification = @"kPuzzleDidMoveNotification";
NSString * const kPuzzleDirectionKey = @"kPuzzleDirectionKey";
NSString * const kPuzzleFromIndexKey = @"kPuzzleFromIndexKey";
NSString * const kPuzzleToIndexKey = @"kPuzzleToIndexKey";

@interface Puzzle()

@property (nonatomic, readwrite) NSUInteger length;
@property (nonatomic, readwrite) NSUInteger *items;
@property (nonatomic, readwrite) NSUInteger freeIndex;
@property (nonatomic, readwrite) NSUInteger moveCount;

@end

@implementation Puzzle

@synthesize length;
@synthesize items;
@synthesize freeIndex;
@synthesize moveCount;

+ (id)puzzleWithLength:(NSUInteger)inLength {
    return [[[self alloc] initWithLength:inLength] autorelease];
}

- (id)initWithLength:(NSUInteger)inLength {
    self = [super init];
    if(self) {
        self.length = inLength;
        self.items = calloc(inLength * inLength, sizeof(NSUInteger));
        offsets[PuzzleDirectionNorth] = (NSInteger)inLength;
        offsets[PuzzleDirectionEast] = -1;
        offsets[PuzzleDirectionSouth] = -(NSInteger)inLength;
        offsets[PuzzleDirectionWest] = 1;
        [self clear];
    }
    return self;
}

- (void)dealloc {
    free(self.items);
    [super dealloc];
}

- (NSUInteger)size {
    return self.length * self.length;
}

- (void)clear {
    NSUInteger theSize = self.size;

    for(NSUInteger i = 0; i < theSize; ++i) {
        self.items[i] = i;
    }
    self.freeIndex = theSize - 1;
    self.moveCount = 0;
}

- (NSUInteger)nextIndex {
    NSUInteger theSize = self.size;
    NSUInteger theIndex = 0;
    PuzzleDirection theDirection = PuzzleNoDirection;
    
    while(theDirection == PuzzleNoDirection) {
        theIndex = rand() % theSize;
        theDirection = [self bestDirectionForIndex:theIndex];
    }
    return theIndex;
}
- (void)shuffle {
    NSUInteger theSize = self.size;

    for(NSUInteger i = 0; i < 4 * theSize; ++i) {
        NSUInteger theShuffleIndex = self.nextIndex;
        PuzzleDirection theDirection = [self bestDirectionForIndex:theShuffleIndex];
        
        while(theDirection != PuzzleNoDirection) {
            [self tiltToDirection:theDirection];
            theDirection = [self bestDirectionForIndex:theShuffleIndex];
        }
    }
    self.moveCount = 0;
}

- (BOOL)solved {
    NSUInteger theSize = self.size;
    
    for(NSUInteger i = 0; i < theSize; ++i) {
        if(self.items[i] != i) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)rowOfIndex:(NSUInteger)inFromIndex isEqualToRowOfIndex:(NSUInteger)inToIndex {
    NSUInteger theLength = self.length;
    NSUInteger theSize = self.size;

    return inFromIndex < theSize && inToIndex < theSize && (inFromIndex / theLength) == (inToIndex / theLength);
}

- (BOOL)columnOfIndex:(NSUInteger)inFromIndex isEqualColumnOfIndex:(NSUInteger)inToIndex {
    NSUInteger theLength = self.length;
    NSUInteger theSize = self.size;
    
    return inFromIndex < theSize && inToIndex < theSize && (inFromIndex % theLength) == (inToIndex % theLength);
}

- (void)swapItemFromIndex:(NSUInteger)inFromIndex toIndex:(NSUInteger)inToIndex {
    NSUInteger *theItems = self.items;
    NSUInteger theValue = theItems[inToIndex];
    
    theItems[inToIndex] = theItems[inFromIndex];
    theItems[inFromIndex] = theValue;
}

- (void)postNotificationNamed:(NSString *)inName 
                withDirection:(PuzzleDirection)inDirection 
                    fromIndex:(NSUInteger)inFromIndex 
                      toIndex:(NSUInteger)inToIndex {
    NSDictionary *theInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithUnsignedInteger:inDirection], kPuzzleDirectionKey,
                             [NSNumber numberWithUnsignedInteger:inFromIndex], kPuzzleFromIndexKey,
                             [NSNumber numberWithUnsignedInteger:inToIndex], kPuzzleToIndexKey,
                             nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:inName object:self userInfo:theInfo];
}

- (PuzzleDirection)bestDirectionForIndex:(NSUInteger)inIndex {
    NSUInteger theFreeIndex = self.freeIndex;

    if(inIndex == theFreeIndex) {
        return PuzzleNoDirection;
    }
    else if([self rowOfIndex:theFreeIndex isEqualToRowOfIndex:inIndex]) {
        return inIndex < theFreeIndex ? PuzzleDirectionEast : PuzzleDirectionWest;
    }
    else {
        return inIndex < theFreeIndex ? PuzzleDirectionSouth : PuzzleDirectionNorth;
    }
}

- (BOOL)tiltToDirection:(PuzzleDirection)inDirection {
    if(inDirection != PuzzleNoDirection) {
        NSUInteger theFreeIndex = self.freeIndex;
        NSUInteger theIndex = theFreeIndex + offsets[inDirection];
        
        if([self rowOfIndex:theFreeIndex isEqualToRowOfIndex:theIndex] || [self columnOfIndex:theFreeIndex isEqualColumnOfIndex:theIndex]) {
            [self swapItemFromIndex:theFreeIndex toIndex:theIndex];
            [self postNotificationNamed:kPuzzleDidTiltNotification withDirection:inDirection fromIndex:theIndex toIndex:theFreeIndex];
            self.freeIndex = theIndex;
            self.moveCount++;
            return YES;
        }
    }
    return NO;
}

- (BOOL)moveItemAtIndex:(NSUInteger)inIndex toDirection:(PuzzleDirection)inDirection {
    if(inDirection != PuzzleNoDirection) {
        NSUInteger theFreeIndex = self.freeIndex;
        NSUInteger theIndex = inIndex - offsets[inDirection];
        
        if(theIndex == theFreeIndex) {
            [self swapItemFromIndex:theFreeIndex toIndex:theIndex];
            self.freeIndex = inIndex;
            [self postNotificationNamed:kPuzzleDidMoveNotification withDirection:inDirection fromIndex:inIndex toIndex:theFreeIndex];
            self.moveCount++;
            return YES;
        }
    }
    return NO;
}

- (NSUInteger)valueAtIndex:(NSUInteger)inIndex {
    return self.items[inIndex];
}

@end
