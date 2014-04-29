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
    [incomingData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *country = key;
        NSString *beer = obj;
        NSLog(@"%@ is %@",country,beer);
    }];
    
    return self;
}

- (void) setAnnotationVisibility: (NSString*)annotation withVisibility:(bool) visibility{
    
}

- (NSString*) getDescriptionOfChildAt: NSInteger{
    return @"Experiment ID: 12312\nPublication ID: 50555\nDate: 2014-03-04\nExperiment ID: 12312\nPublication ID: 50555\nDate: 2014-03-04";
}

@end
