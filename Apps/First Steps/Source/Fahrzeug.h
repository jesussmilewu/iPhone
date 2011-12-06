//
//  Fahrzeug.h
//  First Steps
//
//  Created by Klaus M. Rodewig on 05.01.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Fahrzeug : NSObject {
@private
    NSNumber    *preis;
    int         geschwindigkeit;
    NSString    *name;
    NSDate      *baujahr;
}

-(id)initWithPreis:(NSNumber*)inPreis 
   geschwindigkeit:(int)inGeschwindigkeit 
              name:(NSString*)inName
           baujahr:(NSDate*)inBaujahr;

-(NSString*)getId;

#pragma mark Getter

-(NSNumber*)preis;
-(int)geschwindigkeit;
-(NSString*)name;
-(NSDate*)baujahr;

#pragma mark Setter

-(void)setPreis:(NSNumber*)inPreis;
-(void)setGeschwindigkeit:(int)inGeschwindigkeit;
-(void)setName:(NSString*)inName;
-(void)setBaujahr:(NSDate*)inBaujahr;

@end
