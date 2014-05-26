//
//  XYZExperiment.m
//  InLogger
//
//  Created by Patrik Nordström on 29/04/14.
//  Copyright (c) 2014 Patrik Nordström. All rights reserved.
//

#import "XYZExperiment.h"
#import "XYZExperimentFile.h"

@implementation XYZExperiment

- (XYZExperiment *) init
{
    self = [super init];
    _annotations = [[NSMutableDictionary alloc] init];
    _files = [[XYZFileContainer alloc] init];

    return self;
}


- (void) setValue: (id) value forAnnotation: (NSString*) annotation
{
    [_annotations setValue: value forKey:annotation];

}

- (NSString *) getValueForAnnotation: (NSString *) annotation
{
    return [_annotations valueForKey:annotation];
}

@end
