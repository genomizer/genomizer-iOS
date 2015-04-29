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

@property (nonatomic, strong) NSString *idFile;
@property FileType type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *uploadedBy;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *expID;
@property (nonatomic, strong) NSString *metaData;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *grVersion;
@property (nonatomic, strong) NSString *species;


- (NSString *)getAllInfo;
+ (FileType)NSStringFileTypeToEnumFileType:(NSString *) type;
+ (BOOL)multipleFileType:(NSArray *) files;

@end
