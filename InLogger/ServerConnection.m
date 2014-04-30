//
//  ServerConnection.m
//  InLogger
//
//  Created by Linus Öberg on 28/04/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import "ServerConnection.h"
#import "JSONBuilder.h"
#import "XYZExperiment.h"
#import "XYZExperimentFile.h"


@implementation ServerConnection
NSString *token;

+ (int)login:(NSString *)username withPassword:(NSString *)password
{
    NSMutableURLRequest *request = [JSONBuilder getLoginJSON:username withPassword:password];
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:POSTReply options:kNilOptions error:nil];

    token = [json objectForKey:@"token"];
    NSLog(@"req %@", token);
    NSLog(@"Header: %ld", (long)httpResp.statusCode);
  
    return httpResp.statusCode;
}

+ (int)logout
{
    NSMutableURLRequest *request = [JSONBuilder getLogoutJSON:token];
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:POSTReply options:kNilOptions error:nil];
    
  //  token = [json objectForKey:@"token"];
    NSLog(@"req %@", json);
    NSLog(@"Header: %ld", (long)httpResp.statusCode);
    
    return httpResp.statusCode;
}

 
+(NSDictionary*)search:(NSArray*)annotations
{
    //create send request
    NSMutableURLRequest *request = [JSONBuilder getSearchJSON:annotations withToken: token];
    NSURLResponse *response;
    
    //recieve answer
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:POSTReply options: NSJSONReadingMutableContainers error:nil];
  
    XYZExperiment *exp = [[XYZExperiment alloc] init];
    exp.experimentName = [json valueForKey:@"name"];
    exp.createdByUser = [json valueForKey:@"created by"];
    NSLog(@"search names %@", [json valueForKey:@"name"]);
    NSArray *annotationsArray = [[json valueForKey:@"annotations"]objectAtIndex:0];
    NSLog(@"search names %@", annotationsArray);
    NSLog(@"search names %@", [json valueForKey:@"created by"]);
    
    
    
    NSArray *filesArray = [[json valueForKey:@"files"]objectAtIndex:0];
    for(NSDictionary *file in filesArray){
        XYZExperimentFile *expFile = [[XYZExperimentFile alloc] init];
        expFile.idFile = [file valueForKey:@"id"];
        expFile.type = [file valueForKey:@"type"];
        expFile.name = [file valueForKey:@"name"];
        expFile.uploadedBy = [file valueForKey:@"uploadedBy"];
        expFile.date = [file valueForKey:@"date"];
        expFile.size = [file valueForKey:@"size"];
        expFile.URL = [file valueForKey:@"URL"];
        [exp.files addObject:expFile];
    }
    
    return json;
}


@end
