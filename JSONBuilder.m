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
   
    
    NSError *error = nil;
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

+(NSMutableURLRequest*)getLogoutJSON:(NSString *)token
{
   
    NSMutableURLRequest *request = [self basicRequest:@"DELETE" withToken:token];
    [request setURL:[NSURL URLWithString:[[self getServerURL] stringByAppendingString:@"/login"]]];
    return request;
}


+(NSMutableURLRequest*) getSearchJSON:(NSArray*) annotations withToken:(NSString *) token
{
    NSString *annotationString = @"/search/annotations=?";
    NSMutableURLRequest *request =  [self basicRequest:@"GET" withToken:token];
    [request setURL:[NSURL URLWithString: [[self getServerURL] stringByAppendingString:annotationString]]];
    return request;
}

+(NSMutableURLRequest*)getConversionJSON:(NSString*)fileID withToken:(NSString *)token{
    NSString *conversionString = [@"/process/rawtoprofile/" stringByAppendingString:fileID];
    NSMutableURLRequest *request = [self basicRequest:@"PUT" withToken:token];
    [request setURL:[NSURL URLWithString: [[self getServerURL] stringByAppendingString:conversionString]]];
    return request;
}

+ (NSMutableURLRequest*) basicRequest:(NSString*) requestType withToken:(NSString*) token{
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
}

@end
