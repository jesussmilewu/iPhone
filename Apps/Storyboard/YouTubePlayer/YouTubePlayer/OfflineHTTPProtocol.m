//
//  HTTPProtocol.m
//  YouTubePlayer
//
//  Created by Clemens Wagner on 11.05.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "OfflineHTTPProtocol.h"
#import "OfflineCache.h"

static NSString * const kHTTPProtocolUseDefault = @"X-HTTPProtocol-Use-Default";

@interface OfflineHTTPProtocol()<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, weak) NSURLConnection *connection;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;

@end


@implementation OfflineHTTPProtocol

- (id)initWithRequest:(NSURLRequest *)inRequest
       cachedResponse:(NSCachedURLResponse *)inResponse
               client:(id<NSURLProtocolClient>)inClient {
    NSMutableURLRequest *theRequest = [inRequest mutableCopy];

    [theRequest setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    [theRequest setValue:@"1" forHTTPHeaderField:kHTTPProtocolUseDefault];
    return [super initWithRequest:theRequest cachedResponse:inResponse client:inClient];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)inRequest {
    NSURL *theURL = inRequest.URL;

    return [theURL.scheme hasPrefix:@"http"] && [inRequest valueForHTTPHeaderField:kHTTPProtocolUseDefault] == nil;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)inRequest {
    return inRequest;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)inLeft toRequest:(NSURLRequest *)inRight {
    BOOL theResult = [super requestIsCacheEquivalent:inLeft toRequest:inRight];
    
    return theResult;
}

- (void)startLoading {
    OfflineCache *theCache = [OfflineCache sharedResponseCache];
    NSCachedURLResponse *theResponse = [theCache cachedResponseForRequest:self.request];

    if(theResponse == nil) {
        self.connection = [NSURLConnection connectionWithRequest:self.request delegate:self];
    }
    else {
        [self.client URLProtocol:self didReceiveResponse:theResponse.response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [self.client URLProtocol:self didLoadData:theResponse.data];
        [self.client URLProtocolDidFinishLoading:self];
    }
}

- (void)stopLoading {
    [self.connection cancel];
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)inConnection didReceiveResponse:(NSURLResponse *)inResponse {
    long long theCapacity = inResponse.expectedContentLength;
    
    self.response = inResponse;
    if(theCapacity < 8192) {
        theCapacity = 8192;
    }
    self.data = [NSMutableData dataWithCapacity:theCapacity];
    [self.client URLProtocol:self didReceiveResponse:inResponse cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)inConnection didFailWithError:(NSError *)inError {
    self.response = nil;
    self.data = nil;
    [self.client URLProtocol:self didFailWithError:inError];
}

- (void)connection:(NSURLConnection *)inConnection didReceiveData:(NSData *)inData {
    [self.data appendData:inData];
    [self.client URLProtocol:self didLoadData:inData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)inConnection {
    OfflineCache *theCache = [OfflineCache sharedResponseCache];
    NSCachedURLResponse *theResponse = [[NSCachedURLResponse alloc] initWithResponse:self.response data:self.data];

    [theCache storeCachedResponse:theResponse forRequest:self.request];
    [self.client URLProtocolDidFinishLoading:self];
}

@end
