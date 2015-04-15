//
//  TestExperimentDescriber.m
//  InLogger
//
//  Created by Joel Viklund on 06/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ExperimentDescriber.h"

@interface TestExperimentDescriber : XCTestCase

@property ExperimentDescriber *describer;
@property Experiment *experiment;
@property Annotation *annotation;
@property Annotation *annotation2;

@end

@implementation TestExperimentDescriber

- (void)setUp
{
    [super setUp];
    _describer = [[ExperimentDescriber alloc] init];
    _experiment = [[Experiment alloc] init];
    _experiment.name = @"Experiment name";
    _experiment.createdByUser = @"Yuri Yuri";
    [_experiment.annotations setValue: @"abc123" forKey:@"pubmedId"];
    [_experiment.annotations setValue: @"raw" forKey:@"type"];
    [_experiment.annotations setValue: @"human" forKey:@"specie"];
    [_experiment.annotations setValue: @"male" forKey: @"sex"];
    _annotation = [[Annotation alloc] init];
    _annotation.name = @"pubmedId";
    _annotation2 = [[Annotation alloc] init];
    _annotation2.name = @"type";
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    _describer = nil;
    _annotation = nil;
    _annotation2 = nil;
}

-(void) testGetDescriptionOfWithDefaultAnnotations
{
    NSString *description = [_describer getDescriptionOf:_experiment];
    NSString *correctDescription = @"Name: Experiment name\nCreated by: Yuri Yuri";
   
    XCTAssertEqualObjects(description, correctDescription);
}

-(void) testAddAnnotation
{
    [_describer showAnnotation:_annotation];
    NSString *description = [_describer getDescriptionOf:_experiment];
    NSString *correctDescription = @"Name: Experiment name\nCreated by: Yuri Yuri\nPublication ID: abc123";
    XCTAssertEqualObjects(description, correctDescription);
}

-(void) testAddTwoAnnotations
{
    [_describer showAnnotation:_annotation];
    [_describer showAnnotation: _annotation2];
    NSString *description = [_describer getDescriptionOf:_experiment];
    NSString *correctDescription = @"Name: Experiment name\nCreated by: Yuri Yuri\nPublication ID: abc123\nType: raw";
    XCTAssertEqualObjects(description, correctDescription);
}

-(void) testRemoveAnnotation
{
    [_describer showAnnotation:_annotation];
    [_describer hideAnnotation:_annotation];
    NSString *description = [_describer getDescriptionOf:_experiment];
    NSString *correctDescription = @"Name: Experiment name\nCreated by: Yuri Yuri";
    XCTAssertEqualObjects(description, correctDescription);
}

-(void) testAddSameAnnotationTwice
{
    _annotation2.name = _annotation.name;
    [_describer showAnnotation:_annotation];
    [_describer showAnnotation:_annotation2];
    NSString *description = [_describer getDescriptionOf:_experiment];
    NSString *correctDescription = @"Name: Experiment name\nCreated by: Yuri Yuri\nPublication ID: abc123";
    XCTAssertEqualObjects(description, correctDescription);
}
/*
-(void) testContainsAnnotation
{
    XCTAssertFalse([_describer containsAnnotation: _annotation]);
    [_describer showAnnotation: _annotation];
    XCTAssertTrue([_describer containsAnnotation: _annotation]);
}
*/
@end
