//
//  TestExperimentFile.m
//  InLogger
//
//  Created by Joel Viklund on 06/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ExperimentFile.h"
#import "ExperimentParser.h"

@interface TestExperimentFile : XCTestCase

@property ExperimentFile *experimentFile;

@end

@implementation TestExperimentFile

- (void)setUp
{
    [super setUp];
    _experimentFile = [[ExperimentFile alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    _experimentFile = nil;
}

- (void) testNSStringFileTypeToEnumFileType
{
    XCTAssertEqual([ExperimentFile NSStringFileTypeToEnumFileType:@"RAW"], RAW);
    XCTAssertEqual([ExperimentFile NSStringFileTypeToEnumFileType:@"profile"], PROFILE);
    XCTAssertEqual([ExperimentFile NSStringFileTypeToEnumFileType:@"rEgIoN"], REGION);
    XCTAssertEqual([ExperimentFile NSStringFileTypeToEnumFileType:@"Ä!Ö#KQ"], OTHER);

}

- (void) testGetDescription
{
    _experimentFile.name = @"Datafile.wig";
    _experimentFile.date = @"2014-04-01";
    _experimentFile.uploadedBy = @"Yuri";
    _experimentFile.type = RAW;
    
    NSString *result = _experimentFile.name;
    
    XCTAssertEqualObjects(result, @"Datafile.wig");
}

- (void) testGetDescription2
{
    _experimentFile.name = @"File.wig";
    _experimentFile.date = @"2014-04-02";
    _experimentFile.uploadedBy = @"Yuri";
    _experimentFile.type = RAW;
    
    NSString *result = _experimentFile.name;
    NSString *correct = @"File.wig";
    
    XCTAssertEqualObjects(result, correct);
}

- (void)testFileSize
{
    NSDictionary *annotations = @{@"name":@"sex", @"value":@"female"};
    NSArray *anno = @[annotations];
    NSDictionary *file = @{@"filesize":@"10MB"};
    NSArray *files = @[file];
    NSDictionary *dict = @{@"annotations":anno, @"files":files};
    Experiment *experiment = [ExperimentParser expParser:dict];
    ExperimentFile *expFile = (ExperimentFile *)[[experiment.files getFiles] firstObject];
    XCTAssertEqualObjects(expFile.filesize, @"10MB");
}


@end
