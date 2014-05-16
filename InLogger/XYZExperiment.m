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

- (NSMutableArray *) arrayOfFileType: (FileType) fileType
{
    switch (fileType) {
        case RAW:
            return _rawFiles;
        case PROFILE:
            return _profileFiles;
        case REGION:
            return _regionFiles;
        default:
            return _otherFiles;
    }
}

- (void) addExperimentFile: (XYZExperimentFile *) file
{
    NSMutableArray *filesArray = [self arrayOfFileType:file.type];
    if (![filesArray containsObject:file]) {
        [filesArray addObject:file];
    }
}

- (void) removeExperimentFile: (XYZExperimentFile *) file
{
    [[self arrayOfFileType: file.type] removeObject:file];
}

- (NSInteger) numberOfFiles
{
    return [_rawFiles count] + [_profileFiles count] + [_regionFiles count] + [_otherFiles count];
}

- (NSMutableArray *) getSelectedFiles
{
    NSMutableArray *selectedFiles = [[NSMutableArray alloc] init];
    
    [selectedFiles addObjectsFromArray:[self getSelectedFiles:RAW]];
    [selectedFiles addObjectsFromArray:[self getSelectedFiles:PROFILE]];
    [selectedFiles addObjectsFromArray:[self getSelectedFiles:REGION]];
    [selectedFiles addObjectsFromArray:[self getSelectedFiles:OTHER]];
    
    return selectedFiles;
}

- (NSMutableArray *) getSelectedFiles: (FileType) fileType
{
    NSArray *files = [self arrayOfFileType:fileType];
    NSMutableArray *selectedFiles = [[NSMutableArray alloc] init];
    for (XYZExperimentFile *file in files) {
        if(file.selected) {
            [selectedFiles addObject:file];
        }
    }
    return selectedFiles;
}

@end
