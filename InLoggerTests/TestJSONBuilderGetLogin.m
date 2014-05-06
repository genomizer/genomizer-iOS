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

- (void)testGetLoginJSONShouldReturnsObject
{
    XCTAssertNotNil(self.req);
}

- (void)testGetLoginJSONShouldReturnNSMutableURLRequest
{
    XCTAssertEqual([NSMutableURLRequest class], [[JSONBuilder getLoginJSON:@"Username" withPassword:@"Password"] class]);
}

- (void) testGetLoginJSONBodyShouldParseWithoutError
{
    NSData *postData = [self.req HTTPBody];
    NSError *error;
    [NSJSONSerialization JSONObjectWithData:postData options:0 error:&error];
    XCTAssertNil(error);
}

- (void) testGetLoginJSONShouldContainBody
{
    NSData *postData = [self.req HTTPBody];
    XCTAssertNotNil(postData);
}

- (void) testGetLoginJSONBodyShouldContainUsername
{
    NSData *postData = [self.req HTTPBody];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:postData options:0 error:nil];
    NSString *username = [dict objectForKey:@"username"];
    XCTAssertEqualObjects(username, @"Username");
}

- (void) testGetLoginJSONBodyShouldNotContainUSERNAME
{
    NSData *postData = [self.req HTTPBody];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:postData options:0 error:nil];
    NSString *username = [dict objectForKey:@"username"];
    XCTAssertNotEqualObjects(username, @"USERNAME");
}

- (void) testGetLoginJSONBodyShouldContainPassword
{
    NSData *postData = [self.req HTTPBody];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:postData options:0 error:nil];
    NSString *password = [dict objectForKey:@"password"];
    XCTAssertEqualObjects(password, @"Password");
}

- (void) testGetLoginJSONBodyShouldNotContainPASSWORD
{
    NSData *postData = [self.req HTTPBody];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:postData options:0 error:nil];
    NSString *password = [dict objectForKey:@"password"];
    XCTAssertNotEqualObjects(password, @"PASSWORD");
}


- (void) testGetLoginJSONShouldReportCorrectBodySize
{
    NSData *postData = [self.req HTTPBody];
    NSString *lengthFromReq = [self.req valueForHTTPHeaderField:@"Content-Length"];
    XCTAssertEqual(postData.length, [lengthFromReq intValue]);
}

- (void) testGetLoginJSONSHTTPMethodShouldBePost
{
    XCTAssertEqualObjects(self.req.HTTPMethod, @"POST");
}

- (void) testGetLoginJSONShouldHandleEmptyLoginAndPassword
{
    NSMutableURLRequest *testReq = [JSONBuilder getLoginJSON:nil withPassword:nil];
    NSData *body = [testReq HTTPBody];
    XCTAssertNotNil(body);
}

@end
