//
//  ProcessStatusDescriptor.h
//  Genomizer
//
//  The ProcessStatusDescriptor describes process statuses. It
//  contains information about a process.
//

#import <Foundation/Foundation.h>

@interface ProcessStatusDescriptor : NSObject

@property NSString* author;
@property NSString* experimentName;
@property NSString* outputFile;
@property NSString* status;
@property NSDate* timeAdded;
@property NSDate* timeStarted;
@property NSDate* timeFinished;

- (bool) addOutputFile:(NSString*) fileName;
- (NSString*) getOutputFile: (int) fileNumber;
- (int) getNumberOfOutputFiles;
- (ProcessStatusDescriptor*) init: (NSDictionary*) status;

@end
