//
//  iClousViewController.m
//  iClous
//
//  Created by Rodewig Klaus on 24.06.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import "iClousViewController.h"

@implementation iClousViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - F00 (for Clemens)

- (NSString*)getExternalIp
{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    NSString *externalIp = @"192.168.1.1";
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://checkip.dyndns.org/"]
                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:10];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];    

    if(!urlData)
        NSLog(@"no data. no future: %@", error);

    NSString *ipString = [NSString stringWithUTF8String:[urlData bytes]];
    
    NSArray *listItems1 = [ipString componentsSeparatedByString:@": "];
    NSArray *listItems2 = [[listItems1 objectAtIndex:1] componentsSeparatedByString:@"<"];
    NSLog(@"IP: %@", [listItems2 objectAtIndex:0]);
    
    return externalIp;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    [super viewDidLoad];
    deviceInformation *thisDevice = [[deviceInformation alloc] init];
    [thisDevice setIpAddress:[self getExternalIp]];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
//    [imageView release];
    imageView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
