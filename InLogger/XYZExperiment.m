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

- (XYZExperiment *) init
{
    self = [super init];
    _annotations = [[NSMutableDictionary alloc] init];
    _files = [[XYZFileContainer alloc] init];

    return self;
}

+ (XYZExperiment *) defaultExperiment
{
    XYZExperiment *exp = [[XYZExperiment alloc] init];
    exp.name = @"Experiment name";
    [exp.annotations setValue: @"abc123" forKey:@"pubmedId"];
    [exp.annotations setValue: @"raw" forKey:@"type"];
    [exp.annotations setValue: @"specie" forKey:@"human"];
    
    [exp.files addExperimentFile:[XYZExperimentFile defaultFileWithType:RAW]];
    [exp.files addExperimentFile:[XYZExperimentFile defaultFileWithType:RAW]];
    [exp.files addExperimentFile:[XYZExperimentFile defaultFileWithType:RAW]];

    [exp.files addExperimentFile:[XYZExperimentFile defaultFileWithType:PROFILE]];
    
    [exp.files addExperimentFile:[XYZExperimentFile defaultFileWithType:REGION]];
    [exp.files addExperimentFile:[XYZExperimentFile defaultFileWithType:REGION]];

    [exp.files addExperimentFile:[XYZExperimentFile defaultFileWithType:OTHER]];
        
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

@end
