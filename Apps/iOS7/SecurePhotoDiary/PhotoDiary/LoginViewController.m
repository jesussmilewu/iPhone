//
//  LoginViewController.m
//  SecurePhotoDiary
//
//  Created by Klaus Rodewig on 08.10.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "LoginViewController.h"
#import "SecUtils.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)loginUser:(id)sender;
@property BOOL passwordSet;
@end

@implementation LoginViewController

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
    /*
    self.passwordSet = [[NSUserDefaults standardUserDefaults] boolForKey:@"passwordSet"];
    if(!self.passwordSet){
        NSLog(@"Passwort nicht gesetzt");
        NSLog(@"Starte Registrierung");
        UIStoryboard *storyboard = self.storyboard;
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Registration"];
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
//        [self presentModalViewController:vc animated:YES ];
        [self presentViewController:vc animated:YES completion:NULL];
    }
     */
}

-(void)viewDidAppear:(BOOL)animated
{
    self.passwordSet = [[NSUserDefaults standardUserDefaults] boolForKey:@"passwordSet"];
    if(!self.passwordSet){
        NSLog(@"Passwort nicht gesetzt");
        NSLog(@"Starte Registrierung");
        UIStoryboard *storyboard = self.storyboard;
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Registration"];
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
        //        [self presentModalViewController:vc animated:YES ];
        [self presentViewController:vc animated:YES completion:NULL];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginUser:(id)sender {
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    
    NSString *storedPassword = [SecUtils getUserPwFromKeychain];
    
    NSString *userPassword = [self.password text];
    
    NSString *passwordHash = [SecUtils generateSHA256:userPassword];
    NSLog(@"[+] Password hash: %@", passwordHash);
    NSLog(@"[+] Password: %@", userPassword);
    
    if([passwordHash isEqualToString:storedPassword]){
        UIStoryboard *storyboard = self.storyboard;
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:vc animated:YES completion:nil];
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
