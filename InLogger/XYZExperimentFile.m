//
//  XYZExperimentFile.m
//  Genomizer
//
//  The XYZExmperimentFile represents an experiment file and contatins
//  information about it.
//
#import "XYZExperimentFile.h"

@implementation XYZExperimentFile

/**
 * Checks if the files in the given array contains files of multiples 
 * file types.
 *
 * @param files - an array with files
 *
 * @return YES if the files are of different types, NO otherwise
 */
+ (BOOL) multipleFileType: (NSArray *) files
{
    if ([files count] == 0) {
        return NO;
    }
    FileType type = ((XYZExperimentFile *)files[0]).type;
    
    for (XYZExperimentFile *file in files) {
        if (file.type != type) {
            return YES;
        }
    }
    
    return NO;
}

/**
 * Returns the name of the file.
 *
 * @return the name of the file
 */
- (NSString *) getDescription
{
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString: [self format: _name]];
    return string;
}

/**
 * Returns a string with all information about the file.
 *
 * @return information about the file
 */
- (NSString *) getAllInfo{
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString: @"Filename: "];
    [string appendString: [self format: _name]];
    [string appendString: @"\n"];
    [string appendString: @"Date: "];
    [string appendString: [self format: _date]];
    [string appendString: @"\n"];
    [string appendString: @"Uploaded by: "];
    [string appendString: [self format: _uploadedBy]];
    [string appendString: @"\n"];
    [string appendString: @"Name: "];
    [string appendString: [self format: _name]];
    [string appendString: @"\n"];
    [string appendString: @"Experiment ID: "];
    [string appendString: [self format: _expID]];
    [string appendString: @"\n"];
    [string appendString: @"Metadata: "];
    [string appendString: [self format: _metaData]];
    [string appendString: @"\n"];
    [string appendString: @"Author: "];
    [string appendString: [self format: _author]];
    [string appendString: @"\n"];
    [string appendString: @"Genome Version: "];
    [string appendString: [self format: _grVersion]];
    [string appendString: @"\n"];
    [string appendString: @"Speice: "];
    [string appendString: [self format: _species]];
    [string appendString: @"\n"];
    return string;
}

/**
 * Returns a ? if the given string is nil, otherwise the same string is returned.
 *
 * @param string - the string to format
 *
 * @return ? if the string is nil, otherwise the same string
 */
- (NSString *) format: (NSString *) string
{
    if (string == nil) {
        return @"?";
    } else {
        return string;
    }
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
 *
 * @param object - the object to compare with
 *
 * @return YES if the arguments are equal to each other and NO otherwise.
 */
- (BOOL) isEqual:(id)object
{
    if (![object isKindOfClass:[XYZExperimentFile class]]) {
        return NO;
    }
    return [_name isEqualToString: ((XYZExperimentFile *)object).idFile];
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


@end

