//
//  ServerConnection.m
//  Genomizer
//
// A class that contains static methods for all server communication.
// All communication happens asynchronously, which means none of the methods
// have return values. Instead the method, when done, reports to the viewController
// it has access to.
//

#import "ServerConnection.h"
#import "JSONBuilder.h"
#import "ExperimentParser.h"
#import "Annotation.h"

@implementation ServerConnection

NSString *token;
#define kConnectionErrorMsg @"Could not access server, either no internet connection or server error."
/**
 * Static method that asynchronously sends a login request to the server,
 * which either succeeds or fails. When an answer is received, 
 * the method reports to the viewController it has knowledge about.
 *
 *@param controller - LogInViewController, which the method will report the result to
 *@return nothing
 */

+(void)setToken:(NSString *)t{
    token = t;
}

#warning change return value to BOOL
+ (void)login:(NSString *)username withPassword:(NSString *)password error:(NSError**) error withContext: (LogInViewController*) controller
{
    NSMutableURLRequest *request = [JSONBuilder getLoginJSON:username withPassword:password];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
     {
         //everything in here happens when the asynchronous NSURLRequest is finished, in the same thread.
         
         NSMutableDictionary *message;
         NSError *error;
         if (POSTReply != nil) {
             message = [NSJSONSerialization JSONObjectWithData:POSTReply options:kNilOptions error:&error];
         }
         if (internalError == nil) {

             NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
             NSDictionary *json = [self parseJSONToDictionary:POSTReply error:&internalError];
             if(internalError == nil)
             {
                
                 if([json objectForKey:@"token"] != nil){
                     token = [json objectForKey:@"token"];
                 } else{
                     error = [self generateError:@"Server sent incorrectly formatted data" withErrorDomain:@"Server Error" withUnderlyingError:nil];
                 }
                 
                 if(httpResp.statusCode != 200) {
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
         else {
             error = [self generateError:kConnectionErrorMsg withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
         }
         completionBlock(token, error);
     }];
}

+ (void)logout:(void(^)())completion
{
    NSMutableURLRequest *request = [JSONBuilder getLogoutJSON:token];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    token = nil;
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"Logout response");
        completion();
    }];
}


/**
 * Static method that asynchronously sends a search request to the server. When a search result
 * is received, method reports to the viewController it has knowledge about.
 *
 *@param controller - SearchViewController, which the method will report the result to
 *@return nothing
 */
+ (void)search:(NSString*)annotations withContext:(void (^)(NSMutableArray *,
                                                            NSError *)
                                                   )completionBlock;
{
    NSMutableURLRequest *request = [JSONBuilder getSearchJSON:annotations withToken: token];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
     {
         //everything in here happens when the asynchronous NSURLRequest is finished, in the same thread.
         
         NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
         NSMutableArray *array;
         NSError *error;
         NSLog(@"Search result: [%@] internal error: [%@]", response, internalError);
         if(internalError == nil)
         {
             if(httpResp.statusCode == 200)
             {
                 array = [self handleSearchPostReply:internalError POSTReply:POSTReply error:&error];
             }
             else {
                 error = [ServerConnection generateError:POSTReply internaleError:internalError response:httpResp];
             }
         }
         else{
             error = [self generateError:kConnectionErrorMsg withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
         }
         completionBlock(array, error);
     }];
}

/**
 * Method that handles the reply from a search request. Returns an NSArray containing the answer.
 *
 *@param interalError - error that has happened during server communication, if such an error exists
 *@param POSTReply - the reply the server gave
 *@param error - memory holder for error, where errors during parsing is saved. WARNING: Has to be checked when
 *                                                                                       this method is used.
 *@return NSMutableArray containing the information recieved from the server
 */
