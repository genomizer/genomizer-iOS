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
    //Pål did this
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) { // if file is not exist, create it.
//        NSError *error;
//        [data writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
//        return data;
//    }
//    return [NSString stringWithContentsOfFile: filePath encoding:NSUTF8StringEncoding error:nil];
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
    //Pål did this
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
//    NSError *error;
//    [data writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:fileName];
    
}

@end
