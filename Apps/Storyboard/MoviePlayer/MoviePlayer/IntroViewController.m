//
//  IntroViewController.m
//  MoviePlayer
//
//  Created by Clemens Wagner on 24.06.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "IntroViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@interface IntroViewController()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation IntroViewController

- (CALayer *)makePlayerLayerWithStep:(int)inStep {
    NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"elephants-dream" withExtension:@"mp4"];
    AVPlayer *thePlayer = [AVPlayer playerWithURL:theURL];
    AVPlayerLayer *theLayer = [AVPlayerLayer playerLayerWithPlayer:thePlayer];
    CGRect theBounds = self.view.layer.bounds;
    CGRect theFrame = CGRectMake(0.0, 0.0, 360.0, 240.0);
    CMTime theTime = { inStep * 30.0, 1.0, kCMTimeFlags_Valid, 0 };

    theFrame.origin = CGPointMake(CGRectGetMidX(theBounds) - 180.0, CGRectGetMidY(theBounds) - 120.0);
    theLayer.frame = theFrame;
    theLayer.anchorPointZ = 180.0;
    theLayer.transform = CATransform3DMakeRotation(inStep * M_PI / 2.0, 0.0, 1.0, 0.0);
    theLayer.doubleSided = NO;
    [thePlayer play];
    [thePlayer seekToTime:theTime];
    [thePlayer setVolume:0.0];
    return theLayer;
}

- (CALayer *)makeTitleLayer {
    UIImage *theImage = [UIImage imageNamed:@"title-logo.png"];
    CALayer *theLayer = [CALayer layer];
    CGSize theSize = theImage.size;
    CGRect theFrame = self.view.layer.bounds;
    CABasicAnimation *theAnimation = [CABasicAnimation animation];

    theAnimation.fromValue = @0.01;
    theAnimation.duration = 30.0;
    theFrame.origin = CGPointMake(CGRectGetMidX(theFrame) - theSize.width / 2.0,
                                  CGRectGetMidY(theFrame) - theSize.height / 2.0);
    theFrame.size = theSize;
    theLayer.frame = theFrame;
    theLayer.contents = (id)theImage.CGImage;
    theLayer.zPosition = 200.0;
    [theLayer addAnimation:theAnimation forKey:@"transform.scale"];
    [theLayer addAnimation:theAnimation forKey:@"opacity"];
    return theLayer;
}

- (AVAudioPlayer *)makeAudioPlayer {
    NSError *theError = nil;
    NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"title-music" withExtension:@"mp3"];
    AVAudioPlayer *thePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:theURL error:&theError];

    if(thePlayer == nil) {
        NSLog(@"error: %@", theError);
    }
    else {
        [thePlayer play];
    }
    thePlayer.delegate = self;
    return thePlayer;
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    CATransform3D theTransform = CATransform3DIdentity;
    CALayer *theLayer = self.view.layer;
    CALayer *theRotationLayer = [CATransformLayer layer];
    CABasicAnimation *theAnimation = [CABasicAnimation animation];

    self.audioPlayer = [self makeAudioPlayer];
    theAnimation.toValue = @(M_PI);
    theAnimation.duration = 4.0;
    theAnimation.repeatCount = MAXFLOAT;
    theAnimation.autoreverses = NO;
    theTransform.m34 = 0.0005;
    theLayer.sublayerTransform = theTransform;
    [theLayer addSublayer:theRotationLayer];
    [theLayer addSublayer:[self makeTitleLayer]];
    theRotationLayer.frame = theLayer.bounds;
    for(int i = 0; i < 4; i += 1) {
        CALayer *theSublayer = [self makePlayerLayerWithStep:i];

        [theRotationLayer addSublayer:theSublayer];
    }
    [theRotationLayer addAnimation:theAnimation forKey:@"transform.rotation.y"];
}

- (void)viewDidDisappear:(BOOL)inAnimated {
    [self.audioPlayer stop];
    [self.view.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    self.audioPlayer = nil;
    [super viewDidDisappear:inAnimated];
}

#pragma mark AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)inPlayer successfully:(BOOL)inSuccess {
    [self performSegueWithIdentifier:@"movie-player" sender:self];
}

@end
