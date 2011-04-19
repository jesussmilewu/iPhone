//
//  PuzzleViewController.m
//  Games
//
//  Created by Clemens Wagner on 13.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PuzzleViewController.h"
#import "UIImage_Subimage.h"
#import "Puzzle.h"
#import "NumberView.h"
#import <QuartzCore/QuartzCore.h>

const float kHorizontalMinimalThreshold = 0.2;
const float kVerticalMinimalThreshold = 0.2;
const float kHorizontalMaximalThreshold = 0.5;
const float kVerticalMaximalThreshold = 0.5;

@interface PuzzleViewController()<UIAccelerometerDelegate>

@property (nonatomic) NSUInteger shuffleCount;
@property (nonatomic) NSUInteger shuffleIndex;
@property (nonatomic) PuzzleDirection lastDirection;

- (void)buildViewWithLength:(NSUInteger)inLength;

@end

@implementation PuzzleViewController

@synthesize puzzle;
@synthesize image;
@synthesize puzzleView;
@synthesize lengthSlider;
@synthesize lengthLabel;
@synthesize scoreView;
@synthesize shuffleCount;
@synthesize shuffleIndex;
@synthesize lastDirection;

- (void)dealloc {
    self.puzzle = nil;
    self.puzzleView = nil;
    self.image = nil;
    self.lengthLabel = nil;
    self.lengthSlider = nil;
    self.scoreView = nil;
    [super dealloc];
}

- (void)addSwipeGestureRecognizerWithDirection:(UISwipeGestureRecognizerDirection)inDirection action:(SEL)inAction {
    UISwipeGestureRecognizer *theRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:inAction];
    
    theRecognizer.direction = inDirection;
    [self.puzzleView addGestureRecognizer:theRecognizer];
    [theRecognizer release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    
    [theCenter addObserver:self selector:@selector(puzzleDidTilt:) name:kPuzzleDidTiltNotification object:nil];
    [theCenter addObserver:self selector:@selector(puzzleDidTilt:) name:kPuzzleDidMoveNotification object:nil];
    self.image = [UIImage imageNamed:@"dracula.jpg"];
    [self addSwipeGestureRecognizerWithDirection:UISwipeGestureRecognizerDirectionLeft 
                                          action:@selector(handleLeftSwipe:)];
    [self addSwipeGestureRecognizerWithDirection:UISwipeGestureRecognizerDirectionRight 
                                          action:@selector(handleRightSwipe:)];
    [self addSwipeGestureRecognizerWithDirection:UISwipeGestureRecognizerDirectionUp 
                                          action:@selector(handleUpSwipe:)];
    [self addSwipeGestureRecognizerWithDirection:UISwipeGestureRecognizerDirectionDown 
                                          action:@selector(handleDownSwipe:)];
}

- (void)viewDidUnload {
    self.puzzleView = nil;
    self.lengthLabel = nil;
    self.lengthSlider = nil;
    self.scoreView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    [self clear];
    UIAccelerometer *theAccelerometer = [UIAccelerometer sharedAccelerometer];
    
    theAccelerometer.delegate = self;
    theAccelerometer.updateInterval = 0.05;
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    UIAccelerometer *theAccelerometer = [UIAccelerometer sharedAccelerometer];

    theAccelerometer.delegate = nil;
    [super viewWillDisappear:inAnimated];
}

- (void)nextTilt {
    Puzzle *thePuzzle = self.puzzle;
    PuzzleDirection theDirection = [thePuzzle bestDirectionForIndex:self.shuffleIndex];
    
    if(theDirection == PuzzleNoDirection) {
        self.shuffleCount--;
    }
    while(theDirection == PuzzleNoDirection) {
        self.shuffleIndex = rand() % thePuzzle.size;
        theDirection = [thePuzzle bestDirectionForIndex:self.shuffleIndex];
    }
    [thePuzzle tiltToDirection:theDirection];
}

- (IBAction)clear {
    NSUInteger theLength = roundf(self.lengthSlider.value);

    [self buildViewWithLength:theLength];
    self.lastDirection = PuzzleNoDirection;
    self.scoreView.value = 0;
}

- (IBAction)shuffle {
    NSUInteger theSize = self.puzzle.size;
    
    [self.scoreView setValue:0 animated:YES];
    self.shuffleIndex = rand() % theSize;
    self.shuffleCount = 4 * theSize;
    [self nextTilt];
}

- (IBAction)updateLengthSlider {
    NSUInteger theLength = roundf(self.lengthSlider.value);
    
    self.lengthSlider.value = theLength;
    self.lengthLabel.text = [NSString stringWithFormat:@"%u", theLength];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return inInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)buildViewWithLength:(NSUInteger)inLength {
    Puzzle *thePuzzle = [Puzzle puzzleWithLength:inLength];
    UIView *thePuzzleView = self.puzzleView;
    CGSize theSize = thePuzzleView.frame.size;
    NSArray *theImages = [self.image splitIntoSubimagesWithRows:inLength columns:inLength];
    CGRect theFrame = CGRectMake(0.0, 0.0, theSize.width / inLength, theSize.height / inLength);
    NSUInteger theIndex = 0;
    
    self.puzzle = thePuzzle;
    for(NSUInteger theRow = 0; theRow < inLength; ++theRow) {
        theFrame.origin.y = theRow * CGRectGetHeight(theFrame);
        for(NSUInteger theColumn = 0; theColumn < inLength; ++theColumn) {
            UIImageView *theImageView = theIndex < thePuzzleView.subviews.count ? 
            [thePuzzleView.subviews objectAtIndex:theIndex] : nil;

            theFrame.origin.x = theColumn * CGRectGetWidth(theFrame);
            if(theImageView == nil) {
                theImageView = [[UIImageView alloc] initWithFrame:theFrame];
                /*
                 theImageView.layer.borderColor = [UIColor blackColor].CGColor;
                 theImageView.layer.borderWidth = 1.0;
                 theImageView.layer.masksToBounds = YES;
                 */
                [thePuzzleView addSubview:[theImageView autorelease]];
            }
            if(theIndex == thePuzzle.freeIndex) {
                theImageView.backgroundColor = [UIColor redColor];
                theImageView.image = nil;
            }
            else {
                theImageView.image = [theImages objectAtIndex:theIndex];
            }
            theImageView.tag = [thePuzzle valueAtIndex:theIndex];
            theImageView.frame = theFrame;
            theIndex++;
        }
    }
    while(theIndex < thePuzzleView.subviews.count) {
        [thePuzzleView.subviews.lastObject removeFromSuperview];
    }
}

