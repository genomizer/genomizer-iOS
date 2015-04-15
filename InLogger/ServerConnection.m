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
+ (void)login:(NSString *)username withPassword:(NSString *)password error:(NSError**) error withContext: (LogInViewController*) controller
{
    NSMutableURLRequest *request = [JSONBuilder getLoginJSON:username withPassword:password];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
     {
         //everything in here happens when the asynchronous NSURLRequest is finished, in the same thread.
         
         NSMutableDictionary *message;
         NSError *error;
         if (POSTReply != nil)
         {
             message = [NSJSONSerialization JSONObjectWithData:POSTReply options:kNilOptions error:&error];
         }
         NSLog(@"LOGIN resp: %@ %@", response, message);
         if (internalError == nil)
         {

             NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
             NSDictionary *json = [self parseJSONToDictionary:POSTReply error:&internalError];
             NSLog(@"json: %@", json);
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
             error = [self generateError:kConnectionErrorMsg withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
         }
         [controller reportLoginResult:error];
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
    NSArray *array = [NSJSONSerialization JSONObjectWithData:POSTReply options: NSJSONReadingMutableContainers error:&internalError];
    
    if(internalError == nil)
    {
        NSMutableArray *experiments = [[NSMutableArray alloc] init];
        for(NSDictionary *json in array)
        {
            if([json objectForKey:@"name"] != nil){
                [experiments addObject:[ExperimentParser expParser:json]];
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

/**
 * Static method that asynchronously sends a search request to the server. When a search result
 * is received, method reports to the viewController it has knowledge about.
 *
 *@param controller - SearchViewController, which the method will report the result to
 *@return nothing
 */
+ (void)search:(NSString*)annotations withContext: (SearchViewController*) controller
{
    NSMutableURLRequest *request = [JSONBuilder getSearchJSON:annotations withToken: token];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
     {
         //everything in here happens when the asynchronous NSURLRequest is finished, in the same thread.
         
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
             error = [self generateError:kConnectionErrorMsg withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
         }
         [controller reportSearchResult:array error:error];
     }];
}

/**
 * Static method that asynchronously sends a get genome releases request to the server,
 * which contains all available genome releases on the server. When an answer
 * is received, method reports to the viewController it has knowledge about.
 *
 *@param controller - RawConvertViewController, which the method will report the result to
 *@return nothing
 */
+ (void)genomeRelease: (RawConvertViewController*) controller
{
    NSMutableURLRequest *request = [JSONBuilder getGenomeReleaseJSON:token];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
     {
         //everything in here happens when the asynchronous NSURLRequest is finished, in the same thread.
         
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
             error = [self generateError:kConnectionErrorMsg withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
         }
         
         [controller reportGenomeResult:genomeReleases withError:error];
         
     }];
}

/**
 * Static method that asynchronously sends a conversion request to the server. When an answer
 * is received, method reports to the viewController it has knowledge about.
 *
 *@param controller - RawConvertViewController, which the method will report the result to
 *@return nothing
 */
+(void)convert:(NSMutableDictionary*)dict withContext: (RawConvertViewController*) controller
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
             error = [self generateError:kConnectionErrorMsg withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
         }
         [controller reportResult:error experiment:[dict objectForKey:@"expid"]];
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
+ (void)getAvailableAnnotations:(SearchViewController*) controller
{
    
    NSMutableURLRequest *request = [JSONBuilder getAvailableAnnotationsJSON:token];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
     {
         //everything in here happens when the asynchronous NSURLRequest is finished, in the same thread.
         
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
             error = [self generateError:kConnectionErrorMsg withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
         }
         [controller reportAnnotationResult:annotations error:error];
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
+ (void) getProcessStatus:(ProcessViewController*) controller
{
    NSMutableURLRequest *request = [JSONBuilder getProcessStatusJSON:token];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: ^(NSURLResponse *response, NSData *POSTReply, NSError *internalError)
     {
         //everything in here happens when the asynchronous NSURLRequest is finished, in the same thread.
         
         NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
         NSError *error;
         NSMutableArray *processStatusResults = [[NSMutableArray alloc] init];
         if (internalError == nil)
         {
             if (httpResp.statusCode == 200)
             {
                 
                 NSArray *array = [NSJSONSerialization JSONObjectWithData:POSTReply options: NSJSONReadingMutableContainers error:&internalError];

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
             error = [self generateError:kConnectionErrorMsg withErrorDomain:@"Connection Error" withUnderlyingError:internalError];
         }

         [controller reportProcessStatusResult:processStatusResults error:error];
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
