//
//  ExperimentFile.m
//  Genomizer
//
//  The ExmperimentFile represents an experiment file and contatins
//  information about it.
//
#import "ExperimentFile.h"

@implementation ExperimentFile



/**
 * Checks if the files in the given array contains files of multiples 
 * file types.
 * @param files - an array with files
 * @return YES if the files are of different types, NO otherwise
 */
+ (BOOL) multipleFileType: (NSArray *) files
{
    if ([files count] == 0) {
        return NO;
    }
    FileType type = ((ExperimentFile *)files[0]).type;
    
    for (ExperimentFile *file in files) {
        if (file.type != type) {
            return YES;
        }
    }
    
    return NO;
}

/**
 * Returns the name of the file.
 * @return the name of the file
 *//*
- (NSString *) getDescription
{
    return _name;
}*/

/**
 * Returns a string with all information about the file.
 * @return information about the file
 */
- (NSString *) getAllInfo{
#warning Filename and name?
    NSString *fileInfo = [NSString stringWithFormat:
                          @"Filename: %@\nDate: %@\n"
                          "Name: %@\nExperiment ID: %@\n"
                          "Metadata: %@\nAuthor: %@\n"
                          "Genome Version: %@\nSpecies: %@\n"
                          ,self.idFile, self.date
                          ,self.name, self.expID
                          ,self.metaData, self.author
                          ,self.grVersion, self.species];
    
    return fileInfo;
}

/**
 * Convertes a string representation of the file type to the enum representation.
 *
 * @param type - the type of the file as a string
 *
 * @return the type of the file as an enum
 */
+ (FileType) NSStringFileTypeToEnumFileType: (NSString *) type
{
    type = [type lowercaseString];
    if ([type isEqualToString:@"raw"]) {
        return RAW;
    } else if ([type isEqualToString:@"region"]) {
        return REGION;
    } else if ([type isEqualToString:@"profile"]) {
        return PROFILE;
    } else {
        return OTHER;
    }
}

/**
 * Returns YES if the arguments are equal to each other and NO otherwise.
 * @param object - the object to compare with
 * @return YES if the arguments are equal to each other and NO otherwise.
 */
- (BOOL) isEqual:(id)object
{
    if (![object isKindOfClass:[ExperimentFile class]]) {
        return NO;
    }
    ExperimentFile *otherFile = (ExperimentFile *)object;
    return [self.idFile isEqual:otherFile.idFile] &&
            [self.name isEqualToString:otherFile.name];
}

/**
 * Generates a hash code based on the file id.
 *
 * @return the hash code
 */
- (NSUInteger) hash
{
    return [_idFile hash];
}

/**
 *  Encode the object to be able to store it in NSUserDefaults
 */
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:_idFile forKey:@"idFile"];
    [encoder encodeObject:@(_type) forKey:@"type"];
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_uploadedBy forKey:@"uploadedBy"];
    [encoder encodeObject:_date forKey:@"date"];
    [encoder encodeObject:_expID forKey:@"expID"];
    [encoder encodeObject:_metaData forKey:@"metaData"];
    [encoder encodeObject:_author forKey:@"author"];
    [encoder encodeObject:_grVersion forKey:@"grVersion"];
    [encoder encodeObject:_species forKey:@"species"];
}

#warning not used
- (instancetype)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        _idFile = [decoder decodeObjectForKey:@"idFile"];
        _type = [(NSNumber *)[decoder decodeObjectForKey:@"type"] intValue];
        _name = [decoder decodeObjectForKey:@"name"];
        _uploadedBy = [decoder decodeObjectForKey:@"uploadedBy"];
        _date = [decoder decodeObjectForKey:@"date"];
        _expID = [decoder decodeObjectForKey:@"expID"];
        _metaData = [decoder decodeObjectForKey:@"metaData"];
        _author = [decoder decodeObjectForKey:@"author"];
        _grVersion = [decoder decodeObjectForKey:@"grVersion"];
        _species = [decoder decodeObjectForKey:@"species"];
    }
    return self;
}

@end

