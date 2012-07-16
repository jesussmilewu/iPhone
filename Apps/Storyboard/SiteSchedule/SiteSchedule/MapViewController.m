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

- (IBAction)overview:(UIStoryboardSegue *)inSegue {
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
    if(theSite != nil) {
        [self.geocoder geocodeAddressDictionary:theSite.address
                              completionHandler:^(NSArray *inPlacemarks, NSError *inError) {
                                  if(inError == nil && inPlacemarks.count > 0) {
                                      CLPlacemark *thePlacemark = [inPlacemarks objectAtIndex:0];
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
            UIButton *theLeftButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
            UIButton *theRightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

            theLeftButton.tag = 10;
            theRightButton.tag = 20;
            theView = [[MKPinAnnotationView alloc] initWithAnnotation:inAnnotation reuseIdentifier:@"Site"];
            theView.pinColor = MKPinAnnotationColorRed;
            theView.canShowCallout = YES;
            theView.animatesDrop = YES;
            theView.leftCalloutAccessoryView = theLeftButton;
            theView.rightCalloutAccessoryView = theRightButton;
        }
        else {
            theView.annotation = inAnnotation;
        }
    }
    return theView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)inView calloutAccessoryControlTapped:(UIControl *)inControl {
    Annotation *theAnnotation = inView.annotation;
    Site *theSite = (Site *)[self.managedObjectContext objectWithID:theAnnotation.objectId];
    
    if(inControl.tag == 10) {
        ActivitiesViewController *theController = [self.storyboard instantiateViewControllerWithIdentifier:@"activities"];

        [theController setUnorderedActivities:theSite.activities];
        [self.navigationController pushViewController:theController animated:YES];
    }
    else {
        MKPlacemark *thePlacemark = [[MKPlacemark alloc] initWithCoordinate:theSite.coordinate addressDictionary:theSite.address];
        MKMapItem *theItem = [[MKMapItem alloc] initWithPlacemark:thePlacemark];

        theItem.name = theSite.name;
        [theItem openInMapsWithLaunchOptions:@{
           MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
             MKLaunchOptionsShowsTrafficKey : @YES }];
    }
}

@end
