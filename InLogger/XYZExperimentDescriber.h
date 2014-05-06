//
//  XYZExperimentDescriber.h
//  InLogger
//
//  Created by Joel Viklund on 30/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYZExperiment.h"

@interface XYZExperimentDescriber : NSObject

- (void) addAnnotation: (NSString *) annotation;
- (void) removeAnnotation: (NSString *) annotation;
- (NSString *) getDescriptionOf: (XYZExperiment*) experiment;
- (BOOL) containsAnnotation: (NSString *) annotation;
+ (NSString *) formatAnnotation : (NSString *) annotation;

@end
