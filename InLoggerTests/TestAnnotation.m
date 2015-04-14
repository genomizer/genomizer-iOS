//
//  TestAnnotation.m
//  InLogger
//
//  Created by Joel Viklund on 14/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Annotation.h"

@interface TestAnnotation : XCTestCase

@property Annotation *annotation;

@end

@implementation TestAnnotation

- (void)setUp
{
    [super setUp];
    _annotation = [[Annotation alloc] init];
}

- (void)tearDown
{
    [super tearDown];
    _annotation = nil;
}

- (void)testIsFreeText
{
    _annotation.possibleValues = [[NSArray alloc] initWithObjects:@"freetext", nil];
    XCTAssertTrue([_annotation isFreeText]);
}

- (void)testIsNotFreeText
{
    _annotation.possibleValues = [[NSArray alloc] initWithObjects:@"notfreetext", nil];
    XCTAssertFalse([_annotation isFreeText]);
}

- (void) testMakeUnknownAnnotationToCapitalFirstLetter
{
    _annotation.name = @"unknown";
    NSString *result = [_annotation getFormatedName];
    XCTAssertEqualObjects(@"Unknown", result);
}

- (void) testTwoWordUnknownAnnotation
{
    _annotation.name = @"unknown known";
    NSString *result = [_annotation getFormatedName];
    XCTAssertEqualObjects(@"Unknown Known", result);
    
}

- (void) testFormatKnownAnnotation
{
    _annotation.name = @"pubmedId";
    NSString *result = [_annotation getFormatedName];
    XCTAssertEqualObjects(@"Publication ID", result);
}

- (void) testFormatUnsetAnnotationName
{
    NSString *result = [_annotation getFormatedName];
    XCTAssertEqualObjects(@"?", result);
}

@end
