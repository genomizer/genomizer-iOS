//
//  XYZSearchMother.h
//  InLogger
//
//  Created by Joel Viklund on 29/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZSearchMother : NSObject

- (void) setAnnotationVisibilityFor: (NSString *) annotation withVisiblity: (BOOL) visibility;
- (NSString*) getDescriptionOfChildAt: NSInteger;

- (XYZSearchMother*) init:(NSDictionary*) incomingData;

@end
