//
//  XYZExperimentDescriber.h
//  InLogger
//
//  Created by Joel Viklund on 30/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYZExperiment.h"
#import "XYZAnnotation.h"

@interface XYZExperimentDescriber : NSObject

- (void) addAnnotation: (XYZAnnotation *) annotation;
- (void) removeAnnotation: (XYZAnnotation *) annotation;
- (NSString *) getDescriptionOf: (XYZExperiment*) experiment;
- (BOOL) containsAnnotation: (XYZAnnotation *) annotation;

@end
