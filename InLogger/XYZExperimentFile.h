//
//  XYZExperimentFile.h
//  InLogger
//
//  Created by Patrik Nordström on 29/04/14.
//  Copyright (c) 2014 Patrik Nordström. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZExperimentFile : NSObject
@property NSString *idFile;
@property NSString *type;
@property NSString *name;
@property NSString *uploadedBy;
@property NSString *date;
@property NSString *size;
@property NSString *URL;

//+ (void) createExperimentFile:(NSDictionary*)file;

@end
