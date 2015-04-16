//
//  JSONBuilder.m
//  Genomizer
//
//  A class that creates NSURLRequests containing JSON objects where applicable
//  as described by the API for the Genomizer project.
//

#import "JSONBuilder.h"

@implementation JSONBuilder

static NSString *SERVER_URL = @"dumbledore.cs.umu.se:7000";

/**
 * Static method that generates a Login URLRequest with a JSON object containing login credentials.
 *
 *@param username - the username to be used to log in.
 *@param password - the password to be used to log in.
 *@return NSMutableURLRequest to log in to the server with a JSON containing login credentials.
 */

+(NSMutableURLRequest*)getLoginJSON:(NSString *)username withPassword:(NSString *)password
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:password forKey:@"password"];
    [dict setValue:username forKey:@"username"];
   
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0
                                                         error:nil];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[[self getServerURL] stringByAppendingString:@"login"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    return request;
}

/**
 * Static method that generates a Logout URLRequest.
 *
 *@param token - the authorization token to the server.
 *@return NSMutableURLRequest to log out from the server.
 */
+(NSMutableURLRequest*)getLogoutJSON:(NSString *)token
{
    NSMutableURLRequest *request = [self getRequest:@"DELETE" withToken:token];
    [request setURL:[NSURL URLWithString:[[self getServerURL] stringByAppendingString:@"login"]]];
    return request;
}

/**
 * Static method that generates a get genome releases URLRequest.
 *
 *@param token - the authorization token to the server.
 *@return NSMutableURLRequest to get genome releases from the server.
 */

+(NSMutableURLRequest*)getGenomeReleaseJSON:(NSString *)token
{
    NSMutableURLRequest *request = [self getRequest:@"GET" withToken:token];
    [request setURL:[NSURL URLWithString:[[self getServerURL] stringByAppendingString:@"genomeRelease"]]];
    return request;
}

/**
 * Static method that generates a Search URLRequest.
 *
 *@param annotations - the annotations to be used to search.
 *@param token - the authorization token to the server.
 *@return NSMutableURLRequest to search using the annotations.
 */

+(NSMutableURLRequest*) getSearchJSON:(NSString*) annotations withToken:(NSString *) token
{
    NSString *annotationString = @"search/?annotations=";
    NSString *annotationsStringComplete = [annotationString stringByAppendingString:annotations];
    NSString *encodedAnnotations = [annotationsStringComplete stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request =  [self getRequest:@"GET" withToken:token];
    [request setURL:[NSURL URLWithString: [[self getServerURL] stringByAppendingString:encodedAnnotations]]];   
    return request;
}

/**
 * Static method that generates a URLRequest to convert one set of raw files from raw to profile.
 *
 *@param token - the authorization token to the server.
 *@param dict - a dictionary containing parameters and metadata for the conversion
 *@return NSMutableURLRequest to convert a set of raw files, with a JSON object containing parameters and metadata.
 */

+(NSMutableURLRequest*)getRawToProfileJSON:(NSString *)token withDict:(NSMutableDictionary*)dict{
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict
                                                           options:0
                                                             error:nil];
    NSString *conversionString =@"process/rawtoprofile";
    NSMutableURLRequest *request = [self getRequest:@"PUT" withToken:token];
    [request setHTTPBody:postData];
    [request setURL:[NSURL URLWithString: [[self getServerURL] stringByAppendingString:conversionString]]];
    return request;
    
}

/**
 * Static method that generates a get annotations URLRequest.
 *
 *@param token - the authorization token to the server.
 *@return NSMutableURLRequest to get available annotations from the server.
 */
+(NSMutableURLRequest*)getAvailableAnnotationsJSON:(NSString *) token
{
    NSMutableURLRequest *request = [self getRequest:@"GET" withToken:token];
    [request setURL:[NSURL URLWithString: [[self getServerURL] stringByAppendingString: @"annotation"]]];
    
    return request;
}

/**
 * Static method that generates a get process status URLRequest.
 *
 *@param token - the authorization token to the server.
 *@return NSMutableURLRequest to get status of processes and conversions from the server.
 */
+ (NSMutableURLRequest*) getProcessStatusJSON:(NSString *) token
{
    NSMutableURLRequest *request = [self getRequest:@"GET" withToken:token];
    [request setURL:[NSURL URLWithString: [[self getServerURL] stringByAppendingString:@"process"]]];
    return request;
}

/**
 * Static helper-method that generates a default URLRequest containing fields and values most commonly used
 * in other methods in the class.
 *
 *@param token - the authorization token to the server.
 *@return NSMutableURLRequest containing default values and fields.
 */
+ (NSMutableURLRequest*) getRequest:(NSString*) requestType withToken:(NSString*) token
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:requestType];
    [request setValue:0 forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    return request;
}

/**
 * Static method that returns the currently set server URL.
 *
 *@return NSString containing the server URL.
 */
+ (NSString*) getServerURL
{
    if(SERVER_URL == nil){
        SERVER_URL = [[NSUserDefaults standardUserDefaults] objectForKey:@"serverURL"];
    }
    return SERVER_URL;
}

/**
 * Static method that sets the server URL.
 * If the URL does not end with a '/', that character is added.
 *
 *@param url - the new server URL.
 */
+ (void) setServerURLToString: (NSString *) url
{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:url];
    if ([urlString characterAtIndex: urlString.length - 1] != '/') {
        [urlString appendString:@"/"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:urlString forKey:@"serverURL"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SERVER_URL = urlString;
}

@end