+ (NSMutableArray*)handleSearchPostReply:(NSError *)internalError POSTReply:(NSData *)POSTReply error:(NSError **)error
{
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:POSTReply options: NSJSONReadingMutableContainers error:&internalError];
    
    if(internalError == nil) {
        NSMutableArray *experiments = [[NSMutableArray alloc] init];
        for(NSDictionary *json in array) {
            if([json objectForKey:@"name"] != nil){
                [experiments addObject:[ExperimentParser expParser:json]];
            } else{
                *error = [self generateError:@"Server sent incorrectly formatted data" withErrorDomain:@"Server Error" withUnderlyingError:nil];
            }
            
            
        }
        return experiments;
    }
    else{
        *error = [self generateError:@"Server sent incorrectly formatted data" withErrorDomain:@"ServerError" withUnderlyingError:nil];
    }
    return nil;
}

/**
 * Static method that asynchronously sends a get genome releases request to the server,
 * which contains all available genome releases on the server. When an answer
 * is received, method reports to the viewController it has knowledge about.
 *
 *@param controller - RawConvertViewController, which the method will report the result to
 *@return nothing
 */
+ (void)genomeRelease:(void (^)(NSMutableArray *, NSError *))completionBlock
{
    NSMutableURLRequest *request = [JSONBuilder getGenomeReleaseJSON:token];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
     {
         //everything in here happens when the asynchronous NSURLRequest is finished, in the same thread.
         
         NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
         NSError *error;
         NSMutableArray* genomeReleases = [[NSMutableArray alloc] init];
         if(internalError == nil) {
             if(httpResp.statusCode == 200) {
                 NSArray *array = [NSJSONSerialization JSONObjectWithData:POSTReply options: NSJSONReadingMutableContainers error:&internalError];
                 
                 for (NSDictionary *json in array){
                     if([json objectForKey:@"genomeVersion"] != nil){
                         [genomeReleases addObject:[json objectForKey:@"genomeVersion"]];
                     }
                 }
             }
             else{
                 error = [ServerConnection generateError:POSTReply internaleError:internalError response:httpResp];
             }
         }
         else{
             error = [self generateError:kConnectionErrorMsg withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
         }
         
         completionBlock(genomeReleases, error);
         
     }];
}

/**
 * Static method that asynchronously sends a conversion request to the server. When an answer
 * is received, method reports to the viewController it has knowledge about.
 *
 *@param controller - RawConvertViewController, which the method will report the result to
 *@return nothing
 */
+(void)convert:(NSMutableDictionary*)dict withContext:(void (^)(NSError *,
                                                                NSString *)
                                                       )completionBlock
{
    NSMutableURLRequest *request = [JSONBuilder getRawToProfileJSON:token withDict:dict];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
     {
         //everything in here happens when the asynchronous NSURLRequest is finished, in the same thread.
         
         NSError *error;
         NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
         if(internalError == nil)
         {
             if(httpResp.statusCode != 200)
             {
                 error = [ServerConnection generateError:POSTReply internaleError:internalError response:httpResp];
             }
         } else
         {
             error = [self generateError:kConnectionErrorMsg withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
         }
         completionBlock(error, [dict objectForKey:@"expid"]);
     }];
}

/**
 * Static method that asynchronously sends a get annotations request to the server,
 * which contains all annotations on the server. When an answer
 * is received, method reports to the viewController it has knowledge about.
 *
 *@param controller - SearchViewController, which the method will report the result to
 *@return nothing
 */
+ (void)getAvailableAnnotations:(void (^)(NSArray *, NSError *))completionBlock
{
    
    NSMutableURLRequest *request = [JSONBuilder getAvailableAnnotationsJSON:token];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
     {
         //everything in here happens when the asynchronous NSURLRequest is finished, in the same thread.
         NSLog(@"Available annotations: %@ %@", response, internalError.userInfo);
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
                         Annotation *annotation = [[Annotation alloc] init];
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
                 error = [ServerConnection generateError:POSTReply internaleError:internalError response:httpResp];
             }
         } else
         {
             error = [self generateError:kConnectionErrorMsg withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
         }
         completionBlock(annotations, error);
     }];
}

