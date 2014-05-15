//
//  ServerConnection.h
//  InLogger
//
//  Created by Linus Öberg on 28/04/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerConnection : NSObject

+ (void)login:(NSString *)username withPassword:(NSString *)password error:(NSError**) error withContext: (UIViewController*) controller;
+ (int) logout:(NSError **) error;
+ (NSArray *) search:(NSString *) annotations error:(NSError **) error;
+ (void) convert:(NSMutableDictionary *) dict error:(NSError **) error;
+ (NSArray *) getAvailableAnnotations:(NSError **) error;
@end
