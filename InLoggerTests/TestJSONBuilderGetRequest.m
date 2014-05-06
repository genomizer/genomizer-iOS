//
//  TestJSONBuilderLogout.m
//  InLogger
//
//  Created by Marc Armgren on 06/05/14.
//  Copyright (c) 2014 Marc Armgren. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSONBuilder.h"

@interface TestJSONBuilderLogout : XCTestCase

@property NSMutableURLRequest *req;

@end

@implementation TestJSONBuilderLogout

- (void)setUp
{
    [super setUp];
    self.req = [JSONBuilder getRequest:@"POST" withToken:@"token"];
}

- (void)tearDown
{
    [super tearDown];
}

- (void) testJSONBuilderGetRequestShouldNotReturnNil
{
    XCTAssertNotNil(self.req);
}

- (void) testJSONBuilderGetRequestShouldHaveEmptyBody
{
    NSData *body = [self.req HTTPBody];
    XCTAssertNil(body);
}

- (void) testJSONBuilderGetRequestShouldHaveContentLengthZero
{
    NSString *length = [self.req valueForHTTPHeaderField:@"Content-Length"];
    XCTAssertEqual([length intValue], 0);
}

- (void) testJSONBuilderGetRequestShouldContainRequestType
{
    NSMutableURLRequest *tempReq = [JSONBuilder getRequest:@"PUT" withToken:@"token"];
    XCTAssertEqualObjects([tempReq HTTPMethod], @"PUT");
}

- (void) testJSONBuilderGetRequestShouldContainToken
{
    NSMutableURLRequest *tempReq = [JSONBuilder getRequest:@"PUT" withToken:@"token"];
    NSString *token = [tempReq valueForHTTPHeaderField:@"Authorization"];
    XCTAssertEqualObjects(token, @"token");
}

@end
