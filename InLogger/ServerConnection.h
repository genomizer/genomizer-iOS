//
//  ServerConnection.h
//  Genomizer


#import <Foundation/Foundation.h>
#import "MoreViewController.h"
#import "SearchViewController.h"
#import "RawConvertViewController.h"
#import "LogInViewController.h"

/**
 A class that contains static methods for all server communication.
 All communication happens asynchronously, which means none of the methods
 have return values. Instead the method, when done, reports to the
 viewController it has access to.
 */
@interface ServerConnection : NSObject<NSURLConnectionDelegate>

+ (void)login:(NSString *)username withPassword:(NSString *)password
  withContext:(void (^)(NSString *,NSError *))completionBlock;

+ (void)logout:(void(^)())completion;

+ (void)search:(NSString *) annotations withContext:(void (^)(NSMutableArray *,
                                                              NSError *)
                                                     )completionBlock;

- (void)convert:(NSDictionary*)dict withContext:(void (^)(NSError *,
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
