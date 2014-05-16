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

+ (BOOL) ambigousFileTypes: (NSArray *) files
{
    if ([files count] == 0) {
        return NO;
    }
    FileType type = ((XYZExperimentFile *)files[0]).type;
    
    for (XYZExperimentFile *file in files) {
        if (file.type != type) {
            return YES;
        }
    }
    
    return NO;
}

- (NSString *) getDescription
{
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString: [self format: _name]];
    return string;
}

- (NSString *) getAllInfo{
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString: @"Filename: "];
    [string appendString: [self format: _name]];
    [string appendString: @"\n"];
    [string appendString: @"Date: "];
    [string appendString: [self format: _date]];
    [string appendString: @"\n"];
    [string appendString: @"Uploaded by: "];
    [string appendString: [self format: _uploadedBy]];
    [string appendString: @"\n"];
    [string appendString: @"Name: "];
    [string appendString: [self format: _name]];
    [string appendString: @"\n"];
    [string appendString: @"size: "];
    [string appendString: [self format: _size]];
    [string appendString: @"\n"];
    [string appendString: @"URL: "];
    [string appendString: [self format: _URL]];
    [string appendString: @"\n"];
    [string appendString: @"Exp ID: "];
    [string appendString: [self format: _expID]];
    [string appendString: @"\n"];
    [string appendString: @"Metadata: "];
    [string appendString: [self format: _metaData]];
    [string appendString: @"\n"];
    [string appendString: @"Author: "];
    [string appendString: [self format: _author]];
    [string appendString: @"\n"];
    [string appendString: @"GrVersion: "];
    [string appendString: [self format: _grVersion]];
    [string appendString: @"\n"];
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

- (NSString *) fillWithSpaces: (NSString *) string untilLength: (int) length
{
    NSMutableString *result = [[NSMutableString alloc] init];
    int numOfSpaces = length - [string length];
    if(numOfSpaces <= 0) {
        numOfSpaces = 2;
    }
    for(int i = 0; i < numOfSpaces; i++) {
        [result appendString: @" "];
    }
    return result;
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

