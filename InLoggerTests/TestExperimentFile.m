//
//  TestExperimentFile.m
//  InLogger
//
//  Created by Joel Viklund on 06/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XYZExperimentFile.h"
@interface TestExperimentFile : XCTestCase

@property XYZExperimentFile *experimentFile;

@end

@implementation TestExperimentFile

- (void)setUp
{
    [super setUp];
    _experimentFile = [[XYZExperimentFile alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    _experimentFile = nil;
}

- (void) testNSStringFileTypeToEnumFileType
{
    XCTAssertEqual([XYZExperimentFile NSStringFileTypeToEnumFileType:@"RAW"], RAW);
    XCTAssertEqual([XYZExperimentFile NSStringFileTypeToEnumFileType:@"profile"], PROFILE);
    XCTAssertEqual([XYZExperimentFile NSStringFileTypeToEnumFileType:@"rEgIoN"], REGION);
    XCTAssertEqual([XYZExperimentFile NSStringFileTypeToEnumFileType:@"Ä!Ö#KQ"], OTHER);

}

- (void) testGetDescription
{
    _experimentFile.name = @"Datafile.wig";
    _experimentFile.date = @"2014-04-01";
    _experimentFile.uploadedBy = @"Yuri";
    _experimentFile.type = RAW;
    
    NSString *result = [_experimentFile getDescription];
    NSString *correct = @"Datafile.wig  2014-04-01  Yuri";
    
    XCTAssertEqualObjects(result, correct);
}

- (void) testGetDescription2
{
    _experimentFile.name = @"File.wig";
    _experimentFile.date = @"2014-04-02";
    _experimentFile.uploadedBy = @"Yuri";
    _experimentFile.type = RAW;
    
    NSString *result = [_experimentFile getDescription];
    NSString *correct = @"File.wig      2014-04-02  Yuri";
    
    XCTAssertEqualObjects(result, correct);
}

- (void) testGetDescriptionWithUnknownField
{
    _experimentFile.date = @"2014-04-01";
    _experimentFile.uploadedBy = @"Yuri";
    _experimentFile.type = RAW;
    
    NSString *result = [_experimentFile getDescription];
    NSString *correct = @"?             2014-04-01  Yuri";
    NSLog(@"%@", result);
    XCTAssertEqualObjects(result, correct);
}

@end
