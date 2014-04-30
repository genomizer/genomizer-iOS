//
//  XYZExperimentFile.m
//  InLogger
//
//  Created by Patrik Nordström on 29/04/14.
//  Copyright (c) 2014 Patrik Nordström. All rights reserved.
//

#import "XYZExperimentFile.h"

@implementation XYZExperimentFile
/*
+ (void) createExperimentFile:(NSDictionary*)file{
    
    idFile = [file valueForKey:@"id"];
    type = [file valueForKey:@"type"];
    name = [file valueForKey:@"name"];
    uploadedBy = [file valueForKey:@"uploadedBy"];
    date = [file valueForKey:@"date"];
    size = [file valueForKey:@"size"];
    URL = [file valueForKey:@"URL"];
    
}
*/

+ (XYZExperimentFile *) defaultFileWithType: (FileType) type
{
    XYZExperimentFile *defaultFile = [[XYZExperimentFile alloc] init];
    defaultFile.name = @"Datafile.wig";
    defaultFile.date = @"2014-04-01";
    defaultFile.uploadedBy = @"Yuri";
    defaultFile.type = type;
    
    return defaultFile;
}


- (NSString *) getDescription
{
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString: _name];
    [string appendString:@"  "];
    [string appendString: _date];
    [string appendString:@"  "];
    [string appendString: _uploadedBy];
    return string;
}

- (NSComparisonResult) compareTo: (XYZExperimentFile *) experiment;
{
    if (_type == experiment.type) {
        return (NSComparisonResult)NSOrderedSame;
    } else if (_type == RAW || experiment.type == REGION){
        return (NSComparisonResult)NSOrderedAscending;
    } else if (experiment.type == RAW || _type == REGION) {
        return (NSComparisonResult)NSOrderedDescending;
    } else {
        return (NSComparisonResult)NSOrderedSame;
    }
}


+ (FileType) NSStringFileTypeToEnumFileType: (NSString *) type
{
    if ([type compare:@"raw"]) {
        return RAW;
    } else if ([type compare:@"region"]) {
        return REGION;
    } else if ([type compare:@"profile"]) {
        return PROFILE;
    } else {
        return OTHER;
    }
}

@end

