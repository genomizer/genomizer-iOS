//
//  JSONBuilder.h
//  Genomizer
//

//

#import <Foundation/Foundation.h>

#define MOCK_URL @"http://bellatrix.cs.umu.se:7005/"

/**
 A class that creates NSURLRequests containing JSON objects where applicable
 as described by the API for the Genomizer project.
 */
@interface JSONBuilder : NSObject

+ (NSMutableURLRequest*) getLoginJSON:(NSString *) username withPassword: (NSString *) password;
+ (NSMutableURLRequest*) getLogoutJSON:(NSString *)token;
+ (NSMutableURLRequest*) getGenomeReleaseJSON:(NSString *)token;
+ (NSMutableURLRequest*) getSearchJSON:(NSString *)annotations withToken:(NSString *)token;
+ (NSMutableURLRequest*) getRawToProfileJSON:(NSString *)token withDict:(NSMutableDictionary *)dict __deprecated_msg("Use getProcessCommandJSON instead");
+ (NSMutableURLRequest*) getProcessCommandJSON:(NSString *)token withDict:(NSMutableDictionary *)dict;
+ (NSMutableURLRequest*) getAvailableAnnotationsJSON:(NSString *) token;
+ (NSMutableURLRequest*) getProcessStatusJSON:(NSString *) token;
+ (NSString*) getServerURL;
+ (void) setServerURLFromString: (NSString *) url;
+ (NSMutableURLRequest*) getRequest:(NSString*) requestType withToken:(NSString*) token;

@end