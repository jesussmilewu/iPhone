//
//  SecUtils.m
//  PhotoDiary
//
//  Created by Klaus Rodewig on 14.08.12.
//
//

#import "SecUtils.h"

@interface SecUtils ()

@end

@implementation SecUtils

+(NSString *)generateSHA256:(NSString *)inputString{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    
    NSString *passwordWithSalt = [NSString stringWithFormat:@"%@%@", SALT, inputString];
    NSLog(@"passwordWithSalt: %@", passwordWithSalt);
    
    NSMutableString *passwordHash = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH];
    unsigned char passwordChars[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256([passwordWithSalt UTF8String], [passwordWithSalt lengthOfBytesUsingEncoding:NSUTF8StringEncoding], passwordChars);
    for(int i=0; i< CC_SHA256_DIGEST_LENGTH; i++){
        [passwordHash appendString:[NSString stringWithFormat:@"%02x", passwordChars[i]]];
    }
    return passwordHash;
}

+(BOOL)addKeychainEntry:(NSString *)entry{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    NSMutableDictionary *writeDict = [NSMutableDictionary dictionary];
    [writeDict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [writeDict setObject:KEYCHAIN_SERVICE forKey:(__bridge id)kSecAttrService];
    [writeDict setObject:KEYCHAIN_LABEL forKey:(__bridge id)kSecAttrLabel];
    [writeDict setObject:KEYCHAIN_ACCOUNT forKey:(__bridge id)kSecAttrAccount];
    [writeDict setObject:(__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    [writeDict setObject:[entry dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)writeDict, NULL);
    if(status != noErr){
        NSLog(@"[+] Error writing PW to Keychain");
        return FALSE;
    } else {
        return YES;
    }
}


+(BOOL)deletePreviousKeychainEntry{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
    [updateDict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [updateDict setObject:KEYCHAIN_SERVICE forKey:(__bridge id)kSecAttrService];
    [updateDict setObject:KEYCHAIN_LABEL forKey:(__bridge id)kSecAttrLabel];
    [updateDict setObject:KEYCHAIN_ACCOUNT forKey:(__bridge id)kSecAttrAccount];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)updateDict);
    if(status != noErr){
        NSLog(@"[+] Error deleting PW from Keychain");
        return FALSE;
    } else {
        return YES;
    }
}

@end
