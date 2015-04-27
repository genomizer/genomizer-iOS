//
//  FileHandler.m
//  Genomizer
//
//  The FileHandler reads and writes data to and from files
//  in the Documents folder of the device.
//

#import "FileHandler.h"

@implementation FileHandler

/**
 * Reads from the file with the given name. If no file is found the file will be created
 * and the default data will be stored in it.
 *
 * @param fileName - the name of the file
 * @param data - the default data to use if no file is found
 *
 * @return the data of the file
 */
+ (NSString *) readFromFile: (NSString *) fileName withDefaultData: (NSString *) data
{
    NSString *readData = [[NSUserDefaults standardUserDefaults] objectForKey:fileName];
    if(readData == nil){
        readData = data;
    }
    return readData;
}

/**
 * Writes the given data to the file with the given name.
 *
 * @param data - the data to write to the file
 * @param fileName - the name of the file
 */
+ (void) writeData: (NSString *) data toFile: (NSString *) fileName
{
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:fileName];
}

@end
