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


- (XYZExperimentDescriber *) init
{
    self = [super init];
    _annotations = [[NSMutableArray alloc] init];
    return self;
}

- (void) addAnnotation: (XYZAnnotation *) annotation
{
    if( ![_annotations containsObject:annotation]) {
        [_annotations addObject:annotation];
    }
}

- (void) removeAnnotation: (XYZAnnotation *) annotation
{
    [_annotations removeObject:annotation];
}

- (BOOL) containsAnnotation: (XYZAnnotation *) annotation {
    return [_annotations containsObject:annotation];
}

- (NSString *) getDescriptionOf: (XYZExperiment*) experiment
{
    NSMutableString *description = [[NSMutableString alloc] init];
    
    [description appendString: [self createRowForAnnotation:@"Name" withValue:experiment.name andNewLine:YES]];
    [description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:[_annotations count] > 0]];
    
     for (NSInteger i = 0; i < [_annotations count]; i++) {
         XYZAnnotation *annotation = _annotations[i];
        [description appendString: [self createRowForAnnotation:[annotation getFormatedName]
                                                     withValue:[experiment getValueForAnnotation:annotation.name]
                                                     andNewLine:i != [_annotations count] -1]];
    }
    
    return description;
}

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

@end
