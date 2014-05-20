//
//  XYZAnnotation.m
//  InLogger
//
//  Created by Joel Viklund on 14/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZAnnotation.h"

@implementation XYZAnnotation

static NSDictionary *ANNOTATION_DICTIONARY;

+ (NSDictionary *) initDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"Publication ID", @"pubmedId", @"Experiment ID", @"experimentID", @"File Name", @"fileName", @"Species", @"specie", nil];
}

-(BOOL) isFreeText
{
    return _possibleValues != nil && [_possibleValues count] == 1 && [[_possibleValues objectAtIndex:0] isEqualToString:@"freetext"];
}

- (NSString *) getFormatedName
{
    if (_name == nil) {
        return @"?";
    }
    
    if (ANNOTATION_DICTIONARY == nil) {
        ANNOTATION_DICTIONARY = [XYZAnnotation initDictionary];
    }

    NSString *text;
    text = ANNOTATION_DICTIONARY[_name];
    
    if (text == nil) {
        return [_name capitalizedString];
    } else {
        return text;
    }
}

- (BOOL) isEqual:(id)object
{
    if (![object isKindOfClass:[XYZAnnotation class]]) {
        return NO;
    }
    return [_name isEqualToString: ((XYZAnnotation *)object).name];
}

- (NSUInteger) hash
{
    return [_name hash];
}



@end
