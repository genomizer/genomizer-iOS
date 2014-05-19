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

@end

@implementation TestProcessStatusDescriptor

- (void)setUp
{
    [super setUp];
    
    _descriptor = [[ProcessStatusDescriptor alloc] init];
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


- (void)testExample
{
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
