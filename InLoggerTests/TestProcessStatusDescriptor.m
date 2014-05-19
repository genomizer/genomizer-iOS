//
//  TestProcessStatusDescriptor.m
//  Genomizer
//
//  Created by Marc Armgren on 19/05/14.
//  Copyright (c) 2014 Marc Armgren. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ProcessStatusDescriptor.h"

@interface TestProcessStatusDescriptor : XCTestCase

@property ProcessStatusDescriptor *descriptor;
@property NSMutableDictionary *dict;

@end

@implementation TestProcessStatusDescriptor


- (void)setUp
{
    [super setUp];
    _descriptor = [[ProcessStatusDescriptor alloc] init];
    _dict = [[NSMutableDictionary alloc] init];
    [_dict setObject:@"Exp1" forKey:@"experimentName"];
    [_dict setObject:@"Finished" forKey:@"status"];
    [_dict setObject:@"yuri" forKey:@"author"];
    [_dict setObject:@"400245668744" forKey:@"timeAdded"];
    [_dict setObject:@"400245668744" forKey:@"timeStarted"];
    [_dict setObject:@"400245668744" forKey:@"timeFinished"];
    NSArray *files = @[@"file1", @"file2"];
    [_dict setObject:files forKey:@"outputFiles"];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testShouldHandleAuthor
{
    _descriptor.author = @"testAuthor";
    XCTAssertEqualObjects(_descriptor.author, @"testAuthor");
}

- (void) testShouldHandleExperimentName
{
    _descriptor.experimentName = @"testName";
    XCTAssertEqualObjects(_descriptor.experimentName, @"testName");
}

- (void) testShouldHandleOneOutputFile
{
    [_descriptor addOutputFile: @"testFileName"];
    XCTAssertEqualObjects([_descriptor getOutputFile:0], @"testFileName");
}

- (void) testShouldHandleTwoOutputFiles
{
    [_descriptor addOutputFile: @"testFile1"];
    [_descriptor addOutputFile: @"testFile2"];
    XCTAssertEqualObjects([_descriptor getOutputFile:0], @"testFile1");
    XCTAssertEqualObjects([_descriptor getOutputFile:1], @"testFile2");
}

- (void) testShouldHandleOutOfBoundsRequest
{
    [_descriptor addOutputFile:@"testFile"];
    XCTAssertNil([_descriptor getOutputFile:2]);
}

- (void) testShouldHandleStatus
{
    _descriptor.status = @"Finished";
    XCTAssertEqualObjects(_descriptor.status, @"Finished");
}


- (void) testShouldHandleTimeAdded
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1400245668744];
    _descriptor.timeAdded = date;
    XCTAssertEqualObjects(_descriptor.timeAdded, [NSDate dateWithTimeIntervalSince1970:1400245668744]);
}

- (void) testShouldHandleTimeStarted
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1400245668756];
    _descriptor.timeStarted = date;
    XCTAssertEqualObjects(_descriptor.timeStarted, [NSDate dateWithTimeIntervalSince1970:1400245668756]);
}

- (void) testShouldHandleTimeFinished
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1400245669756];
    _descriptor.timeFinished = date;
    XCTAssertEqualObjects(_descriptor.timeFinished, [NSDate dateWithTimeIntervalSince1970:1400245669756]);
}

- (void) testShouldHandleTimeNotFinished
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
    _descriptor.timeFinished = date;
    XCTAssertEqualObjects(_descriptor.timeFinished, [NSDate dateWithTimeIntervalSince1970:0]);
}

- (void) testShouldKnowNumberOfOutputFiles
{
    [_descriptor addOutputFile: @"testFile1"];
    [_descriptor addOutputFile: @"testFile2"];
    int number = [_descriptor getNumberOfOutputFiles];
    XCTAssertEqual(number, 2);
}

- (void) testShouldNotAcceptDuplicateOutputFiles
{
    [_descriptor addOutputFile: @"testFile1"];
    [_descriptor addOutputFile: @"testFile1"];
    NSString* answer = [_descriptor getOutputFile:1];
    XCTAssertNil(answer);
}

- (void) testDuplicateFilesShouldReturnNo
{
    bool first = [_descriptor addOutputFile: @"testFile1"];
    bool second = [_descriptor addOutputFile: @"testFile1"];
    
    XCTAssertEqual(first, YES);
    XCTAssertEqual(second, NO);
}

- (void) testCanCreateFromValidDictionaryWithOneValue
{
    [_dict setObject:@"Exp1" forKey:@"experimentName"];
    ProcessStatusDescriptor *desc = [[ProcessStatusDescriptor alloc] init: _dict];
    XCTAssertEqualObjects(desc.experimentName, @"Exp1");
}

- (void) testCanHandleInvalidDictionaryWithoutValues
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    ProcessStatusDescriptor *desc = [[ProcessStatusDescriptor alloc] init: dict];
    XCTAssertNil(desc);
}

- (void) testCanHandleInitWithValidDictionaryWithAllValues
{
    
    ProcessStatusDescriptor* desc = [[ProcessStatusDescriptor alloc] init: _dict];
    
    XCTAssertEqualObjects(desc.experimentName, @"Exp1");
    XCTAssertEqualObjects(desc.status, @"Finished");
    XCTAssertEqualObjects(desc.author, @"yuri");
    XCTAssertEqualObjects(desc.timeAdded, @"400245668744");
    XCTAssertEqualObjects(desc.timeStarted, @"400245668744");
    XCTAssertEqualObjects(desc.timeFinished, @"400245668744");
}

- (void) testCanHandleInitWithoutTimeAdded
{
    [_dict removeObjectForKey:@"timeAdded"];
    ProcessStatusDescriptor* desc = [[ProcessStatusDescriptor alloc] init: _dict];
    XCTAssertNil(desc);
}

- (void) testCanHandleInitWithTestFiles
{
    ProcessStatusDescriptor* desc = [[ProcessStatusDescriptor alloc] init: _dict];
    
    XCTAssertEqual([desc getNumberOfOutputFiles], 2);
}

- (void) testCanHandleInitWithNilTestFiles
{
    [_dict removeObjectForKey:@"outputFiles"];
    ProcessStatusDescriptor* desc = [[ProcessStatusDescriptor alloc] init: _dict];
    XCTAssertNil(desc);
}


@end
