//
//  XYZExperimentFile.h
//  InLogger
//
//  Created by Patrik Nordström on 29/04/14.
//  Copyright (c) 2014 Patrik Nordström. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZExperimentFile : NSObject

typedef NS_ENUM(NSInteger, FileType) {
    RAW,
    PROFILE,
    REGION,
    OTHER
};

@property NSString *idFile;
@property FileType type;
@property NSString *name;
@property NSString *uploadedBy;
@property NSString *date;
@property NSString *size;
@property NSString *URL;

//+ (void) createExperimentFile:(NSDictionary*)file;

- (NSString *) getDescription;
- (NSComparisonResult) compareTo: (XYZExperimentFile *) experiment;
+ (FileType) NSStringFileTypeToEnumFileType: (NSString *) type;
+ (XYZExperimentFile *) defaultFileWithType: (FileType) type;

@end
