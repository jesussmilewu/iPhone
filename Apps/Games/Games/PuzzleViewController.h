#import "GameViewController.h"

@class Puzzle;
@class NumberView;

@interface PuzzleViewController : GameViewController {
    @private
}

@property (nonatomic, retain) Puzzle *puzzle;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) IBOutlet UIView *puzzleView;
@property (nonatomic, retain) IBOutlet UISlider *lengthSlider;
@property (nonatomic, retain) IBOutlet UILabel *lengthLabel;
@property (nonatomic, retain) IBOutlet NumberView *scoreView;

- (IBAction)shuffle;
- (IBAction)clear;
- (IBAction)updateLengthSlider;
- (IBAction)undo;
- (IBAction)redo;

@end
