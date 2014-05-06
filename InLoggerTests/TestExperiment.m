//
//  TestExperiment.m
//  InLogger
//
//  Created by Joel Viklund on 06/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XYZExperiment.h"

@interface TestExperiment : XCTestCase

@property XYZExperiment *experiment;
@property XYZExperimentFile *experimentFile;

@end

@implementation TestExperiment

- (void)setUp
{
    [super setUp];
    _experiment = [[XYZExperiment alloc] init];
    _experimentFile = [[XYZExperimentFile alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    _experiment = nil;
    _experimentFile = nil;
}

-(void) testGetValueForUnkownAnnotation
{
    NSString *result = [_experiment getValueForAnnotation:@"unknown"];
    XCTAssertEqualObjects(result, nil);
}

-(void) testSetAnnotation
{
    [_experiment setValue:@"value" forAnnotation:@"annotation"];
    NSString *result = [_experiment getValueForAnnotation:@"annotation"];
    XCTAssertEqualObjects(result, @"value");
}

-(void) testAddFile
{
    XCTAssertEqual([_experiment numberOfFiles], 0);
    [_experiment addExperimentFile:_experimentFile];
    XCTAssertEqual([_experiment numberOfFiles], 1);
}

-(void) testAddRAWFile
{
    XCTAssertEqual([_experiment.rawFiles count], 0);
    _experimentFile.type = RAW;
    [_experiment addExperimentFile:_experimentFile];
    XCTAssertEqual([_experiment.rawFiles count], 1);

}


-(void) testAddProfileFile
{
    XCTAssertEqual([_experiment.profileFiles count], 0);
    _experimentFile.type = PROFILE;
    [_experiment addExperimentFile:_experimentFile];
    [_experiment addExperimentFile:_experimentFile];
    XCTAssertEqual([_experiment.profileFiles count], 2);
    
}


-(void) testAddRegionFile
{
    XCTAssertEqual([_experiment.regionFiles count], 0);
    _experimentFile.type = REGION;
    [_experiment addExperimentFile:_experimentFile];
    XCTAssertEqual([_experiment.regionFiles count], 1);
}


-(void) testAddOtherFile
{
    XCTAssertEqual([_experiment.otherFiles count], 0);
    _experimentFile.type = OTHER;
    [_experiment addExperimentFile:_experimentFile];
    XCTAssertEqual([_experiment.otherFiles count], 1);
}

@end
