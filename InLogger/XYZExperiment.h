//
//  XYZExperiment.h
//  InLogger
//
//  Created by Patrik Nordström on 29/04/14.
//  Copyright (c) 2014 Patrik Nordström. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZExperiment : NSObject

@property NSString *name;
@property NSString *createdByUser;
@property NSArray *files;
@property NSDictionary *annotations;

- (XYZExperiment*) init:NSArray;
- (void) setValue: (id) value forAnnotation: (NSString*) annotation;
+ (XYZExperiment*) defaultExperiment;

@end
