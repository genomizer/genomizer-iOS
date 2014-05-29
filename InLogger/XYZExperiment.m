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

/**
 * Initializes the experiment.
 *
 * @return
 */
- (XYZExperiment *) init
{
    self = [super init];
    _annotations = [[NSMutableDictionary alloc] init];
    _files = [[XYZFileContainer alloc] init];

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
    [_annotations setValue: value forKey:annotation];
}

/**
 * Returns the value for a given annotation.
 *
 * @return the value of the annotation
 */
- (NSString *) getValueForAnnotation: (NSString *) annotation
{
    return [_annotations valueForKey:annotation];
}

@end
