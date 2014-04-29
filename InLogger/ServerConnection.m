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
    NSMutableURLRequest *request = [JSONBuilder getLoginJSON:username withPassword:password toURL:[self getServerURL]];
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
    
    token = [json objectForKey:@"token"];
    NSLog(@"req %@", token);
    NSLog(@"Header: %ld", (long)httpResp.statusCode);
    
    return httpResp.statusCode;
}
+ (int)search
{
    // fill in annotations
    NSString *annotations=@"annotations=";
    NSMutableURLRequest *request = [JSONBuilder getSearchJSON:annotations withToken:token];
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:POSTReply options:kNilOptions error:nil];
    
    //token = [json objectForKey:@"token"];
    NSLog(@"json search %@", json);
    NSLog(@"Header: %ld", (long)httpResp.statusCode);
    
    return httpResp.statusCode;

+(int)search:(NSArray*)annotations
{
    NSMutableURLRequest *request = [JSONBuilder getSearchJSON:annotations toURL:[self getServerURL] withAuthorization: token];
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:POSTReply options:kNilOptions error:nil];
    
    //    NSLog(@"req %@", dict);
    NSLog(@"Header: %ld", (long)httpResp.statusCode);
    for (NSString *b in json){
        NSLog(@"Body: %@", b);
        
    }
    
    return httpResp.statusCode;
}


+ (NSString*) getServerURL
{
    return @"http://genomizer.apiary-mock.com";
}



@end
