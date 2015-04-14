//
//  XYZFileContainer.h
//  Genomizer
//
//  The XYZFileContainer contains experiments files. It sorts them into four
//  categories based on the file type.
//

#import "XYZExperimentFile.h"

@interface XYZFileContainer : NSObject

- (NSMutableArray *) getFiles: (FileType) fileType;
- (void) addExperimentFile: (XYZExperimentFile *) file;
- (void) removeExperimentFile: (XYZExperimentFile *) file;
- (NSInteger) numberOfFiles;
- (NSInteger) numberOfFilesWithType: (FileType) fileType;
- (BOOL) containsFile: (XYZExperimentFile *) file;
- (NSMutableArray *) getFiles;
- (NSMutableArray *) getFilesOfType: (FileType) fileType;

@end
