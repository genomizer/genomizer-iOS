//
//  JSONBuilder.h
//  InLogger
//
//  Created by Patrik Nordström on 28/04/14.
//  Copyright (c) 2014 Patrik Nordström. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONBuilder : NSObject

+(NSMutableURLRequest*) getLoginJSON:(NSString *) username withPassword: (NSString *) password;
+(NSMutableURLRequest*)getLogoutJSON:(NSString *)token;
+(NSMutableURLRequest*)getSearchJSON:(NSString *)annotations withToken:(NSString *)token;
@end