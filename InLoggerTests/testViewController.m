//
//  testViewController.m
//  Genomizer
//
//  Created by Erik Berggren on 17/04/15.
//  Copyright (c) 2015 Mattias. All rights reserved.
//
//  A class used to test view controllers

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface testViewController : XCTestCase

@end

@implementation testViewController

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each
    // test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of
    // each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

@end
