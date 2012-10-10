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

NSString * const Salt = @"salz1234salz";

const NSUInteger kPBKDFRounds = 10000;

@implementation CryptoUtils

+(NSString *)encryptData:(NSData *)clearText
                     key:(NSString *)passPhrase {
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    
    NSMutableData *iv = [NSMutableData dataWithLength:kCCBlockSizeAES128];
    
    SecRandomCopyBytes(kSecRandomDefault, kCCBlockSizeAES128, iv.mutableBytes);
    
    NSString *passwordWithSalt = [NSString stringWithFormat:@"%@%@", Salt, passPhrase];

    NSData *thePassword = [passwordWithSalt dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData *cipherData = [NSMutableData dataWithLength:clearText.length + kCCBlockSizeAES128];

    size_t ciperLength;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [thePassword bytes],
                                          [thePassword length],
                                          [iv bytes],
                                          [clearText bytes],
                                          [clearText length],
                                          [cipherData mutableBytes],
                                          [cipherData length],
                                          &ciperLength);
    

              
    if(cryptStatus){
        NSLog(@"Something terrible happened!");
    } else {
        NSLog(@"Ciphertext length: %i", [cipherData length]);
    }
    
    // Todo: base64-encryption des Ciphertexte
    
    return [[NSString alloc] initWithData:cipherData encoding:NSASCIIStringEncoding];
}

-(NSData *)createEncryptionKey:(NSString *)key{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    
    
}

@end
