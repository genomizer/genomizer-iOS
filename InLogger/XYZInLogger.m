//
//  XYZInLogger.m
//  InLogger
//
//  Created by Joel Viklund on 25/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZInLogger.h"

@implementation XYZInLogger

+ (BOOL)validAccount:(NSString *)username withPassword:(NSString *)password
{
    return [username isEqualToString:@"yuri"] && [password isEqualToString:@"yuri"];
}


@end
