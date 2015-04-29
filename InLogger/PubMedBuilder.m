//
//  PubMedBuilder.m
//  Genomizer
//
//  Builds search strings according to the pubmed-standards.
//

#import "PubMedBuilder.h"
#import "Annotation.h"

@implementation PubMedBuilder

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
        Annotation *annotation = [annotations objectAtIndex:j];
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

+(NSAttributedString *)formatInfoText:(NSString *)text fontSize:(CGFloat)pointSize{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSUInteger loc = 0;
    while (loc < text.length) {
        NSUInteger prevLoc = loc;
        
        loc = (int)[text rangeOfString:@":" options:NSCaseInsensitiveSearch range:NSMakeRange(prevLoc, text.length - prevLoc)].location;
        if(loc == NSNotFound || (int)loc < 0){
            break;
        }
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:pointSize-2] range:NSMakeRange(prevLoc, loc - prevLoc)];
        prevLoc = loc;
        loc = (int)[text rangeOfString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(prevLoc, text.length - prevLoc)].location;
        if(loc == NSNotFound || (int)loc < 0){
            loc = text.length;
        }
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:pointSize] range:NSMakeRange(prevLoc, loc - prevLoc)];
    }
    return string;
}

@end
