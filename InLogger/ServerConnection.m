//
//  ServerConnection.m
//  InLogger
//
//  Created by Linus Öberg on 28/04/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import "ServerConnection.h"
#import "JSONBuilder.h"
#import "XYZExperiment.h"


@implementation ServerConnection
NSString *token;

+ (int)login:(NSString *)username withPassword:(NSString *)password
{
    NSMutableURLRequest *request = [JSONBuilder getLoginJSON:username withPassword:password];
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:POSTReply options:kNilOptions error:nil];

    token = [json objectForKey:@"token"];
    NSLog(@"req %@", token);
    NSLog(@"Header: %ld", (long)httpResp.statusCode);
  
    return httpResp.statusCode;
}

+ (int)logout
{
    NSMutableURLRequest *request = [JSONBuilder getLogoutJSON:token];
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:POSTReply options:kNilOptions error:nil];
    
  //  token = [json objectForKey:@"token"];
    NSLog(@"req %@", token);
    NSLog(@"Header: %ld", (long)httpResp.statusCode);
    
    return httpResp.statusCode;
}

 
+(NSDictionary*)search:(NSArray*)annotations
{
    //create send request
    NSMutableURLRequest *request = [JSONBuilder getSearchJSON:annotations withToken: token];
    NSURLResponse *response;
    NSError *rr;
    
    //recieve answer
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:POSTReply options:kNilOptions error:nil];
    NSDictionary *json = [arr objectAtIndex:0];
    for (NSString *a in [json allKeys]) {

        NSLog(@"Key : %@ Object: %@", a, [json objectForKey:a]);
    }
    //TODO: Create experiments from data
    
    return nil;
}


@end
