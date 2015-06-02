//
//  ExperimentDescriber.h
//  Genomizer
//
//  The ExperimentDescriber describes experiments. It keeps track of which
//  annotations to display.
//

#import <Foundation/Foundation.h>
#import "Experiment.h"
#import "Annotation.h"

@interface ExperimentDescriber : NSObject

@property NSArray *annotations;

- (instancetype) initWithAnnotations: (NSArray *) annotations;
- (void) showAnnotation: (Annotation *) annotation;
- (void) hideAnnotation: (Annotation *) annotation;
- (NSString *) getDescriptionOf: (Experiment*) experiment;
- (BOOL) showsAnnotation: (Annotation *) annotation;
- (NSArray *)getVisibleAnnotations;
//- (void)setVisibleAnnotations:(NSArray *)array;
- (void) saveAnnotationsToFile;

@end
