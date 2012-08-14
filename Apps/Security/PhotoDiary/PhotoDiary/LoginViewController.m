//
//  LoginViewController.m
//  PhotoDiary
//
//  Created by Klaus Rodewig on 13.08.12.
//
//

#import "LoginViewController.h"

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
        [self loginUser:self];
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

    
    NSMutableDictionary *keychainDict = [[NSMutableDictionary alloc] init];
    [keychainDict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [keychainDict setObject:@"Foobar Service" forKey:(__bridge id)kSecAttrService];
    [keychainDict setObject:@"FooUser" forKey:(__bridge id)kSecAttrAccount];
    NSData *encodedPassword = [ ####
    /*
    
    NSString *password = [_password text];
    
    NSLog(@"[+] Password: %@", password);
    
    if([password length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password fehlt"
                                                        message:@"Bitte Password eingeben!"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
     
    
    if(isAuthenticated){
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
     
     */
}


@end
