//
//  Automobil.h
//  First Steps
//
//  Created by Klaus M. Rodewig on 17.01.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fahrzeug.h"

@interface Automobil : Fahrzeug {
@private
    NSDate  *hauptUntersuchung;
    NSNumber *anzahlTueren;
    NSNumber *ps;
}
-(NSString*)getDetails;
#pragma mark Setter
-(void)setHauptUntersuchung:(NSDate*)sHu;
-(void)setAnzahlTueren:(NSNumber*)sTueren;
-(void)setPs:(NSNumber*)sPs;
#pragma mark Getter
-(NSDate*)hauptUntersuchung;
-(NSNumber*)anzahlTueren;
-(NSNumber*)ps;

@end
