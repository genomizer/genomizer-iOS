//
//  HTTP.m
//  Genomizer
//
//  Created by Pål Forsberg on 28/05/15.
//  Copyright (c) 2015 Mattias. All rights reserved.
//

#import "HTTP.h"

#define kRealServerURL @"130.239.192.110"
@implementation HTTP{
    NSData *responseData;
    NSURLResponse *response;
    NSError *responseError;
    NSURLRequest *request;
    void (^completion)(NSData *POSTReply, NSURLResponse *response, NSError *error);
}


//Makes request and calls the completion block when finished.
//Should be able to handle HTTP as well ass HTTPS
-(void)makeRequest:(NSURLRequest *)_request completion:(void(^)(NSData *POSTReply, NSURLResponse *response, NSError *error))comp{
    completion = comp;
    request = _request;
    [NSURLConnection connectionWithRequest:_request delegate:self];
}

#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)_response{
    NSLog(@"response: %@", response);
    response = _response;
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSString *datastring = [[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy];
    NSLog(@"response data: %@", datastring);
    if(responseData == nil){
    responseData = data;
    } else {
        NSMutableData *md = responseData.mutableCopy;
        [md appendData:data];
        responseData = md.copy;
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"error! %@", error);
    responseError = error;
    completion(nil, nil, error);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"finished!");
    completion(responseData, response, responseError);
}

//HTTPS code.
-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURL* baseURL = request.URL;
        if ([challenge.protectionSpace.host isEqualToString:baseURL.host] || [challenge.protectionSpace.host isEqualToString:kRealServerURL]) {
            NSLog(@"trusting connection to host %@", challenge.protectionSpace.host);
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        } else
            NSLog(@"Not trusting connection to host %@", challenge.protectionSpace.host);
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}
@end
