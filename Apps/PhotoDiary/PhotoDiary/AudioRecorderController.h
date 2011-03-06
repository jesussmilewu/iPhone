#import "SubviewController.h"

@class MeterView;
@class AudioRecorderController;

@protocol AudioRecorderDelegate<SubviewControllerDelegate>

@optional
-(void)audioRecorder:(AudioRecorderController *)inRecorder didRecordToData:(NSData *)inData;
-(void)audioRecorderDidCancel:(AudioRecorderController *)inRecorder;

@end

@interface AudioRecorderController : SubviewController {
    @private
    IBOutlet UIBarButtonItem *recordButton;
    IBOutlet UIProgressView *progressView;
    IBOutlet MeterView *meterView;
    IBOutlet UILabel *timeLabel;
    IBOutlet UIToolbar *toolbar;
    IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property(nonatomic, assign) IBOutlet id<AudioRecorderDelegate> delegate;
@property(nonatomic, readonly) BOOL recording;
@property(nonatomic, readonly) BOOL pausing;
@property (nonatomic, retain, readonly) NSData *data;

- (IBAction)save:(id)inSender;
- (IBAction)cancel:(id)sender;
- (IBAction)flipRecording:(id)inSender;

@end