//
//  Experiment.h
//  Genomizer
//

//

#import "ExperimentFile.h"
#import "FileContainer.h"


/**
 The Experiment represents an experiment. It contains files
 and annotation names and values.
 */
@interface Experiment : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *createdByUser;
@property (nonatomic, strong) FileContainer *files;
@property (nonatomic, strong) NSMutableDictionary *annotations;

- (void) setValue: (id)value forAnnotation: (NSString*) annotation;
- (NSString *) getValueForAnnotation: (NSString *) annotation;

@end
