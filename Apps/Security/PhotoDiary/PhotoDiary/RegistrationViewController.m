//
//  RegistrationViewController.m
//  PhotoDiary
//
//  Created by Klaus Rodewig on 14.08.12.
//
//

#import "RegistrationViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController
@synthesize firstPassword;
@synthesize secondPassword;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setFirstPassword:nil];
    [self setSecondPassword:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)registerUser:(id)sender {
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    NSString *password = [firstPassword text];
    if([password isEqualToString:[secondPassword text]]){
        NSLog(@"[+] Password accepted. Creating hash for secure storage");
        
        // SALZ
        
        NSMutableString *passwordHash = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH];
        unsigned char passwordChars[CC_SHA256_DIGEST_LENGTH];
        CC_SHA256([password UTF8String], [password lengthOfBytesUsingEncoding:NSUTF8StringEncoding], passwordChars);
        for(int i=0; i< CC_SHA256_DIGEST_LENGTH; i++){
            [passwordHash appendString:[NSString stringWithFormat:@"%02x", passwordChars[i]]];
        }
        NSLog(@"[+] Password hash: %@", passwordHash);
        
        NSLog(@"[+] Password accepted. Writing to Keychain");
        
        NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
        [updateDict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        [updateDict setObject:@"Foobar Service" forKey:(__bridge id)kSecAttrService];
        [updateDict setObject:@"PhotoDiary" forKey:(__bridge id)kSecAttrLabel];
        [updateDict setObject:@"FooUser" forKey:(__bridge id)kSecAttrAccount];
        OSStatus status = SecItemDelete((__bridge CFDictionaryRef)updateDict);
        if(status != noErr)
            NSLog(@"[+] Error deleting PW from Keychain");
    
        
        NSMutableDictionary *writeDict = [NSMutableDictionary dictionary];
        [writeDict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        [writeDict setObject:@"Foobar Service" forKey:(__bridge id)kSecAttrService];
        [writeDict setObject:@"PhotoDiary" forKey:(__bridge id)kSecAttrLabel];
        [writeDict setObject:@"FooUser" forKey:(__bridge id)kSecAttrAccount];
        [writeDict setObject:(__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
        [writeDict setObject:[passwordHash dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
        
        status = SecItemAdd((__bridge CFDictionaryRef)writeDict, NULL);
        if(status != noErr){
            NSLog(@"[+] Error writing PW to Keychain");
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"passwordSet"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
            [vc setModalPresentationStyle:UIModalPresentationFullScreen];
            [self presentModalViewController:vc animated:YES];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passwörter stimmen nicht überein!"
                                                        message:@"Bitte erneut versuchen!"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Registration"];
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentModalViewController:vc animated:YES];

    }
}


@end
