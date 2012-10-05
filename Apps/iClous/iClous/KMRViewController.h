//
//  KMRViewController.h
//  iclous
//
//  Created by Klaus Rodewig on 18.09.12.
//  Copyright (c) 2012 Foobar Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloudDoc.h"

@interface KMRViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *cloudText;
@property (strong) CloudDoc *cloudDoc;

- (IBAction)saveText:(id)sender;


@end
