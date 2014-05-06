//
//  XYZExperimentFile.m
//  InLogger
//
//  Created by Patrik Nordström on 29/04/14.
//  Copyright (c) 2014 Patrik Nordström. All rights reserved.
//

#import "XYZExperimentFile.h"

@implementation XYZExperimentFile

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
    [string appendString: [self format: _name]];
    [string appendString:@"  "];
    [string appendString: [self format: _date]];
    [string appendString:@"  "];
    [string appendString: [self format: _uploadedBy]];
    return string;
}

- (NSString *) format: (NSString *) string
{
    if (string == nil) {
        return @"?";
    } else {
        return string;
    }
}


+ (FileType) NSStringFileTypeToEnumFileType: (NSString *) type
{
    type = [type lowercaseString];
    if ([type isEqualToString:@"raw"]) {
        return RAW;
    } else if ([type isEqualToString:@"region"]) {
        return REGION;
    } else if ([type isEqualToString:@"profile"]) {
        return PROFILE;
    } else {
        return OTHER;
    }
}

@end

