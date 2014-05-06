//
//  TestJSONBuilderGetSearch.m
//  InLogger
//
//  Created by Marc Armgren on 06/05/14.
//  Copyright (c) 2014 Marc Armgren. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSONBuilder.h"

@interface TestJSONBuilderGetSearch : XCTestCase

@property NSMutableURLRequest *req;

@end

@implementation TestJSONBuilderGetSearch

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testShouldNotReturnNil
{
    self.req = [JSONBuilder getSearchJSON:@"Anno" withToken:@"token"];
    XCTAssertNotNil(self.req);
}

- (void)testShouldHaveCorrectURL
{
    self.req = [JSONBuilder getSearchJSON:@"Anno" withToken:@"token"];
    NSString *url = [[self.req URL] absoluteString];
    XCTAssertEqualObjects(url, @"http://genomizer.apiary-mock.com/search/annotations=?Anno");
}

- (void)testShouldHandleSpaces
{
    self.req = [JSONBuilder getSearchJSON:@"Anno test" withToken:@"token"];
    NSString *url = [[self.req URL] absoluteString];
    XCTAssertEqualObjects(url, @"http://genomizer.apiary-mock.com/search/annotations=?Anno%20test");
}

- (void)testShouldHandleBrackets
{
    self.req = [JSONBuilder getSearchJSON:@"[Anno]" withToken:@"token"];
    NSString *url = [[self.req URL] absoluteString];
    XCTAssertEqualObjects(url, @"http://genomizer.apiary-mock.com/search/annotations=?%5BAnno%5D");
}

- (void)testShouldHandleParenthesis
{
    self.req = [JSONBuilder getSearchJSON:@"(Anno)" withToken:@"token"];
    NSString *url = [[self.req URL] absoluteString];
    XCTAssertEqualObjects(url, @"http://genomizer.apiary-mock.com/search/annotations=?(Anno)");
}

- (void)testShouldHaveHTTPMethodGET
{
    self.req = [JSONBuilder getSearchJSON:@"(Anno)" withToken:@"token"];
    NSString *httpMethod = self.req.HTTPMethod;
    XCTAssertEqualObjects(httpMethod, @"GET");
}


@end