- (CGRect)frameForItemAtIndex:(NSUInteger)inIndex {
    CGSize theSize = self.puzzleView.frame.size;
    NSUInteger theLength = self.puzzle.length;
    NSUInteger theRow = inIndex / theLength;
    NSUInteger theColumn = inIndex % theLength;
    
    theSize.width /= theLength;
    theSize.height /= theLength;
    return CGRectMake(theColumn * theSize.width, theRow * theSize.height, theSize.width, theSize.height);
}

- (void)puzzleDidTilt:(NSNotification *)inNotification {
    BOOL theShuffleFlag = self.shuffleCount > 0;
    NSDictionary *theInfo = inNotification.userInfo;
    NSUInteger theFromIndex = [[theInfo objectForKey:kPuzzleFromIndexKey] intValue];
    NSUInteger theToIndex = [[theInfo objectForKey:kPuzzleToIndexKey] intValue];
    UIView *thePuzzleView = self.puzzleView;
    UIView *theFromView = [thePuzzleView.subviews objectAtIndex:theFromIndex];
    UIView *theToView = [thePuzzleView.subviews objectAtIndex:theToIndex];
    NSTimeInterval theDuration = theShuffleFlag ? 0.10 : 0.4;
    
    [thePuzzleView exchangeSubviewAtIndex:theFromIndex withSubviewAtIndex:theToIndex];
    [UIView animateWithDuration:theDuration 
                     animations:^{
                         theFromView.frame = [self frameForItemAtIndex:theToIndex];
                         theToView.frame = [self frameForItemAtIndex:theFromIndex];
                     }
                     completion:^(BOOL inFinshed) {
                         if(theShuffleFlag) {
                             [self nextTilt];
                         }
                     }];
}

- (BOOL)handleGestureRecognizer:(UIGestureRecognizer *)inRecognizer withDirection:(PuzzleDirection)inDirection {
    UIView *thePuzzleView = self.puzzleView;
    NSUInteger theLength = self.puzzle.length;
    CGPoint thePoint = [inRecognizer locationInView:thePuzzleView];
    CGSize theSize = thePuzzleView.frame.size;
    NSUInteger theRow = thePoint.y * theLength / theSize.height;
    NSUInteger theColumn = thePoint.x * theLength / theSize.width;
    NSUInteger theIndex = theRow * theLength + theColumn;
    
    if([self.puzzle moveItemAtIndex:theIndex toDirection:inDirection]) {
        [self.scoreView setValue:self.scoreView.value + 1 animated:YES];
        return YES;
    }
    else {
        return NO;
    }
}

- (void)handleLeftSwipe:(UISwipeGestureRecognizer *)inRecognizer {
    [self handleGestureRecognizer:inRecognizer withDirection:PuzzleDirectionWest];
}

- (void)handleRightSwipe:(UISwipeGestureRecognizer *)inRecognizer {
    [self handleGestureRecognizer:inRecognizer withDirection:PuzzleDirectionEast];
}

- (void)handleUpSwipe:(UISwipeGestureRecognizer *)inRecognizer {
    [self handleGestureRecognizer:inRecognizer withDirection:PuzzleDirectionNorth];
}

- (void)handleDownSwipe:(UISwipeGestureRecognizer *)inRecognizer {
    [self handleGestureRecognizer:inRecognizer withDirection:PuzzleDirectionSouth];
}

#pragma mark UIAccelerometerDelegate

- (void)accelerometer:(UIAccelerometer *)inAccelerometer didAccelerate:(UIAcceleration *)inAcceleration {
    if(self.shuffleCount == 0) {
        float theX = inAcceleration.x;
        float theY = inAcceleration.y;
        
        if(self.lastDirection == PuzzleNoDirection) {
            if(fabs(theX) > kHorizontalMaximalThreshold) {
                self.lastDirection = theX < 0 ? PuzzleDirectionWest : PuzzleDirectionEast;
            }
            else if(fabs(theY) > kVerticalMaximalThreshold) {
                self.lastDirection = theY < 0 ? PuzzleDirectionSouth : PuzzleDirectionNorth;
            }
            if([self.puzzle tiltToDirection:self.lastDirection]) {
                [self.scoreView setValue:self.scoreView.value + 1 animated:YES];                
            }
        }
        else if(fabs(theX) < kHorizontalMinimalThreshold && fabs(theY) < kVerticalMinimalThreshold) {
            self.lastDirection = PuzzleNoDirection;
        }
    }
}

@end
