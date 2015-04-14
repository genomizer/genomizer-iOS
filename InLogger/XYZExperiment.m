//
//  XYZExperiment.m
//  Genomizer
//
//  The XYZExperiment represents an experiment. It contains files
//  and annotation names and values.
//

#import "XYZExperiment.h"
#import "XYZExperimentFile.h"

@implementation XYZExperiment

@synthesize createdByUser, name, files, annotations;
/**
 * Initializes the experiment.
 *
 * @return
 */
- (XYZExperiment *) init
{
    self = [super init];
    self.annotations = [[NSMutableDictionary alloc] init];
    self.files = [[XYZFileContainer alloc] init];

    return self;
}

/**
 * Sets the value for the given annotation.
 *
 * @param value - the value for the annotation
 * @param annotation - the annotation for which the value should be set
 */
- (void) setValue: (id) value forAnnotation: (NSString*) annotation
{
    [self.annotations setValue: value forKey:annotation];
}

/**
 * Returns the value for a given annotation.
 *
 * @return the value of the annotation
 */
- (NSString *) getValueForAnnotation: (NSString *) annotation
{
    return [self.annotations valueForKey:annotation];
}

@end
