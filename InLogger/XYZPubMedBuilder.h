//
//  XYZPubMedBuilder.h
//  Genomizer
//
//  Builds search strings according to the pubmed-standards.
//

#import <Foundation/Foundation.h>

@interface XYZPubMedBuilder : NSObject

+ (NSString *)createAnnotationsSearch: (NSArray *)annotations;

@end
