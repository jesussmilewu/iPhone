#import "SubviewController.h"

@class MeterView;
@class Medium;

@interface AudioPlayerController : SubviewController 

@property(nonatomic) Medium *audioMedium;
@property(nonatomic) NSTimeInterval time;

- (IBAction)stop;
- (IBAction)flipPlayback;
- (IBAction)startSearching;
- (IBAction)updatePosition;

- (IBAction)updateTimeLabel;

@end
