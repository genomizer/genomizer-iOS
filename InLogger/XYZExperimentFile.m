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
    [string appendString: [self fillWithSpaces:string untilLength:14]];
    [string appendString: [self format: _date]];
    [string appendString: [self fillWithSpaces:string untilLength:26]];
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

