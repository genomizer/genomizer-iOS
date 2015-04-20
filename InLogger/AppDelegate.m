//
//  AppDelegate.m
//  Genomizer
//
//  AppDelegate class, in addition to default methods, it also contains:
//  An array of loaded view controllers, methods to keep the array up to date and a method to
//  dismiss all view controllers in the array.
//  Methods for keeping track of the number of background threads created by the app.
//

#import "AppDelegate.h"
#import "LogInViewController.h"
#import "ServerConnection.h"

@implementation AppDelegate

//NSMutableArray* controllers;

- (AppDelegate*) init {
    self = [super init];
    _userIsLoggingOut = NO;
    _numberOfThreadsAlive = 0;
    
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSString *usertoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"];

    UIViewController *vc;
    if(!usertoken){
        vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"];
    } else{
        NSLog(@"token: %@", usertoken);
        [ServerConnection setToken:usertoken];
        vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"home"];
    }
    
    self.window.rootViewController = vc;
    return YES;
}

- (void) restart {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LogInViewController *viewController = (LogInViewController *)[storyboard instantiateViewControllerWithIdentifier:@"login"];
    [self.window setRootViewController:viewController];
}
-(void)resetUserToken{
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"usertoken"];
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//- (int) getNumberOfControllers {
//    return (int)[controllers count];
//}
//
//- (void) addController: (UIViewController*) controller {
//    [controllers addObject:controller];
//}
//
//- (void) popController {
//    [controllers removeLastObject];
//}

//- (bool) threadIsAvailable {
//    
//    if(_numberOfThreadsAlive <= 3)
//    {
//        _numberOfThreadsAlive++;
//        return YES;
//    } else
//    {
//        return NO;
//    }
//}
//
//- (void) threadFinished
//{
//    _numberOfThreadsAlive--;
//}

//- (UIViewController*) getController: (int) index
//{
//    return [controllers objectAtIndex:index];
//}

//- (void) killControllers
//{
//    int length = (int)[controllers count];
//    for(int i = 0; i < length; i++)
//    {
//        NSLog(@"kill Controllers");
//        [[controllers lastObject] dismissViewControllerAnimated:NO completion:nil];
//        [controllers removeObject:[controllers lastObject]];
//    }
//}

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
