//
//  ProcessStatusDescriptor.h
//  Genomizer
//
//  The ProcessStatusDescriptor describes process statuses. It
//  contains information about a process.
//

#import "ProcessStatusDescriptor.h"

@implementation ProcessStatusDescriptor

NSMutableArray* files;
NSArray *expectedInformation;

/**
 * Initializes a ProcessStatusDecsriptor.
 *
 * @return an initialized ProcessStatusDescriptor
 */
- (ProcessStatusDescriptor*) init
{
    self = [super init];
    files = [[NSMutableArray alloc] init];
    
    if(expectedInformation == nil){
        expectedInformation =  @[@"experimentName",
                                 @"timeFinished",
                                 @"status",
                                 @"author",
                                 @"timeStarted",
                                 @"timeAdded",
                                 @"outputFiles"];
    }
    
    return self;
}

/**
 * Initializes a ProcessStatusDecsriptor with the given status.
 *
 * @param status - values and keys for the attributes
 * @return an initialized ProcessStatusDescriptor
 */
- (ProcessStatusDescriptor*) init: (NSDictionary*) status
{
    if([self statusDictionaryIsValid:status])
    {
        self = [self init];
        self.experimentName = [status objectForKey:@"experimentName"];
       
    
        self.status = [status objectForKey:@"status"];
        self.author = [status objectForKey:@"author"];
      
        self.timeStarted = [[NSDate alloc] initWithTimeIntervalSince1970:[[status objectForKey:@"timeStarted"] doubleValue]/1000];
        self.timeAdded = [NSDate dateWithTimeIntervalSince1970:[[status objectForKey:@"timeAdded"] doubleValue]/1000];
        self.timeFinished = [NSDate dateWithTimeIntervalSince1970:[[status objectForKey:@"timeFinished"] doubleValue]/1000];
        
        NSArray *files = [status objectForKey:@"outputFiles"];
        for(NSString *file in files)
        {
            [self addOutputFile:file];
        }
        
        return self;
    } else
    {
        return nil;
    }
}

/**
 * Returns YES if the given status dictionary is valid, NO otherwise.
 *
 * @param the status dictionary
 * @return YES if the given status dictionary is valid, NO otherwise
 */
- (bool) statusDictionaryIsValid: (NSDictionary*) status
{
    for(NSString *string in expectedInformation)
    {
        if([status objectForKey:string] == nil)
        {
            return NO;
        }
    }
    return YES;
}

/**
 * Adds the given file name as an output file.
 *
 * @param fileName - the name of the file
 * @return YES if the file was added, NO if the file was already added
 */
- (bool) addOutputFile:(NSString*) fileName
{
    if(![files containsObject:fileName]){
        [files addObject: fileName];
        return YES;
    } else
    {
        return NO;
    }
}

/**
 * Returns the output file at the given index.
 *
 * @param index - the index
 * @return the file at the given index
 */
- (NSString*) getOutputFile: (int) index
{
    if(index < [files count])
    {
        return [files objectAtIndex:index];
    }
    else
    {
        return nil;
    }
}

/**
 * Returns the number of output files.
 *
 * @return the number of output files
 */
- (int) getNumberOfOutputFiles {
    return (int)[files count];
}


@end
