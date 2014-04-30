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
@property NSMutableArray *files;
@property NSMutableDictionary *annotations;

- (void) setValue: (id) value forAnnotation: (NSString*) annotation;
- (NSString *) getValueForAnnotation: (NSString *) annotation;
+ (XYZExperiment*) defaultExperiment;

@end
