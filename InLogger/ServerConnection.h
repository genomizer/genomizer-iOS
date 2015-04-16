//
//  ServerConnection.h
//  Genomizer


#import <Foundation/Foundation.h>
#import "MoreViewController.h"
#import "SearchViewController.h"
#import "RawConvertViewController.h"
#import "LogInViewController.h"
#import "ProcessViewController.h"

/**
 A class that contains static methods for all server communication.
 All communication happens asynchronously, which means none of the methods
 have return values. Instead the method, when done, reports to the viewController
 it has access to.
 */
@interface ServerConnection : NSObject

+ (void)login:(NSString *)username withPassword:(NSString *)password error:(NSError**) error withContext: (UIViewController*) controller;
+ (void)logout:(void(^)())completion;

+ (void)search:(NSString *) annotations withContext: (SearchViewController*) controller;

+ (void)convert:(NSMutableDictionary*)dict withContext: (RawConvertViewController*) controller;
+ (NSDictionary*)parseJSONToDictionary:(NSData*)POSTReply error:(NSError**)error;

+ (void) getAvailableAnnotations:(SearchViewController*) controller;
+ (void) getProcessStatus:(ProcessViewController*) controller;
+ (void)genomeRelease: (RawConvertViewController*) controller;


@end
