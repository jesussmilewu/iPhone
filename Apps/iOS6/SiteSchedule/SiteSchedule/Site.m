//
//  Site.m
//  Shop
//
//  Created by Clemens Wagner on 29.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Site.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>

@implementation Site

@dynamic code;
@dynamic name;
@dynamic street;
@dynamic zip;
@dynamic city;
@dynamic countryCode;
@dynamic activities;
@dynamic latitude;
@dynamic longitude;

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.latitude.doubleValue, self.longitude.doubleValue);
}

- (void)setCoordinate:(CLLocationCoordinate2D)inCoordinate {
    self.latitude = [NSNumber numberWithDouble:inCoordinate.latitude];
    self.longitude = [NSNumber numberWithDouble:inCoordinate.longitude];
}

- (NSDictionary *)address {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.zip, kABPersonAddressZIPKey,
            self.city, kABPersonAddressCityKey,
            self.countryCode, kABPersonAddressCountryCodeKey,
            self.street, kABPersonAddressStreetKey,
            nil];
}

- (BOOL)hasCoordinates {
    return self.latitude != nil && self.longitude != nil;
}

@end
