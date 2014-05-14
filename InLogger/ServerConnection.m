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
#import "XYZLogInViewController.h"

@implementation ServerConnection

NSString *token;

+ (void)handleLoginPostReply: (NSData *)POSTReply httpResp:(NSHTTPURLResponse *)httpResp error:(NSError **)error{
    
    NSError *internalError;
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
        *error = [self generateError:@"Server sent incorrectly formatted data, talk to admin" withErrorDomain:@"ServerError" withUnderlyingError:nil];
    }
}

+ (void)login:(NSString *)username withPassword:(NSString *)password error:(NSError**) error withContext: (XYZLogInViewController*) controller
{
    NSMutableURLRequest *request = [JSONBuilder getLoginJSON:username withPassword:password];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
     {
         NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
         NSError *error;
         
         if (internalError == nil)
         {
             NSDictionary *json = [self parseJSONToDictionary:POSTReply error:&internalError];
             
             if(internalError == nil)
             {
                 token = [json objectForKey:@"token"];
                 NSLog(@"login token %@", token);
                 NSLog(@"Header login: %ld", (long)httpResp.statusCode);
                 
                 if(httpResp.statusCode != 200)
                 {
                     error = [self generateErrorObjectFromHTTPError:httpResp.statusCode];
                 }
             }
             else
             {
                 error = [self generateError:@"Server sent incorrectly formatted data" withErrorDomain:@"Server Error" withUnderlyingError:nil];
             }
         }
         else
         {
             error = [self generateError:@"Could not connect to server" withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
         }
         [controller reportLoginResult:error];
     }];
}

+ (int)logout:(NSError**)error
{
    token = nil;
    NSMutableURLRequest *request = [JSONBuilder getLogoutJSON:token];
    
    NSHTTPURLResponse *httpResp;

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: nil];

    NSLog(@"logout token %@", token);
    NSLog(@"Header: %ld", (long)httpResp.statusCode);
   
    return httpResp.statusCode;
}

 
+ (NSMutableArray*)handleSearchPostReply:(NSError *)internalError POSTReply:(NSData *)POSTReply error:(NSError **)error
{
    NSArray *array = [NSJSONSerialization JSONObjectWithData:POSTReply options: NSJSONReadingMutableContainers error:&internalError];
    if(internalError == nil)
    {
        NSMutableArray *experiments = [[NSMutableArray alloc] init];
        for(NSDictionary *json in array)
        {
            [experiments addObject:[XYZExperimentParser expParser:json]];
        }
        return experiments;
    }
    else
    {
        *error = [self generateError:@"Server sent incorrectly formatted data, talk to admin" withErrorDomain:@"ServerError" withUnderlyingError:nil];
    }
    return nil;
}

+ (void)search:(NSString*)annotations withContext: (XYZSearchViewController*) controller
{
   
    NSMutableURLRequest *request = [JSONBuilder getSearchJSON:annotations withToken: token];
    NSHTTPURLResponse *httpResp;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
     {
         [NSThread sleepForTimeInterval:3];
         if(internalError == nil)
         {
             if(httpResp.statusCode == 200){
                 //return [self handleSearchPostReply:internalError POSTReply:POSTReply error:error];
                 NSError *error;
                 NSMutableArray *array = [self handleSearchPostReply:internalError POSTReply:POSTReply error:&error];
                 [controller reportSearchResult: array withParsingError:error];
             }
             else
             {
                  NSError *error = [self generateErrorObjectFromHTTPError:httpResp.statusCode];
                 [controller reportSearchResult:nil withParsingError:error];
             }
         }
         else{
             NSError *error;
             error = [self generateError:@"Could not connect to server" withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
             [controller reportSearchResult:nil withParsingError:error];
         }
     }];
}

+(void)convert:(NSMutableDictionary*)dict withContext: (RawConvertViewController*) controller
{
    NSMutableURLRequest *request = [JSONBuilder getRawToProfileJSON:token withDict:dict];
    NSHTTPURLResponse *httpResp;
   // [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResp error:&internalError];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
    {
    
        if(internalError == nil)
        {
            if(!(httpResp.statusCode == 200))
            {
                NSError *error = [self generateErrorObjectFromHTTPError:httpResp.statusCode];
                [controller reportResult:error];
            }
        } else
        {
            NSError *error = [self generateError:@"Could not connect to server" withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
            [controller reportResult:error];
        }
    }];
}

+ (NSMutableDictionary*)getAvailableAnnotations:(NSError**)error
{
    NSError *internalError;
    NSHTTPURLResponse *httpResp;
 
    NSMutableURLRequest *request = [JSONBuilder getAvailableAnnotationsJSON:token];
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResp error:&internalError];
    
    if(internalError == nil)
    {
        if(httpResp.statusCode == 200){
            NSArray *array = [NSJSONSerialization JSONObjectWithData:POSTReply options: NSJSONReadingMutableContainers error:&internalError];
            NSLog(@"quesssry %@", array);
            if(internalError == nil)
            {
                NSMutableDictionary *annotations = [[NSMutableDictionary alloc] init];
                for(NSDictionary *json in array)
                {
                    NSLog(@"quesssry %@", array);
                    [annotations setObject:[json objectForKey:@"values"] forKey:[json objectForKey:@"name"]];
                }
             
                return annotations;
                
            }
            else
            {
                *error = [self generateError:@"Server sent incorrectly formatted data, talk to admin" withErrorDomain:@"ServerError" withUnderlyingError:nil];
            }
        }
        else
        {
            *error = [self generateErrorObjectFromHTTPError:httpResp.statusCode];
            
        }
    }
    else{
        *error = [self generateError:@"Could not connect to server" withErrorDomain:@"Connection" withUnderlyingError:internalError];
    }
    return nil;
}


+(NSDictionary*)parseJSONToDictionary:(NSData*)POSTReply error:(NSError**)error
{
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:POSTReply options:kNilOptions error:error];
    /*
    if([*error localizedDescription] != nil)
    {
        NSLog(@"parsing json %@",[*error localizedDescription]);
        [NSException raise:@"Error parsing JSON" format:@"Error parsing JSON"];
    }
    */
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
            [dict setObject:@"Resource not found!" forKey:NSLocalizedDescriptionKey];
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

+ (NSError*) generateError: (NSString*) errorDescription withErrorDomain: (NSString*) errorDomain withUnderlyingError: (NSError*) underlyingError{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject: errorDescription forKey:NSLocalizedDescriptionKey];
    
    if(underlyingError != nil){
        [dict setObject:underlyingError forKey:NSUnderlyingErrorKey];
    }
    return [NSError errorWithDomain:errorDomain code:1 userInfo:dict];
}

@end
