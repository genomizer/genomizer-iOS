//
//  TestExperimentDescriber.m
//  InLogger
//
//  Created by Joel Viklund on 06/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XYZExperimentDescriber.h"

@interface TestExperimentDescriber : XCTestCase

@property XYZExperimentDescriber *describer;

@end

@implementation TestExperimentDescriber

- (void)setUp
{
    [super setUp];
    _describer = [[XYZExperimentDescriber alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    _describer = nil;
}



@end
