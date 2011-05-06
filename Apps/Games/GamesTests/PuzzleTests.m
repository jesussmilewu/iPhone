//
//  GamesTests.m
//  GamesTests
//
//  Created by Clemens Wagner on 11.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PuzzleTests.h"
#import "Puzzle.h"

@interface PuzzleTests()

@property (nonatomic, retain) Puzzle *puzzle;

@end

@implementation PuzzleTests

@synthesize puzzle;

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    self.puzzle = nil;
    [super tearDown];
}

- (void)testCreation {
    self.puzzle = [Puzzle puzzleWithLength:4];
    STAssertTrue(self.puzzle.length == 4, @"invalid length = %d", self.puzzle.length);
    STAssertTrue(self.puzzle.size == 16, @"invalid size = %d", self.puzzle.size);
    for(NSUInteger i = 0; i < self.puzzle.size; ++i) {
        NSUInteger theValue = [self.puzzle valueAtIndex:i];
        
        STAssertTrue(theValue == i, @"invalid value %d at index %d", theValue, i);
    }
}

- (void)testTilt {
    self.puzzle = [Puzzle puzzleWithLength:4];
    STAssertTrue([self.puzzle tiltToDirection:PuzzleDirectionLeft], @"tilt to south failed");
    STAssertTrue(self.puzzle.freeIndex == 11, @"invalid free index %d", self.puzzle.freeIndex);
    STAssertTrue([self.puzzle valueAtIndex:15] == 11, @"invalid value %d at index 15", [self.puzzle valueAtIndex:15]);
    STAssertTrue([self.puzzle valueAtIndex:11] == 15, @"invalid value %d at index 11", [self.puzzle valueAtIndex:11]);
    STAssertFalse([self.puzzle tiltToDirection:PuzzleDirectionLeft], @"tilt to west not failed");
    STAssertTrue(self.puzzle.freeIndex == 11, @"invalid free index %d", self.puzzle.freeIndex);
    STAssertTrue([self.puzzle valueAtIndex:15] == 11, @"invalid value %d at index 15", [self.puzzle valueAtIndex:15]);
    STAssertTrue([self.puzzle valueAtIndex:11] == 15, @"invalid value %d at index 11", [self.puzzle valueAtIndex:11]);
    STAssertTrue([self.puzzle tiltToDirection:PuzzleDirectionRight], @"tilt to east failed");
    STAssertTrue(self.puzzle.freeIndex == 10, @"invalid free index %d", self.puzzle.freeIndex);
    STAssertTrue([self.puzzle valueAtIndex:15] == 11, @"invalid value %d at index 15", [self.puzzle valueAtIndex:15]);
    STAssertTrue([self.puzzle valueAtIndex:11] == 10, @"invalid value %d at index 11", [self.puzzle valueAtIndex:11]);
    STAssertTrue([self.puzzle valueAtIndex:10] == 15, @"invalid value %d at index 10", [self.puzzle valueAtIndex:10]);
}

@end
