//
//  Multipart.m
//
//  Created by Clemens Wagner on 19.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MIMEMultipart.h"

static const char * kEncodingsNames[] = {
    NULL, "ASCII", "NEXTSTEP", "EUC", "UTF-8", "ISO-8859-1", NULL, NULL,
    NULL, "ISO-8859-2", "Unicode", "CP1251", "CP1252", "CP1253", "CP1254", "CP1255",
    "CP1250", NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
    NULL
};

static const char *NSStringEncodingGetName(NSStringEncoding inEncoding) {
    return inEncoding < 32 ? kEncodingsNames[inEncoding] : NULL;
}

@interface MIMEMultipart()

@property (nonatomic, readwrite) NSStringEncoding encoding;
@property (nonatomic, copy, readwrite) NSString *separator;
@property (nonatomic, retain, readwrite) NSMutableData *mutableData;

@end

@implementation MIMEMultipart

@synthesize encoding;
@synthesize separator;
@synthesize mutableData;

- (id)init {
    return [self initWithEncoding:NSUTF8StringEncoding];
}

- (id)initWithEncoding:(NSStringEncoding)inEncoding {
    return [self initWithEncoding:inEncoding separator:nil];
}


- (id)initWithEncoding:(NSStringEncoding)inEncoding separator:(NSString *)inSeparator {
    self = [super init];
    if(self == nil || NSStringEncodingGetName(inEncoding) == NULL) {
        self = nil;
    }
    else {
        self.encoding = inEncoding;
        self.mutableData = [NSMutableData dataWithCapacity:8192];
        if(inSeparator.length > 0) {
            self.separator = inSeparator;
        }
        else {
            NSUInteger theKey = (NSUInteger) [NSDate timeIntervalSinceReferenceDate] * 19 + (rand() % 123457);
            
            self.separator = [NSString stringWithFormat:@"------SiteSchedule%x", theKey]; 
                        
        }
    }
    return self;
}

- (void)appendString:(NSString *)inValue {
    NSUInteger theLength = [inValue lengthOfBytesUsingEncoding:self.encoding];
    
    [self.mutableData appendBytes:[inValue cStringUsingEncoding:self.encoding] length:theLength];
}

- (NSData *)data {
    NSMutableData *theMutableData = self.mutableData;
    NSUInteger theLength = theMutableData.length;
    NSData *theData;

    [self appendString:[NSString stringWithFormat:@"\n\r%@", self.separator]];
    theData = [theMutableData copy];
    theMutableData.length = theLength;
    return theData;
}

- (void)appendParameter:(NSString *)inValue withName:(NSString *)inName {
    [self appendString:[NSString stringWithFormat:@"\n\r%@", self.separator]];
    [self appendString:[NSString stringWithFormat:@"\n\rContent-Disposition: form-data; name=\"%@\"", inName]];
    [self appendString:@"\n\r\n\r"];
    [self appendString:inValue];
}

- (void)appendData:(NSData *)inData withName:(NSString *)inName contentType:(NSString *)inContentType filename:(NSString *)inFileName {
    [self appendString:[NSString stringWithFormat:@"\n\r%@", self.separator]];
    [self appendString:[NSString stringWithFormat:@"\n\rContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"", inName, inFileName]];
    [self appendString:[NSString stringWithFormat:@"\n\rContent-Type: %@", self.separator]];
    [self appendString:@"\n\r\n\r"];
    [self.mutableData appendData:inData];
}


@end
