//
//  TestAppDelegate.m
//  Genomizer
//
//  Created by Marc Armgren on 22/05/14.
//  Copyright (c) 2014 Marc Armgren. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "LogInViewController.h"

@interface TestAppDelegate : XCTestCase

@end

@implementation TestAppDelegate

AppDelegate *appDelegate;

- (void)setUp
{
    [super setUp];
    appDelegate = [[AppDelegate alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testAppDelegateShouldHandleOneController
//{
//    [appDelegate addController: [[LogInViewController alloc] init]];
//    XCTAssertEqual([appDelegate getNumberOfControllers], 1);
//}
//
//- (void) testAppDelegateShouldHandleTwoControllers
//{
//   [appDelegate addController: [[LogInViewController alloc] init]];
//   [appDelegate addController: [[LogInViewController alloc] init]];
//    XCTAssertEqual([appDelegate getNumberOfControllers], 2);
//}
//
//- (void) testRemoveOneController {
//    [appDelegate addController: [[LogInViewController alloc] init]];
//    [appDelegate popController];
//    XCTAssertEqual([appDelegate getNumberOfControllers], 0);
//}
//
//- (void) testGetControllerReturnsSameObject {
//    UIViewController *originalController = [[LogInViewController alloc] init];
//    [appDelegate addController: originalController];
//    UIViewController *retrievedController = [appDelegate getController: 0];
//    XCTAssertEqual(retrievedController, originalController);
//}
//
//- (void) testKillAndRemoveAllControllers
//{
//    for(int i = 0; i < 100; i++)
//    {
//        [appDelegate addController: [[LogInViewController alloc] init]];
//    }
//    [appDelegate killControllers];
//    XCTAssertEqual([appDelegate getNumberOfControllers], 0);
//}

- (void) testMaxThreadsIsFive
{
    for(int i = 0; i <= 3; i++){
        XCTAssertTrue([appDelegate threadIsAvailable]);
    }
    XCTAssertFalse([appDelegate threadIsAvailable]);
}

- (void) testRemoveOneThread {
    for(int i = 0; i <= 3; i++){
        [appDelegate threadIsAvailable];
    }
    [appDelegate threadFinished];
    XCTAssertTrue([appDelegate threadIsAvailable]);
}

@end
