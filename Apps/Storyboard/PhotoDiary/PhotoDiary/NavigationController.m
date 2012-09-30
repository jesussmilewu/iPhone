//
//  NavigationController.m
//  PhotoDiary
//
//  Created by Clemens Wagner on 29.09.12.
//
//

#import "NavigationController.h"

@implementation NavigationController

-(NSUInteger) supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

@end
