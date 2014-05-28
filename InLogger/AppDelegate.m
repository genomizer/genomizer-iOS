//
//  AppDelegate.m
//  InLogger
//
//  Created by Joel Viklund on 24/04/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "XYZLogInViewController.h"

@implementation AppDelegate

NSMutableArray* controllers;

- (AppDelegate*) init {
    self = [super init];
    _userIsLoggingOut = NO;
    controllers = [[NSMutableArray alloc] init];
    _numberOfThreadsAlive = 0;
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (void) restart {

    UIStoryboard *storyboard =
        [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    XYZLogInViewController *viewController = (XYZLogInViewController *)[storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    [self.window setRootViewController:viewController];
}

- (int) getNumberOfControllers {
    return [controllers count];
}

- (void) addController: (UIViewController*) controller {
    [controllers addObject:controller];
}

- (void) popController {
   // UIViewController *tempController =[controllers objectAtIndex:[controllers count] - 1];
    //[tempController dismissViewControllerAnimated:NO completion:nil];
    [controllers removeLastObject];
}

- (bool) threadIsAvailable {
    
    if(_numberOfThreadsAlive <= 3)
    {
        _numberOfThreadsAlive++;
        return YES;
    } else
    {
        return NO;
    }
}

- (void) threadFinished
{
    _numberOfThreadsAlive--;
}

- (UIViewController*) getController: (int) index
{
    return [controllers objectAtIndex:index];
}

- (void) killControllers
{
    int length = [controllers count];
    for(int i = 0; i < length; i++)
    {
        NSLog(@"kill Controllers");
        [[controllers lastObject] dismissViewControllerAnimated:NO completion:nil];
        [controllers removeObject:[controllers lastObject]];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
