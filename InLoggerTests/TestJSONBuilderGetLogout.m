//
//  TestJSONBuilderGetLogout.m
//  InLogger
//
//  Created by Marc Armgren on 06/05/14.
//  Copyright (c) 2014 Marc Armgren. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSONBuilder.h"

@interface TestJSONBuilderGetLogout : XCTestCase

@property NSMutableURLRequest *req;

@end

@implementation TestJSONBuilderGetLogout

- (void)setUp
{
    [super setUp];
    self.req = [JSONBuilder getLogoutJSON:@"token"];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testJSONBuilderGetLogoutJSONShouldNotReturnNil
{
    XCTAssertNotNil(self.req);
}

- (void)testJSONBuilderGetLogoutJSONShouldHaveLoginURL
{
    NSURL *url = [self.req URL];
    XCTAssertEqualObjects([url absoluteString], @"http://genomizer.apiary-mock.com/login");
}


@end
