//
//  deviceInformation.m
//  iClous
//
//  Created by Rodewig Klaus on 24.06.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import "deviceInformation.h"

@implementation deviceInformation

@synthesize ipAddress, udid, name, systemName, systemVersion;

- (id)init
{
    self = [super init];
    if (self) {
        UIDevice *device = [UIDevice currentDevice];
        NSLog(@"udid: %@", [device uniqueIdentifier]);
    }
    
    return self;
}

@end
