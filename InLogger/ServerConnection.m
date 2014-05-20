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
#import "XYZAnnotation.h"

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
            *error = [self generateErrorObjectFromHTTPError:httpResp.statusCode errorMessage:@"Login failed"];
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
         NSLog(@"internal %@", internalError);
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
                     NSString *errorMessage = [[self parseJSONToDictionary:POSTReply error:&internalError] objectForKey:@"message"];
                     error = [self generateErrorObjectFromHTTPError:httpResp.statusCode errorMessage:errorMessage];
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

+ (void)logout:(NSError**)error
{
    token = nil;
    NSMutableURLRequest *request = [JSONBuilder getLogoutJSON:token];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: nil];   
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
   NSLog(@"search");
    NSMutableURLRequest *request = [JSONBuilder getSearchJSON:annotations withToken: token];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
     {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
         NSMutableArray *array;
         NSError *error;
        
         if(internalError == nil)
         {
             if(httpResp.statusCode == 200)
             {
                 array = [self handleSearchPostReply:internalError POSTReply:POSTReply error:&error];
             }
             else
             {
                 NSString *errorMessage = [[self parseJSONToDictionary:POSTReply error:&internalError] objectForKey:@"message"];
                 error = [self generateErrorObjectFromHTTPError:httpResp.statusCode errorMessage:errorMessage];
             }
         }
         else{
             error = [self generateError:@"Could not connect to server" withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
         }
         [controller reportSearchResult:array error:error];
         NSLog(@"searched");
     }];
}

+(void)convert:(NSMutableDictionary*)dict withContext: (RawConvertViewController*) controller
{
    NSMutableURLRequest *request = [JSONBuilder getRawToProfileJSON:token withDict:dict];
    NSHTTPURLResponse *httpResp;
     
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
    {
      //  NSArray *array = [NSJSONSerialization JSONObjectWithData:POSTReply options: NSJSONReadingMutableContainers error:&internalError];
      //  NSLog(@"array: %@", array);
        if(internalError == nil)
        {
            if(!(httpResp.statusCode == 200))
            {
                NSString *errorMessage = [[self parseJSONToDictionary:POSTReply error:&internalError] objectForKey:@"message"];
                NSError *error = [self generateErrorObjectFromHTTPError:httpResp.statusCode errorMessage:errorMessage];
                [controller reportResult:error];
            }
        } else
        {
            NSError *error = [self generateError:@"Could not connect to server" withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
            [controller reportResult:error];
        }
    }];
}

+ (void)getAvailableAnnotations:(XYZSearchViewController*) controller
{
    NSLog(@"getAnno");
    NSMutableURLRequest *request = [JSONBuilder getAvailableAnnotationsJSON:token];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
    {
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        NSError *error;
        NSMutableArray *annotations;
      
        if (internalError == nil)
        {
            if (httpResp.statusCode == 200)
            {
                NSArray *array = [NSJSONSerialization JSONObjectWithData:POSTReply options: NSJSONReadingMutableContainers error:&internalError];
         
                if (internalError == nil)
                {
                    annotations = [[NSMutableArray alloc] init];
                    for (NSDictionary *json in array)
                    {
                        XYZAnnotation *annotation = [[XYZAnnotation alloc] init];
                        annotation.name = [json objectForKey:@"name"];
                        annotation.possibleValues = [json objectForKey:@"values"];
                        [annotations addObject:annotation];
                    }
                } else
                {
                    error = [self generateError:@"Server sent incorrectly formatted data, talk to admin" withErrorDomain:@"ServerError" withUnderlyingError:nil];
                }
            } else
            {
                NSString *errorMessage = [[self parseJSONToDictionary:POSTReply error:&internalError] objectForKey:@"message"];
                error = [self generateErrorObjectFromHTTPError:httpResp.statusCode errorMessage:errorMessage];
            }
        } else
        {
            error = [self generateError:@"Could not connect to server" withErrorDomain:@"Connection" withUnderlyingError:internalError];
        }
        [controller reportAnnotationResult:annotations error:error];
        NSLog(@"reported");
    }];
}


+ (void) getProcessStatus:(ProcessViewController*) controller
{
    NSMutableURLRequest *request = [JSONBuilder getProcessStatusJSON:token];
  
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
    {
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        NSLog(@"HTTPRESP status: %d", httpResp.statusCode);
        NSError *error;
        NSArray *processStatusResults;
        NSArray *array = [NSJSONSerialization JSONObjectWithData:POSTReply options: NSJSONReadingMutableContainers error:&internalError];
        NSLog(@"array: %@", array);
        if (internalError == nil)
        {
            if (httpResp.statusCode == 200)
            {
                NSArray *array = [NSJSONSerialization JSONObjectWithData:POSTReply options: NSJSONReadingMutableContainers error:&internalError];
                if (internalError == nil)
                {
                    processStatusResults = array;
                } else
                {
                    error = [self generateError:@"Server sent incorrectly formatted data, talk to admin" withErrorDomain:@"ServerError" withUnderlyingError:nil];
                }
            } else
            {
                NSString *errorMessage = [[self parseJSONToDictionary:POSTReply error:&internalError] objectForKey:@"message"];
                error = [self generateErrorObjectFromHTTPError:httpResp.statusCode errorMessage:errorMessage];
            }
        } else
        {
            error = [self generateError:@"Could not connect to server" withErrorDomain:@"Connection" withUnderlyingError:internalError];
        }
        [controller reportProcessStatusResult:processStatusResults error:error];
    }];
}

+(NSDictionary*)parseJSONToDictionary:(NSData*)POSTReply error:(NSError**)error
{
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:POSTReply options:kNilOptions error:error];
    return json;
}

+(NSError*)generateErrorObjectFromHTTPError:(NSInteger)errorCode errorMessage:(NSString *)errorMessage
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSError* error;

    switch(errorCode)
    {
        case 204:
            [dict setObject:errorMessage forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"Empty response" code:0 userInfo:dict];
            break;
        case 400:
            [dict setObject:errorMessage forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"Bad request" code:0 userInfo:dict];
            break;
        case 401:
            [dict setObject:errorMessage forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"Authorization" code:0 userInfo:dict];
            break;
        case 403:
            [dict setObject:errorMessage forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"Authorization" code:0 userInfo:dict];
            break;
        case 404:
            [dict setObject:errorMessage forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"Resource not found" code:0 userInfo:dict];
            break;
        case 405:
            [dict setObject:errorMessage forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"User error" code:0 userInfo:dict];
            break;
        case 429:
            [dict setObject:errorMessage forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"Server overloaded" code:0 userInfo:dict];
            break;
        case 503:
            [dict setObject:errorMessage forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"Server maintenance" code:0 userInfo:dict];
            break;
        default:
            [dict setObject: [NSString stringWithFormat:@"Unrecognised error, talk to developers. Error: %d", errorCode] forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"Coding error" code:0 userInfo:dict];
            break;
    }
    return error;
}

+ (NSError*) generateError: (NSString*) errorDescription withErrorDomain: (NSString*) errorDomain withUnderlyingError: (NSError*) underlyingError
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject: errorDescription forKey:NSLocalizedDescriptionKey];
    
    if (underlyingError != nil)
    {
        [dict setObject:underlyingError forKey:NSUnderlyingErrorKey];
    }
    return [NSError errorWithDomain:errorDomain code:1 userInfo:dict];
}

@end
