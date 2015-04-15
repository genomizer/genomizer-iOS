//
//  TabViewController.h
//  Genomizer
//
//  The TabViewController contains methods to automatically avoid
//  two segues to be executed at the same time.
//
//

#import <UIKit/UIKit.h>
#import "FileAboutView.h"
#import "ExperimentFile.h"
#import "AlertWindow.h"

@interface TabViewController : UITabBarController <UITabBarControllerDelegate, FileAboutViewDelegate>

@property (strong, nonatomic) AlertWindow *window;
-(void)showInfoAboutFile:(ExperimentFile *)file;
-(void)showPopUpWithTitle:(NSString *)title andMessage:(NSString *)msg type:(NSString *)type;
-(void)showPopUpWithError:(NSError *)error;
@end
