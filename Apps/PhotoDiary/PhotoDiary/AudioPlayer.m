#import "AudioPlayer.h"
#import "Medium.h"
#import "MeterView.h"
#import "UIToolbar+Extensions.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer()<AVAudioPlayerDelegate>

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL paused;
@property (nonatomic, retain) NSTimer *updateTimer;

- (void)startTimer;
- (void)cancelTimer;

@end

@implementation AudioPlayer

@synthesize audioMedium;
@synthesize audioPlayer;
@synthesize paused;
@synthesize updateTimer;

- (void)dealloc {
    self.audioMedium = nil;
    self.audioPlayer = nil;
    [self cancelTimer];
    [toolbar release];
    [super dealloc];
}

- (NSTimeInterval)time {
    return slider.value;
}

- (void)setTime:(NSTimeInterval)inTime {
    slider.value = inTime;
    self.audioPlayer.currentTime = inTime;
    [self updateTimeLabel];
}

- (void)updatePlayButton {
    playButton.image = [UIImage imageNamed:self.paused ? @"play.png" : @"pause.png"]; 
}

- (void)startAudioPlayer {
    NSError *theError = nil;
    AVAudioPlayer *thePlayer = [[AVAudioPlayer alloc] initWithData:self.audioMedium.data error:&theError];
    
    if(theError == nil) {
        self.audioPlayer = [thePlayer autorelease];
        thePlayer.delegate = self;
        thePlayer.meteringEnabled = YES;
        self.time = slider.value;
        slider.maximumValue = thePlayer.duration;
        [self startTimer];
        [thePlayer playAtTime:self.time];
    }
    else {
        NSLog(@"playAudio: %@", theError.localizedDescription);
        [activityIndicator stopAnimating];
    }
}

- (IBAction)stop {
    [self setVisible:NO animated:YES];
}

- (IBAction)flipPlayback {
    if(self.audioPlayer == nil) {
        [activityIndicator startAnimating];
        [self performSelector:@selector(startAudioPlayer) withObject:nil afterDelay:0.0];
        self.paused = NO;
    }
    else if(self.audioPlayer.playing) {
        self.paused = YES;
        [self.audioPlayer pause];
    }
    else {
        self.paused = NO;
        self.audioPlayer.currentTime = slider.value;
        [self.audioPlayer play];        
        [self startTimer];
    }
    [self updatePlayButton];
}

- (IBAction)startSearching {
    if(self.audioPlayer.playing) {
        [self.audioPlayer pause];
        self.paused = NO;
    }
}

- (IBAction)updatePosition {
    self.audioPlayer.currentTime = slider.value;
    if(!self.paused) {
        [self.audioPlayer play];
    }
}

- (IBAction)clear {
    [super clear];
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    [meterView clear];
    self.time = 0.0;
}

- (IBAction)updateTimeLabel {
    timeLabel.text = [NSString stringWithFormat:@"%.0fs", slider.value];    
}

- (void)startTimer {
    if(self.updateTimer == nil) {
        self.audioPlayer.meteringEnabled = YES;
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
}

- (void)updateTime:(NSTimer *)inTimer {
    NSTimeInterval theTime = self.audioPlayer.currentTime;
    
    [self.audioPlayer updateMeters];
    self.time = theTime;
    meterView.value = [self.audioPlayer averagePowerForChannel:0];
    if(theTime > 0) {
        [toolbar setEnabled:YES];
        [activityIndicator stopAnimating];
    }
}

#pragma mark AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)inPlayer successfully:(BOOL)inFlag {
    [self cancelTimer];
    self.paused = YES;
    self.time = 0.0;
    [meterView clear];
    [self updatePlayButton];
}

@end
