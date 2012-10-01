//
//  KMRAppDelegate.h
//  iclous
//
//  Created by Klaus Rodewig on 18.09.12.
//  Copyright (c) 2012 Foobar Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloudDoc.h"

@class KMRViewController;

@interface KMRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) KMRViewController *viewController;
@property BOOL theCloud;
@property (strong) NSMetadataQuery *query;
@property (strong) CloudDoc *cloudDoc;
@property (strong) NSURL *iCloudPath;

- (void)loadFileFromCloud;

@end
