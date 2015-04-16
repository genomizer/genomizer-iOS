//
//  FileContainer.h
//  Genomizer
//

//

#import "ExperimentFile.h"

/**
The FileContainer contains experiments files. It sorts them into four
categories based on the file type.
 */
@interface FileContainer : NSObject


- (void) addExperimentFile: (ExperimentFile *) file;
- (void) removeExperimentFile: (ExperimentFile *) file;
- (NSInteger) numberOfFiles;
- (NSInteger) numberOfFilesWithType: (FileType) fileType;
- (BOOL) containsFile: (ExperimentFile *) file;
- (NSMutableArray *) getFiles;
- (NSMutableArray *) getFiles: (FileType) fileType;

@end
