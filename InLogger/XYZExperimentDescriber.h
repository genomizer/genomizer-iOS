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

@property NSArray *annotations;

- (XYZExperimentDescriber *) initWithAnnotations: (NSArray *) annotations;
- (void) showAnnotation: (XYZAnnotation *) annotation;
- (void) hideAnnotation: (XYZAnnotation *) annotation;
- (NSString *) getDescriptionOf: (XYZExperiment*) experiment;
- (BOOL) showsAnnotation: (XYZAnnotation *) annotation;
- (void) saveAnnotationsToFile;

@end
