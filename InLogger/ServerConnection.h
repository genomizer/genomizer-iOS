//
//  ServerConnection.h
//  InLogger
//
//  Created by Linus Öberg on 28/04/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerConnection : NSObject

+ (int)login:(NSString *)username withPassword:(NSString *)password error:(NSError**) error;
+ (int)logout:(NSError**) error;
+ (NSDictionary*)search:(NSArray *) annotations error:(NSError**) error;
+ (NSDictionary*)parseJSONToDictionary:(NSData*)POSTReply error:(NSError**)error;
@end
