//
//  Experiment.h
//  Genomizer
//
//  The Experiment represents an experiment. It contains files
//  and annotation names and values.
//

#import "ExperimentFile.h"
#import "FileContainer.h"

@interface Experiment : NSObject

@property NSString *name;
@property NSString *createdByUser;
@property FileContainer *files;
@property NSMutableDictionary *annotations;

- (void) setValue: (id) value forAnnotation: (NSString*) annotation;
- (NSString *) getValueForAnnotation: (NSString *) annotation;

@end
