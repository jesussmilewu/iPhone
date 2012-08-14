//
//  LoginViewController.h
//  PhotoDiary
//
//  Created by Klaus Rodewig on 13.08.12.
//
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
- (IBAction)loginUser:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property BOOL passwordSet;
@property BOOL internalCall;
@end
