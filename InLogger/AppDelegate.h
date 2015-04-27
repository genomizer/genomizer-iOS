//
//  AppDelegate.h
//  Genomizer
//
//  AppDelegate class, in addition to default methods, it also contains:
//  An array of loaded view controllers, methods to keep the array up to date and a method to
//  dismiss all view controllers in the array.
//  Methods for keeping track of the number of background threads created by the app.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property int numberOfThreadsAlive;

@property bool userIsLoggingOut;



- (void)restart;
- (void)resetUserToken;


@end
