//
//  ShopSecondViewController.m
//  Shop
//
//  Created by Clemens Wagner on 29.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "MapViewController.h"
#import "ActivitiesViewController.h"
#import "UIViewController+SiteSchedule.h"
#import "Model.h"
#import "Annotation.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readwrite) CLGeocoder *geocoder;
@property (nonatomic, strong, readwrite) NSArray *sites;
@property (nonatomic) MKMapRect mapRect;

- (void)updateAnnotations;

@end

@implementation MapViewController

@synthesize mapView;
@synthesize managedObjectContext;
@synthesize geocoder;
@synthesize sites;
@synthesize mapRect;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.managedObjectContext = [self newManagedObjectContext];
    self.geocoder = [[CLGeocoder alloc] init];
    [self updateAnnotations];
}

- (void)addAnntationForSite:(Site *)inSite {
    Annotation *theAnnotation = [[Annotation alloc] initWithSite:inSite];
    
    [self.mapView addAnnotation:theAnnotation];
}

- (void)updateMapRectWithCoordinate:(CLLocationCoordinate2D)inCoordinate isFirst:(BOOL)inIsFirst {
    MKMapPoint thePoint = MKMapPointForCoordinate(inCoordinate);
    MKMapRect theRect = MKMapRectNull;

    theRect.origin = thePoint;
    self.mapRect = inIsFirst ? theRect : MKMapRectUnion(self.mapRect, theRect);
}

- (void)updateGeocoordinates:(NSUInteger)inIndex {
    NSUInteger theIndex = inIndex;
    Site *theSite = nil;
    
    while(theIndex < self.sites.count) {
        theSite = [self.sites objectAtIndex:theIndex];
        if(theSite.hasCoordinates) {
            [self updateMapRectWithCoordinate:theSite.coordinate isFirst:theIndex == 0];
            [self addAnntationForSite:theSite];
            theIndex++;
            theSite = nil;
        }
        else {
            break;
        }
    }
    if(!self.geocoder.isGeocoding && theSite != nil) {
        [self.geocoder geocodeAddressDictionary:theSite.address
                              completionHandler:^(NSArray *inPlacemarks, NSError *inError) {
                                  if(inError == nil && inPlacemarks.count > 0) {
                                      MKPlacemark *thePlacemark = [inPlacemarks objectAtIndex:0];
                                      CLLocationCoordinate2D theCoordinate = thePlacemark.location.coordinate;
                                      
                                      theSite.coordinate = theCoordinate;
                                      [self updateMapRectWithCoordinate:theCoordinate
                                                                isFirst:inIndex == 0];
                                      [self addAnntationForSite:theSite];
                                  }
                                  else {
                                      NSLog(@"error = %@", inError);
                                  }
                                  [self updateGeocoordinates:theIndex + 1];
                              }];
    }
    if(theIndex >= self.sites.count) {
        [self.mapView setVisibleMapRect:self.mapRect animated:YES];
        [self.managedObjectContext save:NULL];
    }
}

- (void)updateAnnotations {
    NSFetchRequest *theRequest = [[NSFetchRequest alloc] init];
    NSError *theError = nil;
    
    theRequest.entity = [NSEntityDescription entityForName:@"Site"
                                    inManagedObjectContext:self.managedObjectContext];
    self.sites = [self.managedObjectContext executeFetchRequest:theRequest error:&theError];
    if(theError == nil) {
        [self updateGeocoordinates:0];
    }
    else {
        NSLog(@"updateAnnotations: %@", theError);
        self.sites = nil;
    }
}

#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)inMapView viewForAnnotation:(id<MKAnnotation>)inAnnotation {
    MKPinAnnotationView *theView = nil;
    
    if(![inAnnotation isKindOfClass:[MKUserLocation class]]) {
        theView = (MKPinAnnotationView *)[inMapView dequeueReusableAnnotationViewWithIdentifier:@"Site"];
        if(theView == nil) {
            UIButton *theButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

            theView = [[MKPinAnnotationView alloc] initWithAnnotation:inAnnotation reuseIdentifier:@"Site"];
            theView.pinColor = MKPinAnnotationColorGreen;
            theView.canShowCallout = YES;
            theView.animatesDrop = YES;
            theView.rightCalloutAccessoryView = theButton;
        }
        else {
            theView.annotation = inAnnotation;
        }
    }
    return theView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)inView calloutAccessoryControlTapped:(UIControl *)inControl {
    ActivitiesViewController *theController = [self.storyboard instantiateViewControllerWithIdentifier:@"activities"];
    Annotation *theAnnotation = inView.annotation;
    Site *theSite = (Site *)[self.managedObjectContext objectWithID:theAnnotation.objectId];
    
    [theController setUnorderedActivities:theSite.activities];
    [self.navigationController pushViewController:theController animated:YES];
}

@end
