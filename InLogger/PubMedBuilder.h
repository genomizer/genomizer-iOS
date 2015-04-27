//
//  PubMedBuilder.h
//  Genomizer


#import <Foundation/Foundation.h>

/**
 Builds search strings according to the pubmed-standards.
 */
@interface PubMedBuilder : NSObject

+ (NSString *)createAnnotationsSearch: (NSArray *)annotations;

+(NSAttributedString *)formatInfoText:(NSString *)text fontSize:(CGFloat)pointSize;

@end
