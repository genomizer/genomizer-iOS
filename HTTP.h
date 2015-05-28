//
//  HTTP.h
//  Genomizer
//
//  Created by Pål Forsberg on 28/05/15.
//  Copyright (c) 2015 Mattias. All rights reserved.
//
// Handles the NSURLConnectionDelegate. Can handle both HTTPS and HTTP

#import <Foundation/Foundation.h>

@interface HTTP : NSObject<NSURLConnectionDelegate>

-(void)makeRequest:(NSURLRequest *)_request completion:(void(^)(NSData *POSTReply, NSURLResponse *response, NSError *error))comp;
@end
