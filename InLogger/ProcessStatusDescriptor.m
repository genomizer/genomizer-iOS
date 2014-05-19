//
//  ProcessStatusDescriptor.m
//  Genomizer
//
//  Created by Marc Armgren on 19/05/14.
//  Copyright (c) 2014 Marc Armgren. All rights reserved.
//

#import "ProcessStatusDescriptor.h"

@implementation ProcessStatusDescriptor

NSMutableArray* files;
NSArray *expectedInformation;

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

- (ProcessStatusDescriptor*) init: (NSDictionary*) status
{
    if([self statusDictionaryIsValid:status])
    {
        self = [self init];
        self.experimentName = [status objectForKey:@"experimentName"];
        self.timeFinished = [status objectForKey:@"timeFinished"];
        self.status = [status objectForKey:@"status"];
        self.author = [status objectForKey:@"author"];
        self.timeStarted = [status objectForKey:@"timeStarted"];
        self.timeAdded = [status objectForKey:@"timeAdded"];
        
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

- (NSString*) getOutputFile: (int) fileNumber
{
    if(fileNumber < [files count])
    {
        return [files objectAtIndex:fileNumber];
    }
    else
    {
        return nil;
    }
}

- (int) getNumberOfOutputFiles {
    return [files count];
}


@end
