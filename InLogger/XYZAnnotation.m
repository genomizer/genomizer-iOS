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
    return _values != nil && [_values count] == 1 && [[_values objectAtIndex:0] isEqualToString:@"freetext"];
}

- (NSString *) getFormatedName
{
    if (_name == nil) {
        return @"?";
    }
    
    if (ANNOTATION_DICTIONARY == nil) {
        ANNOTATION_DICTIONARY = [XYZAnnotation initDictionary];
    }
    NSString *text = [ANNOTATION_DICTIONARY valueForKey:_name];
    
    if (text == nil) {
        return [_name capitalizedString];
    } else {
        return text;
    }
}

@end
