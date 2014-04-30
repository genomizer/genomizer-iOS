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
    NSError *internalError;


    NSMutableURLRequest *request = [JSONBuilder getLoginJSON:username withPassword:password];
    NSHTTPURLResponse *httpResp;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResp error:&internalError];

    if (internalError == nil)
    {
        NSDictionary *json = [self parseJSONToDictionary:POSTReply error:&internalError];
        
        if(internalError == nil){
            token = [json objectForKey:@"token"];
            NSLog(@"login token %@", token);
            NSLog(@"Header: %ld", (long)httpResp.statusCode);
            
            if(httpResp.statusCode == 401){
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:@"Incorrect Username/Password" forKey:NSLocalizedDescriptionKey];
                *error = [NSError errorWithDomain:@"Login" code:0 userInfo:dict];
            }
        } else{
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@"Server sent incorrectly formatted data, talk to admin" forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:@"Servererror" code:2 userInfo:dict];
        }
    }
    else
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"Could not connect to server" forKey:NSLocalizedDescriptionKey];
        [dict setObject:internalError forKey:NSUnderlyingErrorKey];
        *error = [NSError errorWithDomain:@"Connection" code:1 userInfo:dict];
    }
    return -1;
}

+ (int)logout:(NSError**)error;
{
    NSMutableURLRequest *request = [JSONBuilder getLogoutJSON:token];
    
    NSHTTPURLResponse *httpResp;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResp error:error];

    NSLog(@"logout token %@", token);
    NSLog(@"Header: %ld", (long)httpResp.statusCode);
   
    
    return httpResp.statusCode;
}

 
+(NSMutableArray*)search:(NSArray*)annotations error:(NSError**) error
{
    NSError *internalError;
   
    NSMutableURLRequest *request = [JSONBuilder getSearchJSON:annotations withToken: token];
    NSHTTPURLResponse *httpResp;
    
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResp error:&internalError];
    if(internalError == nil)
    {
        if(httpResp.statusCode == 200){
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:POSTReply options: NSJSONReadingMutableContainers error:&internalError];
            if(internalError == nil)
            {
                NSMutableArray *experiments = [[NSMutableArray alloc] init];
                [experiments addObject:[XYZExperimentParser expParser:json]];
        
                return experiments;
            }
            else
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:@"Server sent incorrectly formatted data, talk to admin" forKey:NSLocalizedDescriptionKey];
                *error = [NSError errorWithDomain:@"Servererror" code:2 userInfo:dict];
            }
        }
        else
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@"Insufficient permissions" forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:@"Authorization" code:0 userInfo:dict];
            
        }
    }
    else{
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"Could not connect to server" forKey:NSLocalizedDescriptionKey];
        [dict setObject:internalError forKey:NSUnderlyingErrorKey];
        *error = [NSError errorWithDomain:@"Connection" code:1 userInfo:dict];
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
