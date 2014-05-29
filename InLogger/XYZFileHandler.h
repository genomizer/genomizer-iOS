//
//  XYZFileHandler.h
//  Genomizer
//
//  The XYZFileHandler reads and writes data to and from files
//  in the Documents folder of the device.
//

#import <Foundation/Foundation.h>
#define SERVER_URL_FILE_NAME @"server_url.asd"


@interface XYZFileHandler : NSObject

+ (NSString *) readFromFile: (NSString *) fileName withDefaultData: (NSString *) data;
+ (void) writeData: (NSString *) data toFile: (NSString *) fileName;

@end
