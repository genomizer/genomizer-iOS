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
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://genomizer.apiary-mock.com/login"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    return request;
}

+(NSMutableURLRequest*)getLogoutJSON:(NSString *)token
{
   
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://genomizer.apiary-mock.com/login"]];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:0 forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:token forHTTPHeaderField:@"Authorization"];
    return request;
}

+(NSMutableURLRequest*)getSearchJSON:(NSString *)annotations withToken:(NSString *)token
{
    NSString *adress = @"http://genomizer.apiary-mock.com/search/";
    NSString *completeAdress = [adress stringByAppendingString:annotations];

    NSLog(@"adress %@", completeAdress);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:completeAdress]];
    [request setHTTPMethod:@"GET"];
    [request setValue:0 forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:0 forHTTPHeaderField:@"Authorization"];
    return request;
    

}
@end
