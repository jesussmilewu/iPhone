//
//  AppDelegate.m
//  Elementary
//
//  Created by Rodewig Klaus on 20.07.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Beispielcode für Klassen-Beispiele in Kapitel 2 kommt hier hin
    
    NSString *foo = @"bar";
    NSLog(@"Adresse von foo: %p", foo);
    NSLog(@"length: %u", [foo length]);
    NSLog(@"char 2: %C", [foo characterAtIndex:2]);

    NSString *lorem = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit.";
    NSLog(@"range: %@", NSStringFromRange([lorem rangeOfString:@"ipsum"]));
    
    NSString *bar = @"bar";
    NSLog(@"Adresse von bar: %p", bar);
    BOOL cmpRes = [foo isEqualToString:bar];
    if(cmpRes)
        NSLog(@"Strings sind gleich");
    else {
        NSLog(@"Strings sind ungleich");
    }

    NSString *foobar = [NSString stringWithFormat:@"%i is %i is %i", 0,0,0];
    NSLog(@"foobar: %@", foobar);
    
    NSMutableString *loremIpsum = [NSMutableString stringWithFormat:@"Aller guten Dinge sind %i", 3];
    NSLog(@"loremIpsum: %@", loremIpsum);
    [loremIpsum appendString:@"."];
    NSLog(@"loremIpsum: %@", loremIpsum);
    [loremIpsum insertString:@"hier " atIndex:18];
    NSLog(@"loremIpsum: %@", loremIpsum);
    NSRange range = {6, 5};
    [loremIpsum replaceCharactersInRange:range withString:@"schlechten"];
    NSLog(@"loremIpsum: %@", loremIpsum);
    
    
    NSError *error = nil;
    NSString *hosts = [[NSString alloc] initWithContentsOfFile:@"/etc/hosts" encoding:NSUTF8StringEncoding error:&error];
    if(error != nil)
        NSLog(@"[+] Error: %@", [error localizedDescription]);
    else {
        NSLog(@"hosts: %@", hosts);
        NSLog(@"hosts length: %u", [hosts length]);
    }
    
    NSNumber *illiuminatus = [NSNumber numberWithInt:23];
    NSNumber *douglas = [NSNumber numberWithFloat:42];
    NSLog(@"illuminatus: %i", [illiuminatus intValue]);
    NSLog(@"douglas: %.2f", [douglas floatValue]);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d.MM.YYYY HH:mm:ss"];
    NSDate *jetzt = [NSDate date];
    NSLog(@"jetzt: %@", [formatter stringFromDate:jetzt]);
    
    NSString *eins = @"1";
    NSNumber *zwei = [NSNumber numberWithInt:2];
    NSDate *heute = [NSDate date];
    NSArray *zeug = [NSArray arrayWithObjects:eins, zwei, heute, nil];
    NSLog(@"Länge von zeug: %i", [zeug count]);
    for (id obj in zeug) {
        NSLog(@"zeug-Element: %@", [obj description]);
    }
    NSLog(@"zeug #1: %@", [[zeug objectAtIndex:1] description]);
    
    NSString *picasso = @"Pictures/guernica.tiff";
    NSString *dali = @"Pictures/sommeil.tiff";
    NSString *vanGogh = @"Pictures/whiteHouseAtNight.tiff";
    NSDictionary *images = [NSDictionary dictionaryWithObjectsAndKeys:picasso, @"Lobby", 
                             dali, @"Restaurant", vanGogh, @"Bar", nil];
    
    NSLog(@"Bild in der Bar: %@", [images valueForKey:@"Bar"]);
    
    for (id key in images) {
        NSLog(@"key: %@ value: %@", key, [images objectForKey:key]);
    }
    
    NSSet *menge = [NSSet setWithObjects:picasso, dali, vanGogh, picasso, picasso, picasso, nil];
    NSLog(@"irgend ein Objekt aus Menge: %@", [menge anyObject]);
    NSLog(@"Objekte in Menge: %i", [menge count]);
    
    for (id obj in menge)
        NSLog(@"obj in menge: %@", [obj description]);
    
    // hier geht der Apple-Code weiter …
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
