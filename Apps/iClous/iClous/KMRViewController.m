//
//  KMRViewController.m
//  iclous
//
//  Created by Klaus Rodewig on 18.09.12.
//  Copyright (c) 2012 Foobar Ltd. All rights reserved.
//

#import "KMRViewController.h"

@interface KMRViewController ()

@end

@implementation KMRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataReloaded:) name:@"docModified" object:nil];
}

-(void)dataReloaded:(NSNotification *)theNotification {
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    self.cloudDoc = theNotification.object;
    self.cloudText.text = self.cloudDoc.cloudText;
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    [super viewWillAppear:animated];
    self.cloudText.text = self.cloudDoc.cloudText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setCloudText:nil];
    [super viewDidUnload];
}

- (IBAction)saveText:(id)sender {
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    self.cloudDoc.cloudText = self.cloudText.text;
    [self.cloudDoc updateChangeCount:UIDocumentChangeDone];
}
@end
