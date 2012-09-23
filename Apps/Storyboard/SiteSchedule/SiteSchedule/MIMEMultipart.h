//
//  Multipart.h
//
//  Created by Clemens Wagner on 19.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MIMEMultipart : NSObject {
    @private
}

@property (nonatomic, readonly) NSStringEncoding encoding;
@property (nonatomic, copy, readonly) NSString *separator;

- (id)init;
- (id)initWithEncoding:(NSStringEncoding)inEncoding;
- (id)initWithEncoding:(NSStringEncoding)inEncoding separator:(NSString *)inSeparator;
- (NSData *)data;
- (void)appendParameter:(NSString *)inValue withName:(NSString *)inName;
- (void)appendData:(NSData *)inData withName:(NSString *)inName contentType:(NSString *)inContentType filename:(NSString *)inFileName;

@end