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
    _rawFiles = [[NSMutableArray alloc] init];
    _profileFiles = [[NSMutableArray alloc] init];
    _regionFiles = [[NSMutableArray alloc] init];
    _otherFiles = [[NSMutableArray alloc] init];

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
    
    [exp addExperimentFile:[XYZExperimentFile defaultFileWithType:RAW]];
    [exp addExperimentFile:[XYZExperimentFile defaultFileWithType:RAW]];
    [exp addExperimentFile:[XYZExperimentFile defaultFileWithType:RAW]];

    [exp addExperimentFile:[XYZExperimentFile defaultFileWithType:PROFILE]];
    
    [exp addExperimentFile:[XYZExperimentFile defaultFileWithType:REGION]];
    [exp addExperimentFile:[XYZExperimentFile defaultFileWithType:REGION]];

    [exp addExperimentFile:[XYZExperimentFile defaultFileWithType:OTHER]];
    
    NSLog(@"Number: %d", [exp numberOfFiles]);
    
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

- (void) addExperimentFile: (XYZExperimentFile *) file
{
    if (file.type == RAW) {
        [_rawFiles addObject:file];
    } else if (file.type == REGION) {
        [_regionFiles addObject:file];
    } else if (file.type == PROFILE) {
        [_profileFiles addObject:file];
    } else {
        [_otherFiles addObject:file];
    }
}

- (NSInteger) numberOfFiles
{
    return [_rawFiles count] + [_profileFiles count] + [_regionFiles count] + [_otherFiles count];
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
