//
//  Annotation.m
//  Genomizer
//
// The Annotation represents an annotation. It contains fields such as
// name, possible values and the current value. The annotation is identified
// by its name.
//

#import "Annotation.h"

@implementation Annotation

static NSDictionary *ANNOTATION_DICTIONARY;

/**
 * Initialiizes a dictionary which maps annotation names with more readable names.
 * @return the dictionary
 */
+ (NSDictionary *) initDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"Publication ID", @"pubmedId", @"Experiment ID", @"experimentID", @"File Name", @"fileName", @"Species", @"specie", nil];
}

/**
 * Returns YES if the annotation value is free text, NO otherwise.
 *
 * @return YES if the annotation value is free text, NO otherwise
 */
-(BOOL) isFreeText
{
    return _possibleValues != nil && [_possibleValues count] == 1 && [[_possibleValues objectAtIndex:0] isEqualToString:@"freetext"];
}

/**
 * Returns the formated name of the annotation. If the ANNOTATION_DICTIONARY
 * contains a format mapping it will be used. Otherwise the first letter of
 * the name will be capitalized.
 *
 * @return the formated name of the annotation
 */
- (NSString *) getFormatedName
{
    if (_name == nil) {
        return @"?";
    }
    
    if (ANNOTATION_DICTIONARY == nil) {
        ANNOTATION_DICTIONARY = [Annotation initDictionary];
    }

    NSString *text;
    text = ANNOTATION_DICTIONARY[_name];
    
    if (text == nil) {
        return [_name capitalizedString];
    } else {
        return text;
    }
}

/**
 * Returns YES if the arguments are equal to each other and NO otherwise.
 * Two annotations with the same name are considered equal.
 *
 * @param object - the object to compare with
 *
 * @return YES if the arguments are equal to each other and NO otherwise.
 */
- (BOOL) isEqual:(id)object
{
    if (![object isKindOfClass:[Annotation class]]) {
        return NO;
    }
    return [_name isEqualToString: ((Annotation *)object).name];
}

/**
 * Generates a hash code based on the unique name.
 *
 * @return the hash code
 */
- (NSUInteger) hash
{
    return [_name hash];
}

@end
