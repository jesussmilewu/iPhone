//
//  CryptoUtils.h
//  iclous
//
//  Created by Klaus Rodewig on 10.10.12.
//  Copyright (c) 2012 Foobar Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CryptoUtils : NSObject

+(NSString *)encryptData:(NSData *)clearText
               key:(NSString *)passPhrase;
@end
