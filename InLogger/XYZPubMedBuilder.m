//
//  XYZPubMedBuilder.m
//  InLogger
//
//  Created by Joel Viklund on 14/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZPubMedBuilder.h"
#import "XYZAnnotation.h"

@implementation XYZPubMedBuilder

+ (NSString *)createAnnotationsSearch: (NSArray *)annotations
{
    NSString *annoSearch = @"";
    NSInteger annotationLength = [annotations count];
    for(NSInteger i = 0; i < annotationLength - 1; i++) {
        annoSearch = [annoSearch stringByAppendingString:@"("];
    }
    for(int j = 0; j < [annotations count]; j++){
        XYZAnnotation *annotation = [annotations objectAtIndex:j];
        annoSearch = [annoSearch stringByAppendingString:annotation.value];
        annoSearch = [annoSearch stringByAppendingString:@"["];
        annoSearch = [annoSearch stringByAppendingString:annotation.name];
        if(j == [annotations count] - 1) {
            annoSearch = [annoSearch stringByAppendingString:@"]"];
        } else {
            annoSearch = [annoSearch stringByAppendingString:@"]) AND "];
        }
    }
    return annoSearch;
}

@end
