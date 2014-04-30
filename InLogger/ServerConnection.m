//
//  ServerConnection.m
//  InLogger
//
//  Created by Linus Öberg on 28/04/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import "ServerConnection.h"
#import "JSONBuilder.h"
#import "XYZExperimentParser.h"


@implementation ServerConnection
NSString *token;

+ (int)login:(NSString *)username withPassword:(NSString *)password error:(NSError**) error
{
    NSError *httpError;
    NSError *jsonParseError;

    NSMutableURLRequest *request = [JSONBuilder getLoginJSON:username withPassword:password];
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&httpError];

    if (httpError == nil)
    {
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        NSDictionary *json = [self parseJSONToDictionary:POSTReply error:&jsonParseError];
        
        if(jsonParseError == nil){
            token = [json objectForKey:@"token"];
            NSLog(@"login token %@", token);
            NSLog(@"Header: %ld", (long)httpResp.statusCode);
            
            if(httpResp.statusCode == 401){
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:@"Incorrect Username/Password" forKey:NSLocalizedDescriptionKey];
                *error = [NSError errorWithDomain:@"Login" code:0 userInfo:dict];
            }
            return httpResp.statusCode;
        } else{
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@"Server sent incorrectly formatted data, talk to admin" forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:@"Servererror" code:2 userInfo:dict];
            return -1;
        }
    }
    else
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"Could not connect to server" forKey:NSLocalizedDescriptionKey];
        [dict setObject:httpError forKey:NSUnderlyingErrorKey];
        *error = [NSError errorWithDomain:@"Connection" code:1 userInfo:dict];
        return -1;
    }
}

+ (int)logout:(NSError**)error;
{
    NSMutableURLRequest *request = [JSONBuilder getLogoutJSON:token];
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;

    NSLog(@"logout token %@", token);
    NSLog(@"Header: %ld", (long)httpResp.statusCode);
   
    
    return httpResp.statusCode;
}

 
+(NSDictionary*)search:(NSArray*)annotations error:(NSError**) searchError
{
    NSError *error;
   
    //create send request
    NSMutableURLRequest *request = [JSONBuilder getSearchJSON:annotations withToken: token];
    NSURLResponse *response;
    
    //recieve answer
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:POSTReply options:kNilOptions error:&error];
    NSDictionary *json = [arr objectAtIndex:0];
    for (NSString *a in [json allKeys]) {

        NSLog(@"Key : %@ Object: %@", a, [json objectForKey:a]);
    }
    //TODO: Create experiments from data
    
    if(httpResp.statusCode == 200){
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:POSTReply options: NSJSONReadingMutableContainers error:nil];
   
        NSMutableArray * experiments = [[NSMutableArray alloc] init];
        [experiments addObject:[XYZExperimentParser expParser:json]];
        
        return experiments;
    }
    return nil;
}

+(NSDictionary*)parseJSONToDictionary:(NSData*)POSTReply error:(NSError**)error
{
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:POSTReply options:kNilOptions error:error];
    
    if([*error localizedDescription] != nil)
    {
        NSLog(@"parsing json %@",[*error localizedDescription]);
        [NSException raise:@"Error parsing JSON" format:@"Error parsing JSON"];
    }
    return json;
}

@end
