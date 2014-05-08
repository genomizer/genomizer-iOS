//
//  TestExperimentParser.m
//  InLogger
//
//  Created by Patrik Nordström on 07/05/14.
//  Copyright (c) 2014 Patrik Nordström. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XYZExperimentParser.h"
#import "XYZExperiment.h"

@interface TestExperimentParser : XCTestCase

@end

@implementation TestExperimentParser

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExpParserShouldReturnXYZExperiment
{
    XCTAssertEqual([XYZExperiment class], [[XYZExperimentParser expParser:nil] class]);
}

- (void)testExpParserShouldHandleAndReturnExperimentWithNameYuri
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"yuri", @"name", nil];
    XYZExperiment *exp = [XYZExperimentParser expParser:dict];
    XCTAssertEqualObjects(exp.name, @"yuri");
}

- (void)testExpParserShouldReturnExperimentWithCreatorYuri
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"yuri", @"created by", nil];
    XYZExperiment *exp = [XYZExperimentParser expParser:dict];
    XCTAssertEqualObjects(exp.createdByUser, @"yuri");
}

- (void)testExpParserShouldHandleAnnotations
{
    NSDictionary *annotations = [[NSDictionary alloc] initWithObjectsAndKeys:@"sex", @"name",
                                                                             @"male", @"value", nil];
    NSMutableArray *anno = [[NSMutableArray alloc] init];
    [anno addObject:annotations];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:anno, @"annotations", nil];
    XYZExperiment *exp = [XYZExperimentParser expParser:dict];
    XCTAssertEqualObjects([exp getValueForAnnotation:@"sex"], @"male");
}

- (void)testExpParserShouldHandleMultipleAnnotations
{
    NSDictionary *annotation1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"sex", @"name",
                                                                             @"male", @"value", nil];
    NSDictionary *annotation2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"stage", @"name",
                                                                             @"larvae", @"value", nil];
    NSMutableArray *anno = [[NSMutableArray alloc] init];
    [anno addObject:annotation1];
    [anno addObject:annotation2];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:anno, @"annotations", nil];
    XYZExperiment *exp = [XYZExperimentParser expParser:dict];
    XCTAssertEqualObjects([exp getValueForAnnotation:@"sex"], @"male");
    XCTAssertEqualObjects([exp getValueForAnnotation:@"stage"], @"larvae");
}

- (void)testExpParserShouldHandleOneHundredThousandAnnotations {
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    
    //setup one hundred annotations
    NSString *annotationValue;
    NSDictionary *annotation;
    for(int i = 0; i < 100000; i++){
        annotationValue = [NSString stringWithFormat:@"%d", i];
        annotation = [[NSMutableDictionary alloc] initWithObjectsAndKeys:annotationValue, @"name",
                                                                         annotationValue, @"value",
                                                                         nil];
        [arrayOfDicts addObject:annotation];
    }
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:arrayOfDicts, @"annotations", nil];
    
    XYZExperiment *exp = [XYZExperimentParser expParser:dict];
    
    for(int i = 0; i < 100000; i++){
        annotationValue = [NSString stringWithFormat:@"%d", i];
        XCTAssertEqualObjects([exp getValueForAnnotation:annotationValue], annotationValue);
    }
    
}

- (void)testExpParserNonexistentAnnotationsShouldBeNil
{
    NSDictionary *annotations = [[NSDictionary alloc] initWithObjectsAndKeys:@"sex", @"name",
                                 @"male", @"value", nil];
    NSMutableArray *anno = [[NSMutableArray alloc] init];
    [anno addObject:annotations];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:anno, @"annotations", nil];
    XYZExperiment *exp = [XYZExperimentParser expParser:dict];
    
    XCTAssertNil([exp getValueForAnnotation:@"stage"]);
}

@end
