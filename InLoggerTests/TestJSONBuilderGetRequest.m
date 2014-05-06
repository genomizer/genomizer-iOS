//
//  TestJSONBuilderLogout.m
//  InLogger
//
//  Created by Marc Armgren on 06/05/14.
//  Copyright (c) 2014 Marc Armgren. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSONBuilder.h"

@interface TestJSONBuilderGetRequest : XCTestCase

@property NSMutableURLRequest *req;

@end

@implementation TestJSONBuilderGetRequest

- (void)setUp
{
    [super setUp];
    self.req = [JSONBuilder getRequest:@"POST" withToken:@"token"];
}

- (void)tearDown
{
    [super tearDown];
}

- (void) testShouldNotReturnNil
{
    XCTAssertNotNil(self.req);
}

- (void) testShouldHaveEmptyBody
{
    NSData *body = [self.req HTTPBody];
    XCTAssertNil(body);
}

- (void) testShouldHaveContentLengthZero
{
    NSString *length = [self.req valueForHTTPHeaderField:@"Content-Length"];
    XCTAssertEqual([length intValue], 0);
}

- (void) testShouldContainRequestType
{
    NSMutableURLRequest *tempReq = [JSONBuilder getRequest:@"PUT" withToken:@"token"];
    XCTAssertEqualObjects([tempReq HTTPMethod], @"PUT");
}

- (void) testShouldContainToken
{
    NSMutableURLRequest *tempReq = [JSONBuilder getRequest:@"PUT" withToken:@"token"];
    NSString *token = [tempReq valueForHTTPHeaderField:@"Authorization"];
    XCTAssertEqualObjects(token, @"token");
}

@end
