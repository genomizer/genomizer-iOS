//
//  XYZFileHandler.m
//  Genomizer
//
//  Created by Joel Viklund on 22/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZFileHandler.h"

@implementation XYZFileHandler

+ (NSString *) readFromFile: (NSString *) fileName withDefaultData: (NSString *) data
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) { // if file is not exist, create it.
        NSError *error;
        [data writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        return data;
    }
    return [NSString stringWithContentsOfFile: filePath encoding:NSUTF8StringEncoding error:nil];
}

+ (void) writeData: (NSString *) data toFile: (NSString *) fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    NSError *error;
    [data writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

@end
