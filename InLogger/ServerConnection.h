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
 have return values. Instead the method, when done, reports to the
 viewController it has access to.
 */
@interface ServerConnection : NSObject

+ (void)login:(NSString *)username withPassword:(NSString *)password
        error:(NSError**) error withContext: (UIViewController*) controller;
+ (void)logout:(void(^)())completion;

+ (void)search:(NSString *) annotations withContext:(void (^)(NSMutableArray *,
                                                              NSError *)
                                                     )completionBlock;

+ (void)convert:(NSMutableDictionary*)dict withContext:(void (^)(NSError *,
                                                                 NSString *)
                                                        )completionBlock;
+ (NSDictionary*)parseJSONToDictionary:(NSData*)POSTReply
                                 error:(NSError**)error;

+ (void) getAvailableAnnotations:(void (^)(NSArray *,
                                           NSError *))completionBlock;
+ (void) getProcessStatus:(void (^)(NSMutableArray *,
                                    NSError *))completionBlock;
+ (void)genomeRelease:(void (^)(NSMutableArray *, NSError *))completionBlock;


+(void)setToken:(NSString *)token;

@end
