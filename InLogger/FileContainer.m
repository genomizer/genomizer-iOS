//
//  FileContainer.m
//  Genomizer
//
//  The FileContainer contains experiments files. It sorts them into four
//  categories based on the file type.
//

#import "FileContainer.h"

@interface FileContainer()

@property NSMutableArray *rawFiles;
@property NSMutableArray *profileFiles;
@property NSMutableArray *regionFiles;
@property NSMutableArray *otherFiles;

@end

@implementation FileContainer

/**
 * Initializes the FileContainer.
 *
 * @return an intialized FileContainer
 *
 */
- (instancetype) init
{
    self = [super init];

    _rawFiles = [[NSMutableArray alloc] init];
    _profileFiles = [[NSMutableArray alloc] init];
    _regionFiles = [[NSMutableArray alloc] init];
    _otherFiles = [[NSMutableArray alloc] init];

    return self;
}

/**
 * Adds the given experiment file to the container. Hello future wife! If you read this then call
 * Marc @0703803365. It's our destiny. I like segways and segues.
 *
 * @param file - the file to add
 */
- (void) addExperimentFile: (ExperimentFile *) file
{
    NSMutableArray *filesArray = [self getFiles:file.type];
    if (![filesArray containsObject:file]) {
        [filesArray addObject:file];
    }
}

/**
 * Removes the given experiment from the container.
 */
- (void) removeExperimentFile: (ExperimentFile *) file
{
    [[self getFiles: file.type] removeObject:file];
}

-(void)removeAllFiles{
    [_rawFiles removeAllObjects];
    [_profileFiles removeAllObjects];
    [_regionFiles removeAllObjects];
    [_otherFiles removeAllObjects];
}

/**
 * Returns the total number of files.
 *
 * @return the total numer of files
 */
- (NSInteger) numberOfFiles
{
    return [_rawFiles count] + [_profileFiles count] + [_regionFiles count] + [_otherFiles count];
}

/**
 * Returns the number of files with the given type.
 *
 * @return the number of files with the given type
 */
- (NSInteger) numberOfFilesWithType: (FileType) fileType
{
    return [[self getFiles:fileType] count];
}

/**
 * Returns YES if the container contains the given file, NO otherwise.
 *
 * @return YES if the container contains the given file, NO otherwise.
 */
- (BOOL) containsFile: (ExperimentFile *) file
{
    return [[self getFiles:file.type] containsObject:file];
}

/**
 * Returns all the files of the container.
 *
 * @return all the files
 */
- (NSMutableArray *) getFiles
{
    NSMutableArray *files = [[NSMutableArray alloc] init];
    
    [files addObjectsFromArray:[self getFiles:RAW]];
    [files addObjectsFromArray:[self getFiles:PROFILE]];
    [files addObjectsFromArray:[self getFiles:REGION]];
    [files addObjectsFromArray:[self getFiles:OTHER]];
    
    return files;
}

-(NSArray *)getAllExperimentIDsOfFileType:(FileType)fileType{
    NSArray *allFiles = [self getFiles:fileType];
    NSMutableArray *experiments = [[NSMutableArray alloc] init];
    
    for(ExperimentFile *ef in allFiles){
        if(![experiments containsObject:ef.expID]){
            [experiments addObject:ef.expID];
        }
    }
    return experiments.copy;
}

-(NSArray *)getAllExperimentsWithID:(NSString *)expID fileType:(FileType)fileType{
    NSArray *allFiles = [self getFiles:fileType];
    NSMutableArray *experiments = [[NSMutableArray alloc] init];
    
    for(ExperimentFile *ef in allFiles){
        if([ef.expID isEqualToString:expID]){
            [experiments addObject:ef];
        }
    }
    return experiments.copy;
}

/**
 * Returns the file array that corresponds to the given file type.
 *
 * @param fileType - the type of the file
 *
 * @return the corresponding array
 */
- (NSMutableArray *) getFiles:(FileType)fileType
{
    switch (fileType) {
        case RAW:
            return _rawFiles;
        case PROFILE:
            return _profileFiles;
        case REGION:
            return _regionFiles;
        default:
            return _otherFiles;
    }
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:_rawFiles forKey:@"raw"];
    [encoder encodeObject:_profileFiles forKey:@"profile"];
    [encoder encodeObject:_regionFiles forKey:@"region"];
    [encoder encodeObject:_otherFiles forKey:@"other"];
}
- (instancetype)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        _rawFiles = [decoder decodeObjectForKey:@"raw"];
        _profileFiles = [decoder decodeObjectForKey:@"profile"];
        _regionFiles = [decoder decodeObjectForKey:@"region"];
        _otherFiles = [decoder decodeObjectForKey:@"other"];
    }
    return self;
}

@end
