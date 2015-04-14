//
//  FileContainer.h
//  Genomizer
//
//  The FileContainer contains experiments files. It sorts them into four
//  categories based on the file type.
//

#import "ExperimentFile.h"

@interface FileContainer : NSObject


- (void) addExperimentFile: (ExperimentFile *) file;
- (void) removeExperimentFile: (ExperimentFile *) file;
- (NSInteger) numberOfFiles;
- (NSInteger) numberOfFilesWithType: (FileType) fileType;
- (BOOL) containsFile: (ExperimentFile *) file;
- (NSMutableArray *) getFiles;
- (NSMutableArray *) getFiles: (FileType) fileType;

@end
