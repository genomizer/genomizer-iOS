//
//  XYZFileContainer.h
//  Genomizer
//
//  Created by Joel Viklund on 19/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZExperimentFile.h"

@interface XYZFileContainer : NSObject

- (NSMutableArray *) arrayOfFileType: (FileType) fileType;
- (void) addExperimentFile: (XYZExperimentFile *) file;
- (void) removeExperimentFile: (XYZExperimentFile *) file;
- (NSInteger) numberOfFiles;
- (NSInteger) numberOfFilesWithType: (FileType) fileType;
- (BOOL) containsFile: (XYZExperimentFile *) file;
- (NSMutableArray *) getFiles;
- (NSMutableArray *) getFiles: (FileType) fileType;

@end
