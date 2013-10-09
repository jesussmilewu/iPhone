//
//  RegistrationViewController.m
//  SecurePhotoDiary
//
//  Created by Klaus Rodewig on 08.10.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "RegistrationViewController.h"
#import "SecUtils.h"

@interface RegistrationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstPassword;
@property (weak, nonatomic) IBOutlet UITextField *secondPassword;
- (IBAction)registerUser:(id)sender;

@end

@implementation RegistrationViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerUser:(id)sender {
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    NSString *password = [self.firstPassword text];
    if([password isEqualToString:[self.secondPassword text]]){
        NSLog(@"[+] Password accepted. Creating hash for secure storage");
        
        NSString *passwordHash = [SecUtils generateSHA256:password];
        
        NSLog(@"[+] Password hash: %@", passwordHash);
        
        NSLog(@"[+] Password accepted. Writing to Keychain");
        
        if([SecUtils addKeychainEntry:passwordHash]){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"passwordSet"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIStoryboard *storyboard = self.storyboard;
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
            [vc setModalPresentationStyle:UIModalPresentationFullScreen];
            [self presentViewController:vc animated:YES completion:nil];
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
        [self presentViewController:vc animated:YES completion:nil];
    }
}

@end
