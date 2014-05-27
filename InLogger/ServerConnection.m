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

//+ (void)handleLoginPostReply: (NSData *)POSTReply httpResp:(NSHTTPURLResponse *)httpResp error:(NSError **)error{
//
//    NSError *internalError;
//    NSDictionary *json = [self parseJSONToDictionary:POSTReply error:&internalError];
//
//    if(internalError == nil)
//    {
//        NSLog(@"------- Login Token %@", [json objectForKey:@"token"]);
//
//        if(httpResp.statusCode != 200)
//        {
//            *error = [self generateErrorObjectFromHTTPError:httpResp.statusCode errorMessage:@"Login failed"];
//        }
//    }
//    else
//    {
//        *error = [self generateError:@"Server sent incorrectly formatted data, talk to admin" withErrorDomain:@"ServerError" withUnderlyingError:nil];
//    }
//}

+ (void)login:(NSString *)username withPassword:(NSString *)password error:(NSError**) error withContext: (XYZLogInViewController*) controller
{
    NSMutableURLRequest *request = [JSONBuilder getLoginJSON:username withPassword:password];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
     {
         NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
         NSMutableDictionary *message = [NSJSONSerialization JSONObjectWithData:POSTReply options:kNilOptions error:error];
         NSError *error;
         if (internalError == nil)
         {
             NSDictionary *json = [self parseJSONToDictionary:POSTReply error:&internalError];
             
             if(internalError == nil)
             {
                 if([json objectForKey:@"token"] != nil){
                     token = [json objectForKey:@"token"];
                 }else{
                     error = [self generateError:@"Server sent incorrectly formatted data" withErrorDomain:@"Server Error" withUnderlyingError:nil];
                 }
                 
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
         else if([message objectForKey:@"message"] != nil){
             error = [self generateError:[message objectForKey:@"message"] withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
         }
         else
         {
             error = [self generateError:@"Connetion error" withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
         }
         [controller reportLoginResult:error];
     }];
}

+ (void)logout:(NSError**)error
{
    NSMutableURLRequest *request = [JSONBuilder getLogoutJSON:token];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    token = nil;
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
            if([json objectForKey:@"name"] != nil){
                [experiments addObject:[XYZExperimentParser expParser:json]];
            }else{
                *error = [self generateError:@"Server sent incorrectly formatted data" withErrorDomain:@"Server Error" withUnderlyingError:nil];
            }
            
            
        }
        return experiments;
    }
    else
    {
        *error = [self generateError:@"Server sent incorrectly formatted data" withErrorDomain:@"ServerError" withUnderlyingError:nil];
    }
    return nil;
}

+ (void)search:(NSString*)annotations withContext: (XYZSearchViewController*) controller
{
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
                 NSDictionary *errorDict = [self parseJSONToDictionary:POSTReply error:&internalError];
                 NSString *errorMessage;
                 if([errorDict objectForKey:@"message"] != nil)
                 {
                     errorMessage = [[self parseJSONToDictionary:POSTReply error:&internalError] objectForKey:@"message"];
                     
                 }
                 else{
                     errorMessage =@"Server sent incorrectly formatted data";
                 }
                 error = [self generateErrorObjectFromHTTPError:httpResp.statusCode errorMessage:errorMessage];
             }
         }
         else{
             error = [self generateError:@"Could not connect to server" withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
         }
         [controller reportSearchResult:array error:error];
     }];
}

+ (void)genomeRelease: (RawConvertViewController*) controller
{
    NSMutableURLRequest *request = [JSONBuilder getgenomeReleaseJSON:token];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
     {
         NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
         NSError *error;
         NSMutableArray* genomeReleases = [[NSMutableArray alloc] init];
         if(internalError == nil)
         {
             if(httpResp.statusCode == 200)
             {
                 NSArray *array = [NSJSONSerialization JSONObjectWithData:POSTReply options: NSJSONReadingMutableContainers error:&internalError];
                 for (NSDictionary *json in array)
                 {
                     if([json objectForKey:@"genomeVersion"] != nil){
                         [genomeReleases addObject:[json objectForKey:@"genomeVersion"]];
                     }
                 }
             }
             else
             {
                 NSDictionary *errorDict = [self parseJSONToDictionary:POSTReply error:&internalError];
                 NSString *errorMessage;
                 if([errorDict objectForKey:@"message"] != nil)
                 {
                     errorMessage = [[self parseJSONToDictionary:POSTReply error:&internalError] objectForKey:@"message"];
                     
                 }
                 else{
                     errorMessage =@"Server sent incorrectly formatted data";
                 }
                 error = [self generateErrorObjectFromHTTPError:httpResp.statusCode errorMessage:errorMessage];
             }
         }
         else{
             error = [self generateError:@"Could not connect to server" withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
         }
         
         [controller reportGenomeResult:genomeReleases withError:error];
         
     }];
}


