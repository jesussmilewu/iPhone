//
//  LoginViewController.m
//  PhotoDiary
//
//  Created by Klaus Rodewig on 13.08.12.
//
//

#import "LoginViewController.h"
#import <CommonCrypto/CommonDigest.h>


@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize password = _password;
@synthesize passwordSet;
@synthesize internalCall;

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

-(void)viewDidAppear:(BOOL)animated{
    passwordSet = [[NSUserDefaults standardUserDefaults] boolForKey:@"passwordSet"];
    if(passwordSet){
        NSLog(@"Passwort gesetzt");
        NSLog(@"Starte Login");
        internalCall = YES;
    } else {
        NSLog(@"Passwort nicht gesetzt");
        NSLog(@"Starte Registrierung");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Registration"];
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentModalViewController:vc animated:YES];
    }
}

- (void)viewDidUnload
{
    [self setPassword:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)checkCredentials:(NSString *)name pass:(NSString *)hash
{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    
    return YES;
}

- (IBAction)loginUser:(id)sender {
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    
    NSArray *keys = [NSArray arrayWithObjects:(__bridge NSString *)kSecClass, kSecAttrAccount, kSecAttrService, kSecReturnData, nil];
    NSArray *objects = [NSArray arrayWithObjects:(__bridge NSString *)kSecClassGenericPassword, @"FooUser", @"Foobar Service", kCFBooleanTrue, nil];
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    
    CFDataRef pw = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef*)&pw);

    if(status != noErr){
        NSLog(@"[+] Error reading PW from Keychain");
    }
    
    NSData *result = (__bridge_transfer NSData*)pw;
    NSString *storedPassword = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    NSLog(@"[+] PW: %@", storedPassword);
    
    NSString *userPassword = [_password text];
    
    NSMutableString *passwordHash = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH];
    unsigned char passwordChars[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256([userPassword UTF8String], [userPassword lengthOfBytesUsingEncoding:NSUTF8StringEncoding], passwordChars);
    for(int i=0; i< CC_SHA256_DIGEST_LENGTH; i++){
        [passwordHash appendString:[NSString stringWithFormat:@"%02x", passwordChars[i]]];
    }
    NSLog(@"[+] Password hash: %@", passwordHash);
//    NSLog(@"[+] Password: %@", userPassword);

    if([passwordHash isEqualToString:storedPassword]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentModalViewController:vc animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Anmeldung fehlgeschlagen"
                                                        message:@"Bitte erneut versuchen!"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


@end
