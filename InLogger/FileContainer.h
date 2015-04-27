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
-(void)removeAllFiles;
- (NSInteger) numberOfFiles;
- (NSInteger) numberOfFilesWithType: (FileType) fileType;
- (BOOL) containsFile: (ExperimentFile *) file;
- (NSMutableArray *) getFiles;
- (NSMutableArray *) getFiles: (FileType) fileType;

-(NSArray *)getAllExperimentIDsOfFileType:(FileType)fileType;
-(NSArray *)getAllExperimentsWithID:(NSString *)expID fileType:(FileType)fileType;

@end
