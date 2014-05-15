//
//  JSONBuilder.m
//  InLogger
//
//  Created by Linus Öberg on 29/04/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import "JSONBuilder.h"

@implementation JSONBuilder


+(NSMutableURLRequest*)getLoginJSON:(NSString *)username withPassword:(NSString *)password
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:password forKey:@"password"];
    [dict setValue:username forKey:@"username"];
   
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[[self getServerURL] stringByAppendingString:@"/login"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    return request;
}

- (void) asd {
    
}

+(NSMutableURLRequest*)getLogoutJSON:(NSString *)token
{
    NSMutableURLRequest *request = [self getRequest:@"DELETE" withToken:token];
    [request setURL:[NSURL URLWithString:[[self getServerURL] stringByAppendingString:@"/login"]]];
    return request;
}

+(NSMutableURLRequest*) getSearchJSON:(NSString*) annotations withToken:(NSString *) token
{
    NSString *annotationString = @"/search/?annotations=";
    NSString *annotationsStringComplete = [annotationString stringByAppendingString:annotations];
    NSString *encodedAnnotations = [annotationsStringComplete stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"hej %@",annotationsStringComplete);
    NSMutableURLRequest *request =  [self getRequest:@"GET" withToken:token];
    [request setURL:[NSURL URLWithString: [[self getServerURL] stringByAppendingString:encodedAnnotations]]];   
    return request;
}

+(NSMutableURLRequest*)getRawToProfileJSON:(NSString *)token withDict:(NSMutableDictionary*)dict{
    
        NSError *error;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:dict
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        NSString *conversionString =@"/process";
        NSMutableURLRequest *request = [self getRequest:@"PUT" withToken:token];
        [request setHTTPBody:postData];
        [request setURL:[NSURL URLWithString: [[self getServerURL] stringByAppendingString:conversionString]]];
        
        return request;
    
}

+(NSMutableURLRequest*)getAvailableAnnotationsJSON:(NSString *) token
{
    NSMutableURLRequest *request = [self getRequest:@"GET" withToken:token];
    [request setURL:[NSURL URLWithString: [[self getServerURL] stringByAppendingString: @"/annotation"]]];
    
    return request;
}

+ (NSMutableURLRequest*) getRequest:(NSString*) requestType withToken:(NSString*) token
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:requestType];
    [request setValue:0 forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    return request;
}
                                  
+ (NSString*) getServerURL
{
    return @"http://genomizer.apiary-mock.com";
    //return @"http://scratchy.cs.umu.se:7000";
}

@end
