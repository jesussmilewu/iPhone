//
//  BreakOutViewController.m
//  BreakOut
//
//  Created by Clemens Wagner on 11.01.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

#import "BreakOutViewController.h"
#import "BreakOutScene.h"

@implementation BreakOutViewController

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    SKView *theView = (SKView *)self.view;
    SKScene *theScene = [BreakOutScene sceneWithSize:theView.bounds.size];

    theScene.scaleMode = SKSceneScaleModeAspectFill;
    [theView presentScene:theScene];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
