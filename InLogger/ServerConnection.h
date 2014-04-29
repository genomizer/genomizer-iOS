//
//  ServerConnection.h
//  InLogger
//
//  Created by Linus Öberg on 28/04/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerConnection : NSObject

+ (int)login:(NSString *)username withPassword:(NSString *)password;
+ (int)logout;
+ (int)search:(NSArray *) annotations;
@end
