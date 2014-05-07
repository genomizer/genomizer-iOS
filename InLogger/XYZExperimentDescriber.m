//
//  XYZExperimentDescriber.m
//  InLogger
//
//  Created by Joel Viklund on 30/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZExperimentDescriber.h"

@interface XYZExperimentDescriber()

@property NSMutableArray *annotations;

@end

@implementation XYZExperimentDescriber

static NSDictionary *ANNOTATION_DICTIONARY;

+ (NSDictionary *) initDictionary
{
    //return [NSDictionary dictionaryWithObjectsAndKeys:@"pubmedId", @"Publication ID", @"experimentID", @"Experiment ID", @"fileName", @"File Name", nil];
    return [NSDictionary dictionaryWithObjectsAndKeys:@"Publication ID", @"pubmedId", @"Experiment ID", @"experimentID", @"File Name", @"fileName", @"Species", @"specie", nil];
}

- (XYZExperimentDescriber *) init
{
    self = [super init];
    _annotations = [[NSMutableArray alloc] init];
    return self;
}

- (void) addAnnotation: (NSString *) annotation
{
    if( ![_annotations containsObject:annotation]) {
        [_annotations addObject:annotation];
    }
}

- (void) removeAnnotation: (NSString *) annotation
{
    [_annotations removeObject:annotation];
}

- (BOOL) containsAnnotation: (NSString *) annotation {
    return [_annotations containsObject:annotation];
}

- (NSString *) getDescriptionOf: (XYZExperiment*) experiment
{
    NSMutableString *description = [[NSMutableString alloc] init];
    
    [description appendString: [self createRowForAnnotation:@"Name" withValue:experiment.name andNewLine:YES]];
    [description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:YES]];
    [description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:NO]];
    [description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:NO]];
    [description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:NO]];
    [description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:NO]];
    [description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:NO]];
    [description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:NO]];
    [description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:NO]];
    [description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:NO]];
    [description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:YES]];[description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:YES]];[description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:YES]];[description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:YES]];[description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:YES]];[description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:YES]];[description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:YES]];[description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:YES]];[description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:YES]];[description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:YES]];[description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:YES]];[description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:YES]];[description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:YES]];[description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:YES]];[description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:YES]];[description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:YES]];[description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:YES]];[description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:YES]];
        [description appendString: @"End of string"];
    
     
    //[description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:[_annotations count] > 0]];
    /*
     for (NSInteger i = 0; i < [_annotations count]; i++) {
        [description appendString: [self createRowForAnnotation:_annotations[i]
                                                     withValue:[experiment getValueForAnnotation:[_annotations objectAtIndex:i]]
                                                     andNewLine:i != [_annotations count] -1]];
    }
    */
    return description;
}

- (NSString *) createRowForAnnotation: (NSString *) annotation withValue: (NSString *) value andNewLine: (BOOL) newLine
{
    NSMutableString *description = [[NSMutableString alloc] init];
    [description appendString: [XYZExperimentDescriber formatAnnotation: annotation]];
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

+ (NSString *) formatAnnotation : (NSString *) annotation
{
    if (ANNOTATION_DICTIONARY == nil) {
        ANNOTATION_DICTIONARY = [XYZExperimentDescriber initDictionary];
    }
    NSString *text = [ANNOTATION_DICTIONARY valueForKey:annotation];
    
    if (text == nil) {
        return [annotation capitalizedString];
    } else {
        return text;
    }
}

@end
