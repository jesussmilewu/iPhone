//
//  MemoryViewController.h
//  Games
//
//  Created by Clemens Wagner on 23.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Memory.h"
#import "NumberView.h"

@interface MemoryViewController : UIViewController {
    @private
}

@property (nonatomic, retain, readonly) Memory *memory;
@property (nonatomic, retain) IBOutlet UIView *memoryView;
@property (nonatomic, retain) IBOutlet NumberView *scoreView;

- (IBAction)clear;
- (IBAction)help;

@end
