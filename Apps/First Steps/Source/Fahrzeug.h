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

-(id)initWithData:(NSNumber*)lPreis 
  geschwindigkeit:(int)lGeschwindigkeit 
             name:(NSString*)lName
          baujahr:(NSDate*)lBaujahr;

-(NSString*)getId;

#pragma mark Setter
-(void)setPreis:(NSNumber*)sPreis;
-(void)setGeschwindigkeit:(int)sGeschwindigkeit;
-(void)setName:(NSString*)sName;
-(void)setBaujahr:(NSDate*)sBaujahr;

#pragma mark Getter
-(NSNumber*)preis;
-(int)geschwindigkeit;
-(NSString*)name;
-(NSDate*)baujahr;
@end
