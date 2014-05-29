//
//  XYZPubMedBuilder.m
//  Genomizer
//
//  Builds search strings according to the pubmed-standards.
//

#import "XYZPubMedBuilder.h"
#import "XYZAnnotation.h"

@implementation XYZPubMedBuilder

/**
 * Builds search strings according to the pubmed-standards.
 * The given annotations will be seperated by ANDs.
 *
 * @param annotations - the annotations to search for
 *
 * @return a pubmed search string
 */
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
