//
//  XYZAnnotation.h
//  InLogger
//
//  Created by Joel Viklund on 14/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZAnnotation : NSObject

@property NSString *name;
@property NSArray *values;

-(BOOL) isFreeText;
- (NSString *) getFormatedName;

@end
