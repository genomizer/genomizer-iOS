//
//  ExperimentFile.h
//  Genomizer
//

//

#import <Foundation/Foundation.h>

/**
The ExmperimentFile represents an experiment file and contatins
information about it.
 */
@interface ExperimentFile : NSObject

typedef NS_ENUM(NSInteger, FileType) {
    RAW,
    PROFILE,
    REGION,
    OTHER
};

@property NSString *idFile;
@property FileType type;
@property NSString *name;
@property NSString *uploadedBy;
@property NSString *date;
@property NSString *expID;
@property NSString *metaData;
@property NSString *author;
@property NSString *grVersion;
@property NSString *species;


- (NSString *) getDescription;
- (NSString *) getAllInfo;
+ (FileType) NSStringFileTypeToEnumFileType: (NSString *) type;
+ (BOOL) multipleFileType: (NSArray *) files;

@end
