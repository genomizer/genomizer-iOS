//
//  ProcessStatusDescriptor.h
//  Genomizer
//
//  Created by Marc Armgren on 19/05/14.
//  Copyright (c) 2014 Marc Armgren. All rights reserved.
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
