//
//  ServerConnection.h
//  InLogger
//
//  Created by Linus Öberg on 28/04/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoreViewController.h"
#import "XYZSearchViewController.h"
#import "RawConvertViewController.h"
#import "XYZLogInViewController.h"
#import "ProcessViewController.h"

@interface ServerConnection : NSObject

+ (void)login:(NSString *)username withPassword:(NSString *)password error:(NSError**) error withContext: (UIViewController*) controller;
+ (void)logout:(NSError**) error;

+ (void)search:(NSString *) annotations withContext: (XYZSearchViewController*) controller;

+ (void)convert:(NSMutableDictionary*)dict withContext: (RawConvertViewController*) controller;
+ (NSDictionary*)parseJSONToDictionary:(NSData*)POSTReply error:(NSError**)error;

+ (void) getAvailableAnnotations:(XYZSearchViewController*) controller;
+ (void) getProcessStatus:(ProcessViewController*) controller;
+ (void)genomeRelease: (RawConvertViewController*) controller;
@end
