#import "SubviewController.h"

@class MeterView;
@class AudioRecorder;

@protocol AudioRecorderDelegate<SubviewControllerDelegate>

@optional
-(void)audioRecorder:(AudioRecorder *)inRecorder didRecordToData:(NSData *)inData;
-(void)audioRecorderDidCancel:(AudioRecorder *)inRecorder;

@end

@interface AudioRecorder : SubviewController {
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