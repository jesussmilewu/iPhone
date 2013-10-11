//
//  CryptoUtils.h
//  iclous
//
//  Created by Klaus Rodewig on 10.10.12.
//  Copyright (c) 2012 Foobar Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CryptoUtils : NSObject

-(NSData *)encryptData:(NSData *)clearText;
-(id)initWithPassword:(NSString *)thePassword;

@property (retain) NSData *salt;
@property (retain) NSData *iv;
@property (retain) NSString *password;
@property (retain) NSData *cryptKey;

@end
