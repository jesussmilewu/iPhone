//
//  GetURL.m
//  GetURL
//
//  Created by Rodewig Klaus on 14.02.12.
//  Copyright (c) 2012 Cocoaneheads. All rights reserved.
//

#import "GetURL.h"

@implementation GetURL
@synthesize label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)awakeFromNib{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    [label setText:@"Moin!"];
}

- (IBAction)button:(id)sender {
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    NSError *error = nil;
    NSString *myUrl = @"http://www.cocoaneheads.de/ip.php";
    NSString *ip = [NSString stringWithContentsOfURL:[NSURL URLWithString:myUrl] encoding:NSASCIIStringEncoding error:&error];
    if(error != nil)
        NSLog(@"[+] Error: %@", [error localizedDescription]);
    else
        NSLog(@"[+] IP: %@", ip);              
    [label setText:ip];
}

@end
