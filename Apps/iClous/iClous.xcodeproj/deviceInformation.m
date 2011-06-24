//
//  deviceInformation.m
//  iClous
//
//  Created by Rodewig Klaus on 24.06.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import "deviceInformation.h"

@implementation deviceInformation

@synthesize ipAddress, udid, name, systemName, systemVersion, model;

#pragma mark Initz

- (id)init
{
    self = [super init];
    if (self) {
    }   
    return self;
}

-(id)initWithIp:(NSString *)theIp
{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    self = [super init];
    if (self != nil){
        self.ipAddress = theIp;
        UIDevice *device = [UIDevice currentDevice];
        self.udid = [device uniqueIdentifier];
        self.name = [device name];
        self.systemName = [device systemName];
        self.systemVersion = [device systemVersion];
        self.model = [device model];

    }
    return self;
}

@end
