//
//  testJSONBuilderGetConversionJSON.m
//  InLogger
//
//  Created by Marc Armgren on 06/05/14.
//  Copyright (c) 2014 Marc Armgren. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <XCTest/XCTest.h>
#import "JSONBuilder.h"

@interface TestJSONBuilderGetConversion : XCTestCase

@property NSMutableURLRequest *req;

@end

@implementation TestJSONBuilderGetConversion

- (void)setUp
{
    [super setUp];
    //(NSMutableURLRequest*)getRawToProfileJSON:(NSString *)token withDict:(NSMutableDictionary*)dict{

    //self.req = [JSONBuilder getRawToProfileJSON:@"fileID" withToken:@"token"];
}

- (void)tearDown
{
    [super tearDown];
}
/*
- (void)testShouldNotReturnNil
{
    XCTAssertNotNil(self.req);
}

- (void)testShouldHaveCorrectURL
{
    NSString *url = [[self.req URL] absoluteString];
    XCTAssertEqualObjects(url, [[JSONBuilder getServerURL] stringByAppendingString:@"/process/rawtoprofile/fileID"]);
}

- (void)testShouldHaveHTTPMethodPUT
{
    NSString *httpMethod = self.req.HTTPMethod;
    XCTAssertEqualObjects(httpMethod, @"PUT");
}
*/

@end
