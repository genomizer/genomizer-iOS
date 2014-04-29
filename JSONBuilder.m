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
   
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[[self getServerURL] stringByAppendingString:@"/login"]]];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:0 forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:token forHTTPHeaderField:@"Authorization"];
    return request;
}


+(NSMutableURLRequest*) getSearchJSON:(NSArray*) annotations withToken:(NSString *) token
{
    NSString *annotationString = @"/search/annotations=?";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: [[self getServerURL] stringByAppendingString:annotationString]]];
    [request setHTTPMethod:@"GET"];
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
