//
//  ProcessStatusDescriptor.h
//  Genomizer
//

//

#import <Foundation/Foundation.h>

/**
 The ProcessStatusDescriptor describes process statuses. It
 contains information about a process.
 */
@interface ProcessStatusDescriptor : NSObject

@property NSString* author;
@property NSString* experimentName;
@property NSString* outputFile;
@property NSString* status;
@property NSDate* timeAdded;
@property NSDate* timeStarted;
@property NSDate* timeFinished;

- (BOOL) addOutputFile:(NSString*) fileName;
- (NSString*) getOutputFile: (int) fileNumber;
- (int) getNumberOfOutputFiles;
- (instancetype) initWithStatus: (NSDictionary*) status;

@end
