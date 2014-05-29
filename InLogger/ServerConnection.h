//
//  ServerConnection.h
//  Genomizer
//
// A class that contains static methods for all server communication.
// All communication happens asynchronously, which means none of the methods
// have return values. Instead the method, when done, reports to the viewController
// it has access to.
//

#import <Foundation/Foundation.h>
#import "MoreViewController.h"
#import "XYZSearchViewController.h"
#import "RawConvertViewController.h"
#import "XYZLogInViewController.h"
#import "ProcessViewController.h"

@interface ServerConnection : NSObject

+ (void)login:(NSString *)username withPassword:(NSString *)password error:(NSError**) error withContext: (UIViewController*) controller;
+ (void)logout;

+ (void)search:(NSString *) annotations withContext: (XYZSearchViewController*) controller;

+ (void)convert:(NSMutableDictionary*)dict withContext: (RawConvertViewController*) controller;
+ (NSDictionary*)parseJSONToDictionary:(NSData*)POSTReply error:(NSError**)error;

+ (void) getAvailableAnnotations:(XYZSearchViewController*) controller;
+ (void) getProcessStatus:(ProcessViewController*) controller;
+ (void)genomeRelease: (RawConvertViewController*) controller;
@end
