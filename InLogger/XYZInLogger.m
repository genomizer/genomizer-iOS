//
//  XYZInLogger.m
//  InLogger
//
//  Created by Joel Viklund on 25/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZInLogger.h"

@implementation XYZInLogger
id token;
+ (int)login:(NSString *)username withPassword:(NSString *)password
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
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:POSTReply options:kNilOptions error:&error];
    

    token = [json objectForKey:@"token"];
    NSLog(@"req %@", [json objectForKey:@"token"]);
    NSLog(@"req %@", dict);
    NSLog(@"Header: %ld", (long)httpResp.statusCode);
    
    return httpResp.statusCode;

}



@end
