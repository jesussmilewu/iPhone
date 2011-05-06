//
//  PuzzleViewController.h
//  Games
//
//  Created by Clemens Wagner on 13.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Puzzle;
@class NumberView;

@interface PuzzleViewController : UIViewController {
    @private
}

@property (nonatomic, retain) Puzzle *puzzle;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) IBOutlet UIView *puzzleView;
@property (nonatomic, retain) IBOutlet UISlider *lengthSlider;
@property (nonatomic, retain) IBOutlet UILabel *lengthLabel;
@property (nonatomic, retain) IBOutlet NumberView *scoreView;

- (IBAction)shuffle;
- (IBAction)PuzzleDirectionUp;
- (IBAction)updateLengthSlider;
- (IBAction)undo;
- (IBAction)redo;

@end
