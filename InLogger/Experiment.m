//
//  Experiment.m
//  Genomizer
//
//  The Experiment represents an experiment. It contains files
//  and annotation names and values.
//

#import "Experiment.h"

@implementation Experiment

/**
 * Designated initializer.
 *
 * @return
 */
- (instancetype)init
{
    if (self = [super init]) {
        self.annotations = [[NSMutableDictionary alloc] init];
        self.files = [[FileContainer alloc] init];
    }
    return self;
}

/**
 * Sets the value for the given annotation.
 *
 * @param value - the value for the annotation
 * @param annotation - the annotation for which the value should be set
 */
- (void)setValue:(id)value forAnnotation:(NSString*)annotation
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
