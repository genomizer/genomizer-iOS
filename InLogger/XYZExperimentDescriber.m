//
//  XYZExperimentDescriber.m
//  InLogger
//
//  Created by Joel Viklund on 30/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZExperimentDescriber.h"

@interface XYZExperimentDescriber()

@property NSMutableArray *visibleAnnotations;

@end

@implementation XYZExperimentDescriber


- (XYZExperimentDescriber *) init
{
    self = [super init];
    _visibleAnnotations = [[NSMutableArray alloc] init];
    return self;
}

- (void) showAnnotation: (XYZAnnotation *) annotation
{
    if( ![_visibleAnnotations containsObject:annotation]) {
        [_visibleAnnotations addObject:annotation];
    }
}

- (void) hideAnnotation: (XYZAnnotation *) annotation
{
    [_visibleAnnotations removeObject:annotation];
}

- (BOOL) showsAnnotation: (XYZAnnotation *) annotation {
    return [_visibleAnnotations containsObject:annotation];
}

- (NSString *) getDescriptionOf: (XYZExperiment*) experiment
{
    NSMutableString *description = [[NSMutableString alloc] init];
    
    [description appendString: [self createRowForAnnotation:@"Name" withValue:experiment.name andNewLine:YES]];
    [description appendString: [self createRowForAnnotation:@"Created by" withValue:experiment.createdByUser andNewLine:[_visibleAnnotations count] > 0]];
    
     for (NSInteger i = 0; i < [_visibleAnnotations count]; i++) {
         XYZAnnotation *annotation = _visibleAnnotations[i];
        [description appendString: [self createRowForAnnotation:[annotation getFormatedName]
                                                     withValue:[experiment getValueForAnnotation:annotation.name]
                                                     andNewLine:i != [_visibleAnnotations count] -1]];
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
