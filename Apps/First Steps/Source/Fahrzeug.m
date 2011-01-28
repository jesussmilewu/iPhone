//
//  Fahrzeug.m
//  First Steps
//
//  Created by Klaus M. Rodewig on 05.01.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import "Fahrzeug.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Fahrzeug

-(id)initWithData:(NSNumber*)initPreis 
  geschwindigkeit:(int)initGeschwindigkeit 
             name:(NSString*)initName
          baujahr:(NSDate*)initBaujahr{
    DLOG(@"[+] %@", NSStringFromSelector(_cmd));
    if (![super init]){
        return nil;
    }
    preis = initPreis;
    geschwindigkeit = initGeschwindigkeit;
    name = initName;
    baujahr = initBaujahr;
    
    [preis retain];
    [name retain];
    [baujahr retain];
    
    return self;
}

-(NSString*)getId {
    DLOG(@"[+] %@", NSStringFromSelector(_cmd));
    NSString *fzID = [[NSString alloc] initWithFormat:@"%@%0.2f%d%@", [self name], [[self preis] floatValue], [self geschwindigkeit], [self baujahr]];
     
    unsigned char hashedChars[CC_SHA256_DIGEST_LENGTH];

    CC_SHA256([fzID UTF8String],
              [fzID lengthOfBytesUsingEncoding:NSUTF8StringEncoding], 
              hashedChars);

    NSMutableString *hashedString;
    hashedString = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH];
    
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; ++i) {
        [hashedString appendString:[NSString stringWithFormat:@"%02x", hashedChars[i]]];
    }
    
    DLOG(@"[+] ID: %@", hashedString);

    [fzID release];
    
    return hashedString;
}


- (id)init {
    DLOG(@"[+] %@", NSStringFromSelector(_cmd));
    return [self initWithData:[NSNumber numberWithFloat:0] 
              geschwindigkeit:0
                         name:@"NULL" 
                      baujahr:[NSDate dateWithString:@"1900-01-01 00:00:00 +0100"]];
}

- (void)dealloc {
    DLOG(@"[+] %@", NSStringFromSelector(_cmd));
    
    preis = nil;
    geschwindigkeit = 0;
    name = nil;
    baujahr = nil;
    
    [preis release];
    [name release];
    [baujahr release];
    
    [super dealloc];
}

#pragma mark Setter

-(void)setPreis:(NSNumber*)sPreis{
    DLOG(@"[+] %@", NSStringFromSelector(_cmd));
    [sPreis retain];
    [preis release];
    preis = sPreis; 
}

-(void)setGeschwindigkeit:(int)sGeschwindigkeit{
    DLOG(@"[+] %@", NSStringFromSelector(_cmd));
    geschwindigkeit = sGeschwindigkeit;
}

-(void)setName:(NSString*)sName{
    DLOG(@"[+] %@", NSStringFromSelector(_cmd));
    [sName retain];
    [name release];
    name = sName;
}

-(void)setBaujahr:(NSDate*)sBaujahr{
    DLOG(@"[+] %@", NSStringFromSelector(_cmd));
    [sBaujahr retain];
    [baujahr release];
    baujahr = sBaujahr;
}

#pragma mark Getter

-(NSNumber*)preis{
    DLOG(@"[+] %@", NSStringFromSelector(_cmd));
    return preis;
}

-(int)geschwindigkeit{
    DLOG(@"[+] %@", NSStringFromSelector(_cmd));
    return geschwindigkeit;
}

-(NSString*)name{
    DLOG(@"[+] %@", NSStringFromSelector(_cmd));
    return name;
}

-(NSDate*)baujahr{
    DLOG(@"[+] %@", NSStringFromSelector(_cmd));
    return baujahr;
}

@end
