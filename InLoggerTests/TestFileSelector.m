//
//  TestFileSelector.m
//  Genomizer
//
//  Created by Joel Viklund on 19/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XYZFileSelector.h"

@interface TestFileSelector : XCTestCase

@property XYZFileSelector *selector;

@end

@implementation TestFileSelector

- (void)setUp
{
    [super setUp];
    _selector = [[XYZFileSelector alloc] init];
}

- (void)tearDown
{
    _selector = nil;
    [super tearDown];
}

- (void)testFileIsSelected
{
    XYZExperimentFile *file = [XYZExperimentFile defaultFileWithType:RAW];
    [_selector selectFile:file];
    XCTAssertTrue([_selector fileIsSelected:file]);
}

- (void)testDeselectFile
{
    XYZExperimentFile *file = [XYZExperimentFile defaultFileWithType:RAW];
    [_selector selectFile:file];
    [_selector deselectFile:file];
    XCTAssertFalse([_selector fileIsSelected:file]);
}

- (void)testFileIsNotSelected
{
    XYZExperimentFile *file = [XYZExperimentFile defaultFileWithType:RAW];
    XCTAssertFalse(_selector fileIsSelected:file]);
}

- (void)testNumberOfSelectedFiles
{
    XYZExperimentFile *file = [XYZExperimentFile defaultFileWithType:RAW];
    [_selector selectFile:file];
    XCTAssertEqual([_selector numberOfSelectedFiles], 1);
}

@end
