//
//  AppDelegate.h
//  InLogger
//
//  Created by Joel Viklund on 24/04/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property int numberOfThreadsAlive; 

- (int) getNumberOfControllers;

- (void) restart;

- (void) addController: (UIViewController*) controller;

- (void) popController;

- (UIViewController*) getController: (int) index;

- (void) killControllers;

- (bool) threadIsAvailable;

- (void) threadFinished;

@end
