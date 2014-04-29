//
//  XYZSearchMother.m
//  InLogger
//
//  Created by Joel Viklund on 29/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZSearchMother.h"

@interface XYZSearchMother ()

@property NSMutableArray *annotations;
@property NSMutableArray *data;

@end

@implementation XYZSearchMother

- (XYZSearchMother*) init:(NSDictionary*) incomingData{
    self = [super init];

    return self;
}

- (void) setAnnotationVisibilityFor: (NSString *) annotation withVisiblity: (BOOL) visibility{
    
}


- (NSString*) getDescriptionOfChildAt: NSInteger{
    return @"Experiment ID: 12312\nPublication ID: 50555\nDate: 2014-03-04\nExperiment ID: 12312\nPublication ID: 50555\nDate: 2014-03-04";
}

@end
