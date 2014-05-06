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
        
        if(internalError == nil)
        {
            token = [json objectForKey:@"token"];
            NSLog(@"login token %@", token);
            NSLog(@"Header: %ld", (long)httpResp.statusCode);
            
            if(httpResp.statusCode != 200)
            {
                *error = [self generateErrorObjectFromHTTPError:httpResp.statusCode];
            }
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

 
+(NSMutableArray*)search:(NSString*)annotations error:(NSError**) error
{
    NSError *internalError;
   
    NSMutableURLRequest *request = [JSONBuilder getSearchJSON:annotations withToken: token];
    NSHTTPURLResponse *httpResp;
    
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResp error:&internalError];
    if(internalError == nil)
    {
        if(httpResp.statusCode == 200){
            NSArray *array = [NSJSONSerialization JSONObjectWithData:POSTReply options: NSJSONReadingMutableContainers error:&internalError];
            if(internalError == nil)
            {
                NSMutableArray *experiments = [[NSMutableArray alloc] init];
                for(NSDictionary *json in array)
                {
                    //NSLog(@"****** %@", json);
                    [experiments addObject:[XYZExperimentParser expParser:json]];
                }
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
            *error = [self generateErrorObjectFromHTTPError:httpResp.statusCode];
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

+(void)convert:(NSArray*)fileIDs error:(NSError**)error
{
    NSError *internalError;
    NSLog(@"convert: %d", [fileIDs count]);

    for(NSString *fileID in fileIDs)
    {
        NSMutableURLRequest *request = [JSONBuilder getConversionJSON:fileID withToken:token];
        NSHTTPURLResponse *httpResp;
        [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResp error:&internalError];
        NSLog(@"**** %@", [internalError localizedDescription]);
    }
}

+ (NSArray*)getAvailableAnnotations:(NSError**)error
{
    NSError *internalError;
    NSHTTPURLResponse *httpResp;
    
    NSMutableURLRequest *request = [JSONBuilder getAvailableAnnotationsJSON:token];
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResp error:&internalError];
    if(internalError == nil)
    {
        if(httpResp.statusCode == 200){
            NSArray *array = [NSJSONSerialization JSONObjectWithData:POSTReply options: NSJSONReadingMutableContainers error:&internalError];
            if(internalError == nil)
            {
                NSMutableArray *annotations = [[NSMutableArray alloc] init];
                for(NSDictionary *json in array)
                {
                    [annotations addObject:[json objectForKey:@"name"]];
                }
                return annotations;
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
            *error = [self generateErrorObjectFromHTTPError:httpResp.statusCode];
            
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

+(NSError*)generateErrorObjectFromHTTPError:(NSInteger)errorCode
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSError* error;

    switch(errorCode)
    {
        case 204:
            [dict setObject:@"Empty response from server" forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"Empty response" code:0 userInfo:dict];
            break;
        case 400:
            [dict setObject:@"Bad request, talk to the admin" forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"Bad request" code:0 userInfo:dict];
            break;
        case 401:
            [dict setObject:@"Insufficient permissions" forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"Authorization" code:0 userInfo:dict];
            break;
        case 403:
            [dict setObject:@"Access denied" forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"Authorization" code:0 userInfo:dict];
            break;
        case 404:
            [dict setObject:@"Resource not found" forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"Resource not found" code:0 userInfo:dict];
            break;
        case 405:
            [dict setObject:@"Action not allowed for chosen files" forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"User error" code:0 userInfo:dict];
            break;
        case 429:
            [dict setObject:@"Too many requests, wait a minute and try again" forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"Server overloaded" code:0 userInfo:dict];
            break;
        case 503:
            [dict setObject:@"Server down for maintenance, try again later" forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"Server maintenance" code:0 userInfo:dict];
            break;
    }
    
    return error;
}
@end
