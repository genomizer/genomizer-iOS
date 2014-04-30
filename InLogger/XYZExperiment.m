//
//  XYZExperiment.m
//  InLogger
//
//  Created by Patrik Nordström on 29/04/14.
//  Copyright (c) 2014 Patrik Nordström. All rights reserved.
//

#import "XYZExperiment.h"
#import "XYZExperimentFile.h"

@implementation XYZExperiment


- (XYZExperiment*) init:NSArray{
    self = [super init];
    return self;
}


+ (void) createExperiment:(NSDictionary*)json{

    
}

//:::::::::: SAFE, IGNORE :::::::::
/*
 NSArray *json = [NSJSONSerialization JSONObjectWithData:POSTReply options:0 error:&rr];
 NSLog(@"mrMan: %@", rr);
 NSLog(@"%d", [POSTReply length]);
 
 for(NSString *a in json){
 NSLog(@"lol: %@", a);
 }
 
 NSMutableArray *arrayOfResults = [[NSMutableArray alloc] init];
 
 NSLog(@"Header: %ld", (long)httpResp.statusCode);
 for (NSString *b in json){
 [arrayOfResults addObject:b];
 }
 NSLog(@"test%@", [json valueForKey:@"URL"]);
 return json;*/
//NSLog(@"%@", [jsonDataArray ]);

@end
