//
//  Multipart.m
//
//  Created by Clemens Wagner on 19.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MIMEMultipartBody.h"

@interface MIMEMultipartBody()

@property (nonatomic, readwrite) NSStringEncoding encoding;
@property (nonatomic, copy, readwrite) NSString *charset;
@property (nonatomic, copy, readwrite) NSString *separator;
@property (nonatomic, retain, readwrite) NSMutableData *body;

@end

@implementation MIMEMultipartBody

@synthesize encoding;
@synthesize charset;
@synthesize separator;
@synthesize body;

- (id)init {
    return [self initWithEncoding:NSUTF8StringEncoding];
}

- (id)initWithEncoding:(NSStringEncoding)inEncoding {
    return [self initWithEncoding:inEncoding separator:nil];
}


- (id)initWithEncoding:(NSStringEncoding)inEncoding separator:(NSString *)inSeparator {
    self = [super init];
    if(self) {
        CFStringEncoding theEncoding = CFStringConvertNSStringEncodingToEncoding(self.encoding);
        
        self.encoding = inEncoding;
        self.charset = (id)CFStringConvertEncodingToIANACharSetName(theEncoding);
        self.body = [NSMutableData dataWithCapacity:8192];
        if(inSeparator.length > 0) {
            self.separator = inSeparator;
        }
        else {
            NSUInteger theKey = (NSUInteger) [NSDate timeIntervalSinceReferenceDate] * 19 + (rand() % 123457);
            
            self.separator = [NSString stringWithFormat:@"----MIMEMultipartBody%x", theKey]; 
        }
    }
    return self;
}

- (NSString *)contentType {
    return [NSString stringWithFormat:@"multipart/form-data; boundary=%@", self.separator];
}

- (void)appendString:(NSString *)inValue {
    NSData *theData = [inValue dataUsingEncoding:self.encoding];
    
    [self.body appendData:theData];
}

- (NSData *)data {
    NSMutableData *theBody = self.body;
    NSUInteger theLength = theBody.length;
    NSData *theData;

    [self appendString:[NSString stringWithFormat:@"\n--%@--", self.separator]];
    theData = [theBody copy];
    theBody.length = theLength;
    return theData;
}

- (void)startNewPart {
    if(self.body.length > 0) {
        [self appendString:[NSString stringWithFormat:@"\n--%@", self.separator]];
    }
    else {
        [self appendString:[NSString stringWithFormat:@"--%@", self.separator]];
    }
}

- (void)appendParameterValue:(NSString *)inValue withName:(NSString *)inName {
    [self startNewPart];
    [self appendString:[NSString stringWithFormat:@"\nContent-Disposition: form-data; name=\"%@\"", inName]];
    [self appendString:@"\n\n"];
    [self appendString:inValue];
}

- (void)appendData:(NSData *)inData
          withName:(NSString *)inName
       contentType:(NSString *)inContentType
          filename:(NSString *)inFileName {
    [self startNewPart];
    [self appendString:[NSString stringWithFormat:@"\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"", inName, inFileName]];
    [self appendString:[NSString stringWithFormat:@"\nContent-Type: %@", inContentType]];
    [self appendString:@"\n\n"];
    [self.body appendData:inData];
}

- (NSMutableURLRequest *)mutableRequestWithURL:(NSURL *)inURL timeout:(NSTimeInterval)inTimeout {
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:inURL
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                          timeoutInterval:inTimeout];
    NSData *theBody = self.data;
    
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:self.contentType forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:[NSString stringWithFormat:@"%d", theBody.length]
      forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPBody:theBody];
    return theRequest;
}

@end
