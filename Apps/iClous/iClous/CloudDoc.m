//
//  CloudCommunication.m
//  iclous
//
//  Created by Klaus Rodewig on 24.09.12.
//  Copyright (c) 2012 Foobar Ltd. All rights reserved.
//

#import "CloudDoc.h"

@implementation CloudDoc

- (id)contentsForType:(NSString *)typeName
                error:(NSError **)outError {
    if (!self.cloudText)
        self.cloudText = @"Bar";
    
    NSData *cloudData = [self.cloudText dataUsingEncoding:NSUTF8StringEncoding];
    return cloudData;
}

- (BOOL)loadFromContents:(id)contents
                  ofType:(NSString *)typeName
                   error:(NSError **)outError {
    if ([contents length] > 0)
        self.cloudText = [[NSString alloc] initWithData:contents encoding:NSUTF8StringEncoding];
    else
        self.cloudText = @"Foo";
    
    return YES;
}

@end
