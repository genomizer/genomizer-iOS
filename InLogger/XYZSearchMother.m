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
    return [NSString alloc];
}

@end
