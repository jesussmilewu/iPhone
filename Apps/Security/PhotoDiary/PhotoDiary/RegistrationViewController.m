//
//  RegistrationViewController.m
//  PhotoDiary
//
//  Created by Klaus Rodewig on 14.08.12.
//
//

#import "RegistrationViewController.h"

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
        NSLog(@"[+] Password accepted. Writing to Keychain");
        
        NSData *foo = [password dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *keychainDict = [NSMutableDictionary dictionary];
        [keychainDict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        [keychainDict setObject:@"Foobar Service" forKey:(__bridge id)kSecAttrService];
        [keychainDict setObject:@"PhotoDiary" forKey:(__bridge id)kSecAttrLabel];
        [keychainDict setObject:@"FooUser" forKey:(__bridge id)kSecAttrAccount];
        [keychainDict setObject:(__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
        [keychainDict setObject:foo forKey:(__bridge id)kSecValueData];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"passwordSet"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentModalViewController:vc animated:YES];
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
