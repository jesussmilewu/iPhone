//
//  NSDictionary+Extensions.h
//
//  Created by Clemens Wagner on 20.11.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(Extensions)

+(id)dictionaryWithHeaderFieldsForURL:(NSURL *)inURL;

- (NSDate *)lastModified;
- (NSString *)contentType;
- (size_t)contentLength;

@end