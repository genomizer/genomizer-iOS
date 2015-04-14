//
//  TestExperimentParser.m
//  InLogger
//
//  Created by Patrik Nordström on 07/05/14.
//  Copyright (c) 2014 Patrik Nordström. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ExperimentParser.h"
#import "Experiment.h"

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

- (void)testExpParserShouldReturnExperiment
{
    XCTAssertEqual([Experiment class], [[ExperimentParser expParser:nil] class]);
}

- (void)testExpParserShouldHandleAndReturnExperimentWithNameYuri
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"yuri", @"name", nil];
    Experiment *exp = [ExperimentParser expParser:dict];
    XCTAssertEqualObjects(exp.name, @"yuri");
}

- (void)testExpParserShouldReturnExperimentWithCreatorYuri
{
    NSDictionary *dict = @{@"created by":@"yuri"};//[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"yuri", @"created by", nil];
    Experiment *exp = [ExperimentParser expParser:dict];
    XCTAssertEqualObjects(exp.createdByUser, @"yuri");
}

- (void)testExpParserShouldHandleAnnotations
{
    NSDictionary *annotations = @{@"name":@"value", @"sex":@"female"};
    NSArray *anno = @[annotations];
    
    NSDictionary *dict = @{@"annotations":anno};
    Experiment *exp = [ExperimentParser expParser:dict];
    XCTAssertEqualObjects([exp getValueForAnnotation:@"sex"], @"female");
}

- (void)testExpParserShouldHandleMultipleAnnotations
{
    NSDictionary *annotation1 = @{@"name":@"value", @"sex":@"female"};
    NSDictionary *annotation2 = @{@"stage":@"larvae", @"name":@"value"};
    NSArray *anno = @[annotation1, annotation2];

    NSDictionary *dict = @{@"annotations":anno};
    Experiment *exp = [ExperimentParser expParser:dict];
    XCTAssertEqualObjects([exp getValueForAnnotation:@"sex"], @"female");
    XCTAssertEqualObjects([exp getValueForAnnotation:@"stage"], @"larvae");
}

- (void)testExpParserShouldHandleOneHundredThousandAnnotations {
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    
    //setup one hundred annotations
    NSString *annotationValue;
    NSDictionary *annotation;
    for(int i = 0; i < 100000; i++){
        annotationValue = [NSString stringWithFormat:@"%d", i];
        annotation = @{@"name": annotationValue, @"value":annotationValue};
        [arrayOfDicts addObject:annotation];
    }
    
    NSDictionary *dict = @{@"annotations":arrayOfDicts};//[[NSDictionary alloc] initWithObjectsAndKeys:arrayOfDicts, @"annotations", nil];
    
    Experiment *exp = [ExperimentParser expParser:dict];
    
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
    Experiment *exp = [ExperimentParser expParser:dict];
    
    XCTAssertNil([exp getValueForAnnotation:@"stage"]);
}

@end
