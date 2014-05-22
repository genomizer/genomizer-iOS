//
//  XYZFileHandler.h
//  Genomizer
//
//  Created by Joel Viklund on 22/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SERVER_URL_FILE_NAME @"server_url.asd"


@interface XYZFileHandler : NSObject

+ (NSString *) readFromFile: (NSString *) fileName withDefaultData: (NSString *) data;
+ (void) writeData: (NSString *) data toFile: (NSString *) fileName;

@end
