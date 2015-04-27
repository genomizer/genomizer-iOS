//
//  ExperimentDescriber.m
//  Genomizer
//
//  The ExperimentDescriber describes experiments. It keeps track of which
//  annotations to display.
//

#import "ExperimentDescriber.h"
#import "FileHandler.h"
#define FILE_NAME @"annotations.asd"
#define DELIMITER @","

@interface ExperimentDescriber()

@property NSMutableArray *visibleAnnotations;

@end

@implementation ExperimentDescriber


-(id)init{
    if(self = [super init]){
        _visibleAnnotations = [[NSMutableArray alloc] init];
    }
    return self;
}
/**
 * Initializes an ExperimentDescriber that displays
 * the given annotations.
 * 
 * @param annotations - the annotations to display
 */
- (id) initWithAnnotations: (NSArray *) annotations
{
    if(self = [super init]){
        _annotations = annotations;
        _visibleAnnotations = [self loadAnnotationsFromFile];
        
    }
    return self;
}

/**
 * Adds the given annotation to the list of annotations to display.
 *
 * @param annotation - the annotation to display
 */
- (void) showAnnotation: (Annotation *) annotation
{
    if(![_visibleAnnotations containsObject:annotation]) {
        [_visibleAnnotations addObject:annotation];
    }
}

/**
 * Removes the given annotation from the list of annotations to display.
 *
 * @param annotation - the annotation to hide
 */
- (void) hideAnnotation: (Annotation *) annotation
{
    [_visibleAnnotations removeObject:annotation];
}


/**
 * Returns true if the annotation is to display, false otherwise.
 *
 * @param annotation - the annotation
 * @return true if the annotation is to display
 */
- (BOOL) showsAnnotation: (Annotation *) annotation {
    return [_visibleAnnotations containsObject:annotation];
}

/**
 * Returns a description of the given experiment. Each annotation
 * is separeted by a new line, and the annotation names are formated
 * to look nice.
 *
 * @param experiment - the experiment
 * @return a description of the experiment
 */
- (NSString *) getDescriptionOf: (Experiment*) experiment
{
    NSMutableString *description = [[NSMutableString alloc] init];
    
    [description appendString: [self createRowForAnnotation:@"Name" withValue:experiment.name andNewLine:true]];
    [description appendString:[self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:[_visibleAnnotations count] > 0]];
//    for(NSString *key in experiment.annotations){
//        NSLog(@"key: %@, value: %@", key, experiment.annotations[key]);
//    }
     for (NSInteger i = 0; i < [_visibleAnnotations count]; i++) {
         Annotation *annotation = _visibleAnnotations[i];
         NSString *newString = [self createRowForAnnotation:[annotation getFormatedName]
                                                  withValue:[experiment getValueForAnnotation:annotation.name]
                                                 andNewLine:i != [_visibleAnnotations count] -1];
         NSLog(@"NEW STRING: %@", newString);
        [description appendString: newString];
    }
    
    return description;
}

/**
 * Formats the given annotation name and appends the given value to it.
 *
 * @param annotation - the annotation name
 * @param withValue - the annotation value
 * @param newLine - determines if a newline should be appended
 *
 */
- (NSString *) createRowForAnnotation: (NSString *) annotation withValue: (NSString *) value andNewLine: (BOOL) newLine
{
    NSMutableString *description = [[NSMutableString alloc] init];
    [description appendString: annotation];
    [description appendString: @": "];
    if(![value isKindOfClass:[NSString class]]) {
        [description appendString:@"?"];
    } else {
        [description appendString:value];
    }
    if(newLine) {
        [description appendString:@"\n"];
    }
    return description;
}

/**
 * Saves the list with annotations to display to a text file.
 * The name of the value is defined as FILE_NAME.
 *
 *
 */
- (void) saveAnnotationsToFile
{
    NSMutableString *data = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < _visibleAnnotations.count; i++) {
        Annotation *annotation = _visibleAnnotations[i];
        [data appendString: annotation.name];
        if (i < _visibleAnnotations.count - 1) {
            [data appendString: DELIMITER];
        }
    }
    [FileHandler writeData: data toFile:FILE_NAME];
}

/**
 * Reads a text file and generates a list of annotations to display.
 *
 */
- (NSMutableArray *) loadAnnotationsFromFile
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSString *data = [FileHandler readFromFile:FILE_NAME withDefaultData:@""];
    if ([data isEqualToString:@""]) {
        return result;
    }
    NSArray *seperated = [data componentsSeparatedByString:DELIMITER];

    for (NSString *name in seperated) {
        for (Annotation *annotation in _annotations) {
            if ([annotation.name isEqualToString:name]) {
                [result addObject:annotation];
                break;
            }
        }
    }
    
    return result;
}

@end