/**
 * Static method that asynchronously sends a process request to the server,
 * which contains the current processes the server is doing. When an answer 
 * is received, method reports to the viewController it has knowledge about.
 *
 *@param controller - ProcessViewController, which the method will report the result to
 *@return nothing
 */
+ (void) getProcessStatus:(void (^)(NSMutableArray *, NSError *))completionBlock
{
    NSMutableURLRequest *request = [JSONBuilder getProcessStatusJSON:token];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
     {
         //everything in here happens when the asynchronous NSURLRequest is finished, in the same thread.
         
         NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
         NSError *error;
         NSMutableArray *processStatusResults = [[NSMutableArray alloc] init];
         if (internalError == nil) {
             if (httpResp.statusCode == 200){
                 
                 NSArray *array = [NSJSONSerialization JSONObjectWithData:POSTReply options: NSJSONReadingMutableContainers error:&internalError];

                 if (internalError == nil) {
                     
                     for(NSDictionary *json in array){
                         if(([json objectForKey:@"experimentName"] != nil) && ([json objectForKey:@"status"] != nil) && ([json objectForKey:@"timeAdded"] != nil) && ([json objectForKey:@"timeStarted"] != nil) && ([json objectForKey:@"timeFinished"] != nil)){
                            
                             [processStatusResults addObject:json];
                        }
                     }
                     
                 } else {
                     error = [self generateError:@"Server sent incorrectly formatted data, talk to admin" withErrorDomain:@"ServerError" withUnderlyingError:nil];
                 }
             } else {
                 error = [ServerConnection generateError:POSTReply internaleError:internalError response:httpResp];
             }
         } else {
             error = [self generateError:kConnectionErrorMsg withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
         }
         completionBlock(processStatusResults, error);
     }];
}

+(NSDictionary*)parseJSONToDictionary:(NSData*)POSTReply error:(NSError**)error
{
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:POSTReply options:kNilOptions error:error];
    return json;
}

/**
 * Static method that generates an NSError from an HTTP error
 *
 * @param errorCode - integer containing a code for the error
 * @param errorMessage - NSString containing a description to display to the user.
 * @return superseding NSError
 */
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
            [dict setObject:@"Nothing got selected in the search. Please tap on the switches on the field's you wish to search. for." forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"Nothing sent" code:0 userInfo:dict];
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
            error = [NSError errorWithDomain:@"Server Message" code:0 userInfo:dict];
            break;
        default:
            [dict setObject: [NSString stringWithFormat:@"Unrecognised error, talk to developers. Error: %d", (int)errorCode] forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"Coding error" code:0 userInfo:dict];
            break;
    }
    return error;
}

/**
Creates error to a HTTP message with other than 200 as responsecode
 @param POSTReply Data which gets sent back from server
 @param internalError Error sent back from async request
 @param httpResp Response from server
 @return Error with new information
 */
+(NSError *)generateError:(NSData *)POSTReply internaleError:(NSError *)internalError response:(NSHTTPURLResponse *)httpResp{
    NSError *error;
    NSDictionary *errorDict = [ServerConnection parseJSONToDictionary:POSTReply error:&internalError];
    NSString *errorMessage;
    if([errorDict objectForKey:@"message"] != nil) {
        errorMessage = [[ServerConnection parseJSONToDictionary:POSTReply error:&internalError] objectForKey:@"message"];
        
    }
    else{
        errorMessage = @"Server sent incorrectly formatted data";
    }
    error = [ServerConnection generateErrorObjectFromHTTPError:httpResp.statusCode errorMessage:errorMessage];
    return error;
}

/**
 * Static method that creates an NSError from parameters.
 *
 *@param errrorDescription - NSString containing information about the error
 *@param withErrorDomain - NSString containing information about what domain the error
 *                         is related to
 *@param withUnderlyingError - NSError containing preceding error, if any
 *@return the superseding NSError
 */
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
