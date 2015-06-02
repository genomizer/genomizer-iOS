//
//  DummyServer.m
//  Genomizer
//
//  Created by Mattias Scherer on 18/05/15.
//  Copyright (c) 2015 Mattias. All rights reserved.
//

#import "DummyServer.h"
#import "ExperimentFile.h"

@implementation DummyServer


- (instancetype)init
{
    self = [super init];
    if (self) {
        _annotations = [[NSMutableArray alloc] init];
        _experiment = [[Experiment alloc] init];
        _process = [self createProcessStatus];
        [self createProcessStatus];
        [self createAvailableAnnotations];
        [self createExperiment];
    }
    return self;
}

- (NSMutableDictionary*)createProcessStatus {
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Human dummy", @"experimentName",
                                 @"1",@"timeFinished",
                                 @"Running",@"status",
                                 @"Dev",@"author",
                                 @"1",@"timeStarted",
                                 @"1",@"timeAdded",
                                 @[@"Dummy file"],@"outputFiles",nil];
    
    return temp;
}

- (void)createAvailableAnnotations {
    Annotation *annotation = [[Annotation alloc] init];
    annotation.name = @"Species";
    annotation.possibleValues = @[@"Human"];
    [self.annotations addObject:annotation];
}

- (void)createExperiment {
    self.experiment.name = @"Human dummy";
    self.experiment.createdByUser = @"Dev";
    self.experiment.annotations = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0", @"forced", @"Species", @"name", @[@"Human"], @"value", nil];
    
    [self.experiment.files addExperimentFile:[self createFile]];
}


- (ExperimentFile*)createFile {
    ExperimentFile *expFile = [[ExperimentFile alloc] init];
    expFile.idFile = @"Dummy file";
    expFile.type = [ExperimentFile NSStringFileTypeToEnumFileType:@"Raw"];
    expFile.name = @"Dummy file";
    expFile.uploadedBy = @"Not set!";
    expFile.species = @"Not set!";
    expFile.expID = @"Human dummy";
    expFile.grVersion = @"Not set!";
    expFile.author = @"Not set!";
    expFile.date = @"Not set!";
    expFile.filesize = @"0MB";
    expFile.metaData = @"astringofmeta";
    
    return expFile;
}

@end
