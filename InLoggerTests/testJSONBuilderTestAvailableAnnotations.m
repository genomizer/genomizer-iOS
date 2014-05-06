//
//  testJSONBuilderTestAvailableAnnotations.m
//  InLogger
//
//  Created by Marc Armgren on 06/05/14.
//  Copyright (c) 2014 Marc Armgren. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSONBuilder.h"

@interface testJSONBuilderTestAvailableAnnotations : XCTestCase

@property NSMutableURLRequest *req;

@end

@implementation testJSONBuilderTestAvailableAnnotations

- (void)setUp
{
    [super setUp];
    self.req = [JSONBuilder getAvailableAnnotationsJSON:@"token"];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testShouldHaveCorrectURL
{
    NSString *url = [[self.req URL] absoluteString];
    XCTAssertEqualObjects(url, [[JSONBuilder getServerURL] stringByAppendingString:@"/annotation"]);
}

- (void)testShouldHaveHTTPMethodGET
{
    NSString *httpMethod = self.req.HTTPMethod;
    XCTAssertEqualObjects(httpMethod, @"GET");
}
@end
