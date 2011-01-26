#import "AudioRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import "MeterView.h"
#import "UIToolbar+Extensions.h"

static const NSTimeInterval kMaximalRecordingTime = 30.0;

@interface AudioRecorder()<AVAudioRecorderDelegate>

@property (nonatomic, retain) AVAudioRecorder *audioRecorder;
@property (nonatomic, retain) NSTimer *updateTimer;

- (NSString *)cachesDirectory;
- (NSURL *)fileURL;
- (void)startTimer;
- (void)cancelTimer;

@end

@implementation AudioRecorder

@dynamic delegate;
@synthesize audioRecorder;
@synthesize updateTimer;

- (void)dealloc {
    self.view = nil;
    self.delegate = nil;
    self.audioRecorder = nil;
    [self cancelTimer];
    [activityIndicator release];
    [super dealloc];
}

- (NSString *)cachesDirectory {
    NSArray *thePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);

    return [thePaths objectAtIndex:0];
}

- (NSURL *)fileURL {
    NSString *theDirectory = self.cachesDirectory;
    
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recording.caf", theDirectory]];
}

- (NSDictionary *)audioRecorderSettings {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInt:kAudioFormatAppleIMA4], AVFormatIDKey, 
            [NSNumber numberWithFloat:16000.0], AVSampleRateKey, 
            [NSNumber numberWithInt:1], AVNumberOfChannelsKey, nil];
}

- (NSData *)data {
    return [NSData dataWithContentsOfURL:self.fileURL];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inOrientation {
    return YES;
}

- (BOOL)recording {
    return self.audioRecorder.recording;
}

- (BOOL)pausing {
    return self.audioRecorder != nil && !self.audioRecorder.recording;
}

- (void)updateRecordButton {
    if(self.audioRecorder.recording) {
        recordButton.image = [UIImage imageNamed:@"pause.png"];
    }
    else {
        recordButton.image = [UIImage imageNamed:@"record.png"];
    }
}

- (void)setTime:(NSTimeInterval)inTime {
    timeLabel.text = [NSString stringWithFormat:@"%.0fs", inTime];
}

- (IBAction)save:(id)inSender {
    [self setVisible:NO animated:YES];
    if([self.delegate respondsToSelector:@selector(audioRecorder:didRecordToData:)]) {
        [self.delegate audioRecorder:self didRecordToData:self.data];
    }
}

- (IBAction)cancel:(id)inSender {
    [self setVisible:NO animated:YES];
    [self clear];
    if([self.delegate respondsToSelector:@selector(audioRecorderDidCancel:)]) {
        [self.delegate audioRecorderDidCancel:self];
    }
}

- (void)startRecorder {
    NSError *theError = nil;
    AVAudioRecorder *theRecorder = [[AVAudioRecorder alloc] initWithURL:self.fileURL settings:self.audioRecorderSettings error:&theError];
    
    if(theError == nil) {
        theRecorder.delegate = self;
        self.audioRecorder = theRecorder;
        [theRecorder release];
        if([self.audioRecorder recordForDuration:kMaximalRecordingTime]) {
            [self startTimer];
        };
    }
    else {
        NSLog(@"startRecording: %@", theError);
        [toolbar setEnabled:YES];
        [activityIndicator stopAnimating];
    }    
}

- (IBAction)flipRecording:(id)inSender {
    if(self.audioRecorder == nil) {
        [toolbar setEnabled:NO];
        [activityIndicator startAnimating];
        [self performSelector:@selector(startRecorder) withObject:nil afterDelay:0.0];
    }
    else if(self.recording) {
        [self.audioRecorder pause];
        [toolbar setEnabled:YES];
    }
    else if(self.pausing) {
        [self.audioRecorder record];
        [toolbar setEnabled:NO];
        recordButton.enabled = YES;
    }
    [self updateRecordButton];
}

- (IBAction)clear {
    [super clear];
    [self.audioRecorder stop];
    [self.audioRecorder deleteRecording];
    self.audioRecorder = nil;
    progressView.progress = 0.0;
    [self setTime:0.0];
    [meterView clear];
}

- (void)startTimer {
    if(self.updateTimer == nil) {
        self.audioRecorder.meteringEnabled = YES;
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 
                                                            target:self 
                                                          selector:@selector(updateTime:) 
                                                          userInfo:nil 
                                                           repeats:YES];
    }
}

- (void)cancelTimer {
    [self.updateTimer invalidate];
    self.updateTimer = nil;
    [self updateRecordButton];
}

- (void)updateTime:(NSTimer *)inTimer {
    NSTimeInterval theTime = self.audioRecorder.currentTime;
    
    [self.audioRecorder updateMeters];
    progressView.progress = theTime / kMaximalRecordingTime;
    meterView.value = [self.audioRecorder averagePowerForChannel:0];
    [self setTime:theTime];
    if(theTime > 0) {
        recordButton.enabled = YES;
        [activityIndicator stopAnimating];
    }
}

#pragma mark AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)inRecorder successfully:(BOOL)inSuccess {
    [self cancelTimer];    
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)inRecorder error:(NSError *)inError {
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") 
                                                       message:inError.localizedDescription
                                                      delegate:nil 
                                             cancelButtonTitle:NSLocalizedString(@"OK", @"OK") 
                                             otherButtonTitles:nil];
    
    [self cancelTimer];
    [self clear];
    [theAlert show];
    [theAlert release];
}

@end
