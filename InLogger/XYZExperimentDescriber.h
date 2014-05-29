//
//  XYZExperimentDescriber.h
//  Genomizer
//
//  The ExperimentDescriber describes experiments. It keeps track of which
//  annotations to display.
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
