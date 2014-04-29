//
//  JSONBuilder.m
//  InLogger
//
//  Created by Patrik Nordström on 28/04/14.
//  Copyright (c) 2014 Patrik Nordström. All rights reserved.
//

#import "JSONBuilder.h"



@implementation JSONBuilder


+(NSMutableURLRequest*)getLoginJSON:(NSString *)username withPassword:(NSString *)password toURL:(NSString *)URL
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:password forKey:@"password"];
    [dict setValue:username forKey:@"username"];
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:nil];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[URL stringByAppendingString:@"/login"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    return request;
}

+(NSMutableURLRequest*) getSearchJSON:(NSArray*) annotations toURL:(NSString *)URL withAuthorization: (NSString *) token
{
    NSString *annotationString = @"/search/annotations=?";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: [URL stringByAppendingString:annotationString]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:0 forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    return request;
}


@end
