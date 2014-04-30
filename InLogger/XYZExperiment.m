//
//  XYZExperiment.m
//  InLogger
//
//  Created by Patrik Nordström on 29/04/14.
//  Copyright (c) 2014 Patrik Nordström. All rights reserved.
//

#import "XYZExperiment.h"


@interface XYZExperiment()


@end

@implementation XYZExperiment

- (XYZExperiment *) init
{
    self = [super init];
    _annotations = [[NSDictionary alloc] init];
    NSLog(@"INIT");
    return self;
}


+ (XYZExperiment*) defaultExperiment
{
    XYZExperiment *exp = [[XYZExperiment alloc] init];
    exp.name = @"Experiment name";
    exp.createdByUser = @"Yuri Yuri";
    [exp setValue:@"abc123" forAnnotation:@"pubmedId"];
    NSString *key = @"type";
    [exp setValue: @"raw" forAnnotation:key];
    [exp setValue: @"human" forAnnotation:@"specie"];
    NSLog(@"TEST:");
    
    NSEnumerator *enumerator = [exp.annotations keyEnumerator];
    id key2;
    while ((key2 = [enumerator nextObject])){
        NSLog(@"%@", [exp.annotations objectForKey: key2]);
    }
    
    NSLog(@"%@", [exp.annotations valueForKey:key]);
    return exp;
    
}

- (void) setValue: (id) value forAnnotation: (NSString*) annotation
{
    [_annotations setValue: value forKey:annotation];

}

- (NSString *) getValueForAnnotation: (NSString *) annotation
{
    NSLog(@"go");

    NSLog(annotation);
    NSString *asd = [_annotations valueForKey:annotation];
    NSLog(asd);
    NSLog(@"done");
    return asd;
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
