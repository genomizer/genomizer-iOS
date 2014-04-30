//
//  XYZExperiment.m
//  InLogger
//
//  Created by Patrik Nordström on 29/04/14.
//  Copyright (c) 2014 Patrik Nordström. All rights reserved.
//

#import "XYZExperiment.h"
#import "XYZExperimentFile.h"


@interface XYZExperiment()


@end

@implementation XYZExperiment


- (XYZExperiment*) init
{
    self = [super init];
    _annotations = [[NSMutableDictionary alloc] init];
    return self;
}


+ (XYZExperiment*) defaultExperiment
{
    XYZExperiment *exp = [[XYZExperiment alloc] init];
    exp.name = @"Experiment name";
    exp.createdByUser = @"Yuri Yuri";
    [exp.annotations setValue: @"abc123" forKey:@"pubmedId"];
    [exp.annotations setValue: @"raw" forKey:@"type"];
    [exp.annotations setValue: @"specie" forKey:@"human"];
    return exp;
    
}

- (void) setValue: (id) value forAnnotation: (NSString*) annotation
{
    [_annotations setValue: value forKey:annotation];

}

- (NSString *) getValueForAnnotation: (NSString *) annotation
{
    return [_annotations valueForKey:annotation];
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
