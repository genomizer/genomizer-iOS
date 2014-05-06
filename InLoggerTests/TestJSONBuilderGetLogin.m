//
//  JSONBuilderTest.m
//  InLogger
//
//  Created by Marc Armgren on 06/05/14.
//  Copyright (c) 2014 Marc Armgren. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSONBuilder.h"

@interface JSONBuilderTest : XCTestCase

@property NSMutableURLRequest *req;

@end

@implementation JSONBuilderTest

- (void)setUp
{
    [super setUp];
    self.req = [JSONBuilder getLoginJSON:@"Username" withPassword:@"Password"];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testShouldReturnsObject
{
    XCTAssertNotNil(self.req);
}

- (void)testShouldReturnNSMutableURLRequest
{
    XCTAssertEqual([NSMutableURLRequest class], [[JSONBuilder getLoginJSON:@"Username" withPassword:@"Password"] class]);
}

- (void) testShouldParseWithoutError
{
    NSData *postData = [self.req HTTPBody];
    NSError *error;
    [NSJSONSerialization JSONObjectWithData:postData options:0 error:&error];
    XCTAssertNil(error);
}

- (void) testShouldContainBody
{
    NSData *postData = [self.req HTTPBody];
    XCTAssertNotNil(postData);
}

- (void) testBodyShouldContainUsername
{
    NSData *postData = [self.req HTTPBody];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:postData options:0 error:nil];
    NSString *username = [dict objectForKey:@"username"];
    XCTAssertEqualObjects(username, @"Username");
}

- (void) testBodyShouldNotContainUSERNAME
{
    NSData *postData = [self.req HTTPBody];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:postData options:0 error:nil];
    NSString *username = [dict objectForKey:@"username"];
    XCTAssertNotEqualObjects(username, @"USERNAME");
}

- (void) testBodyShouldContainPassword
{
    NSData *postData = [self.req HTTPBody];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:postData options:0 error:nil];
    NSString *password = [dict objectForKey:@"password"];
    XCTAssertEqualObjects(password, @"Password");
}

- (void) testBodyShouldNotContainPASSWORD
{
    NSData *postData = [self.req HTTPBody];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:postData options:0 error:nil];
    NSString *password = [dict objectForKey:@"password"];
    XCTAssertNotEqualObjects(password, @"PASSWORD");
}


- (void) testShouldReportCorrectBodySize
{
    NSData *postData = [self.req HTTPBody];
    NSString *lengthFromReq = [self.req valueForHTTPHeaderField:@"Content-Length"];
    XCTAssertEqual(postData.length, [lengthFromReq intValue]);
}

- (void) testHTTPMethodShouldBePost
{
    XCTAssertEqualObjects(self.req.HTTPMethod, @"POST");
}

- (void) testShouldHandleEmptyLoginAndPassword
{
    NSMutableURLRequest *testReq = [JSONBuilder getLoginJSON:nil withPassword:nil];
    NSData *body = [testReq HTTPBody];
    XCTAssertNotNil(body);
}

@end