+(void)convert:(NSMutableDictionary*)dict withContext: (RawConvertViewController*) controller
{
    NSMutableURLRequest *request = [JSONBuilder getRawToProfileJSON:token withDict:dict];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
     {
         [NSThread sleepForTimeInterval:5];
         NSError *error;
         NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
         if(internalError == nil)
         {
             if(httpResp.statusCode != 200)
             {
                 NSDictionary *errorDict = [self parseJSONToDictionary:POSTReply error:&internalError];
                 NSString *errorMessage;
                 if([errorDict objectForKey:@"message"] != nil)
                 {
                     errorMessage = [[self parseJSONToDictionary:POSTReply error:&internalError] objectForKey:@"message"];
                     
                 }
                 else{
                     errorMessage =@"Server sent incorrectly formatted data";
                 }
                 error = [self generateErrorObjectFromHTTPError:httpResp.statusCode errorMessage:errorMessage];
             }
         } else
         {
             error = [self generateError:@"Could not connect to server" withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
         }
         [controller reportResult:error experiment: [dict objectForKey:@"expid"]];
     }];
}

+ (void)getAvailableAnnotations:(XYZSearchViewController*) controller
{
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
                         if([json objectForKey:@"name"] != nil){
                             annotation.name = [json objectForKey:@"name"];
                             NSArray* values;
                              if([json objectForKey:@"values"] != nil){
                                   values = [json objectForKey:@"values"];
                              }else{
                                  values = [[NSArray alloc] initWithObjects:@"freetext", nil];
                              }
                             annotation.possibleValues = values;
                             [annotations addObject:annotation];
                         }
                     }
                 } else
                 {
                     error = [self generateError:@"Server sent incorrectly formatted data, talk to admin" withErrorDomain:@"ServerError" withUnderlyingError:nil];
                 }
             } else
             {
                 NSDictionary *errorDict = [self parseJSONToDictionary:POSTReply error:&internalError];
                 NSString *errorMessage;
                 if([errorDict objectForKey:@"message"] != nil)
                 {
                     errorMessage = [[self parseJSONToDictionary:POSTReply error:&internalError] objectForKey:@"message"];
                     
                 }
                 else{
                     errorMessage =@"Server sent incorrectly formatted data";
                 }
                 error = [self generateErrorObjectFromHTTPError:httpResp.statusCode errorMessage:errorMessage];

             }
         } else
         {
             error = [self generateError:@"Could not connect to server" withErrorDomain:@"Connection" withUnderlyingError:internalError];
         }
         [controller reportAnnotationResult:annotations error:error];
     }];
}


+ (void) getProcessStatus:(ProcessViewController*) controller
{
    NSMutableURLRequest *request = [JSONBuilder getProcessStatusJSON:token];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
     {
         NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
         NSError *error;
         NSMutableArray *processStatusResults = [[NSMutableArray alloc] init];
         if (internalError == nil)
         {
             if (httpResp.statusCode == 200)
             {
                 
                 NSArray *array = [NSJSONSerialization JSONObjectWithData:POSTReply options: NSJSONReadingMutableContainers error:&internalError];
                 NSLog(@"processes: %@", array);
                 if (internalError == nil)
                 {
                     
      
                     for(NSDictionary *json in array){
                         if(([json objectForKey:@"experimentName"] != nil) && ([json objectForKey:@"status"] != nil) && ([json objectForKey:@"timeAdded"] != nil) && ([json objectForKey:@"timeStarted"] != nil) && ([json objectForKey:@"timeFinished"] != nil)){
                            
                             [processStatusResults addObject:json];
                        }
                     }
                     
                 } else
                 {
                     error = [self generateError:@"Server sent incorrectly formatted data, talk to admin" withErrorDomain:@"ServerError" withUnderlyingError:nil];
                 }
             } else
             {
                 NSDictionary *errorDict = [self parseJSONToDictionary:POSTReply error:&internalError];
                 NSString *errorMessage;
                 if([errorDict objectForKey:@"message"] != nil)
                 {
                     errorMessage = [[self parseJSONToDictionary:POSTReply error:&internalError] objectForKey:@"message"];
                     
                 }
                 else{
                     errorMessage =@"Server sent incorrectly formatted data";
                 }
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
            [dict setObject:@"Bad request, fill in more information" forKey:NSLocalizedDescriptionKey];
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
