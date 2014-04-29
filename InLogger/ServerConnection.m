//
//  ServerConnection.m
//  InLogger
//
//  Created by Linus Öberg on 28/04/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import "ServerConnection.h"
#import "JSONBuilder.h"


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
    NSLog(@"req %@", json);
    NSLog(@"Header: %ld", (long)httpResp.statusCode);
    
    return httpResp.statusCode;
}

 
+(NSDictionary*)search:(NSArray*)annotations
{
    NSMutableURLRequest *request = [JSONBuilder getSearchJSON:annotations withToken: token];
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
    
  //  NSDictionary *res = [NSJSONSerialization JSONObjectWithData:POSTReply options: NSJSONReadingMutableContainers error:nil];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:POSTReply options:kNilOptions error:nil];
    NSDictionary *arrayOfResults = [[NSMutableArray alloc] init];

    NSLog(@"search head: %ld", (long)httpResp.statusCode);
     NSLog(@"search json %@", response);
  //  NSLog(@"search res %@", res);
    
    NSLog(@"search json %@", json);


    return json;
}


@end
