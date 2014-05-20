//
//  XYZFileContainer.m
//  Genomizer
//
//  Created by Joel Viklund on 19/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZFileContainer.h"

@interface XYZFileContainer()

@property NSMutableArray *rawFiles;
@property NSMutableArray *profileFiles;
@property NSMutableArray *regionFiles;
@property NSMutableArray *otherFiles;

@end

@implementation XYZFileContainer

- (XYZFileContainer *) init
{
    self = [super init];

    _rawFiles = [[NSMutableArray alloc] init];
    _profileFiles = [[NSMutableArray alloc] init];
    _regionFiles = [[NSMutableArray alloc] init];
    _otherFiles = [[NSMutableArray alloc] init];

    return self;
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

- (NSInteger) numberOfFilesWithType: (FileType) fileType
{
    return [[self arrayOfFileType:fileType] count];
}

- (BOOL) containsFile: (XYZExperimentFile *) file
{
    return [[self arrayOfFileType:file.type] containsObject:file];
}

- (NSMutableArray *) getFiles
{
    NSMutableArray *files = [[NSMutableArray alloc] init];
    
    [files addObjectsFromArray:[self getFiles:RAW]];
    [files addObjectsFromArray:[self getFiles:PROFILE]];
    [files addObjectsFromArray:[self getFiles:REGION]];
    [files addObjectsFromArray:[self getFiles:OTHER]];
    
    return files;
}

- (NSMutableArray *) getFiles: (FileType) fileType
{
    return [self arrayOfFileType:fileType];
}

@end
