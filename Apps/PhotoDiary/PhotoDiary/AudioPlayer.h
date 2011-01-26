#import "SubviewController.h"

@class MeterView;
@class Medium;

@interface AudioPlayer : SubviewController {
    @private
    IBOutlet UIBarButtonItem *playButton;
    IBOutlet UISlider *slider;
    IBOutlet MeterView *meterView;
    IBOutlet UILabel *timeLabel;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIToolbar *toolbar;
}

@property(nonatomic, retain) Medium *audioMedium;
@property(nonatomic) NSTimeInterval time;

- (IBAction)stop;
- (IBAction)flipPlayback;
- (IBAction)startSearching;
- (IBAction)updatePosition;

- (IBAction)updateTimeLabel;

@end
