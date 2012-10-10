//
//  CryptoUtils.m
//  iclous
//
//  Created by Klaus Rodewig on 10.10.12.
//  Copyright (c) 2012 Foobar Ltd. All rights reserved.
//

#import "CryptoUtils.h"
#import <CommonCrypto/CommonKeyDerivation.h>
#import <CommonCrypto/CommonCryptor.h>

NSString * const Salt = @"salzsalz";
const NSUInteger kPBKDFSaltSize = 8;
const NSUInteger kPBKDFRounds = 10000;

@implementation CryptoUtils

+(NSString *)encryptData:(NSData *)clearText
               key:(NSString *)passPhrase {
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    
    NSMutableData *randomData = [NSMutableData dataWithLength:kCCBlockSizeAES128];
    SecRandomCopyBytes(kSecRandomDefault, kCCBlockSizeAES128, randomData.mutableBytes);
    
    NSString *passwordWithSalt = [NSString stringWithFormat:@"%@%@", Salt, passPhrase];
    NSData *thePassword = [passwordWithSalt dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *cipherData = [NSMutableData dataWithLength:clearText.length + kCCBlockSizeAES128];
    size_t ciperLength;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, // operation
                                          kCCAlgorithmAES128, // Algorithm
                                          kCCOptionPKCS7Padding, // options
                                          thePassword.bytes, // key
                                          thePassword.length, // keylength
                                          [randomData bytes],// iv
                                          clearText.bytes, // dataIn
                                          clearText.length, // dataInLength,
                                          cipherData.mutableBytes, // dataOut
                                          cipherData.length, // dataOutAvailable
                                          &ciperLength); // dataOutMoved
    

              
    if(cryptStatus){
        NSLog(@"Something terrible happened!");
    } else {
        NSLog(@"Ciphertext length: %i", [cipherData length]);
        NSLog(@"Ciphertext: %@", cipherData);
    }
    
    return [[NSString alloc] initWithData:cipherData encoding:NSASCIIStringEncoding];
}


@end
