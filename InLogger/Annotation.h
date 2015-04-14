//
//  Annotation.h
//  Genomizer
//
// The Annotation represents an annotation. It contains fields such as
// name, possible values and the current value.
//

#import <Foundation/Foundation.h>

@interface Annotation : NSObject

@property NSString *name;
@property NSArray *possibleValues;
@property NSString *value;
@property BOOL selected;

-(BOOL) isFreeText;
- (NSString *) getFormatedName;

@end
