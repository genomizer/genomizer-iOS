//
//  XYZExperiment.h
//  Genomizer
//
//  The XYZExperiment represents an experiment. It contains files
//  and annotation names and values.
//

#import "XYZExperimentFile.h"
#import "XYZFileContainer.h"

@interface XYZExperiment : NSObject

@property NSString *name;
@property NSString *createdByUser;
@property XYZFileContainer *files;
@property NSMutableDictionary *annotations;

- (void) setValue: (id) value forAnnotation: (NSString*) annotation;
- (NSString *) getValueForAnnotation: (NSString *) annotation;

@end
