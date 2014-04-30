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
    [_annotations addObject:@"type"];
    [_annotations addObject:@"specie"];
    return self;
}

- (void) addAnnotation: (NSString *) annotation
{
    [_annotations addObject:annotation];
}
- (void) removeAnnotation: (NSString *) annotation
{
    [_annotations removeObject:annotation];
}

- (NSString *) getDescriptionOf: (XYZExperiment*) experiment
{
    NSMutableString *description = [[NSMutableString alloc] init];
    
    [description appendString: [self createRowForAnnotation:@"Name" withValue:experiment.name andNewLine:YES]];
    [description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:YES]];
    for (NSInteger i = 0; i < [_annotations count]; i++) {
        [description appendString: [self createRowForAnnotation:_annotations[i]
                                                     withValue:[experiment getValueForAnnotation:[_annotations objectAtIndex:i]]
                                                     andNewLine:i != [_annotations count] -1]];
    }
    
    return description;
}

- (NSString *) createRowForAnnotation: (NSString *) annotation withValue: (NSString *) value andNewLine: (BOOL) newLine
{
    NSMutableString *description = [[NSMutableString alloc] init];
    [description appendString: annotation];
    [description appendString: @": "];
    if(value == nil) {
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
