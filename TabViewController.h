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
@interface TabViewController : UITabBarController <UITabBarControllerDelegate, FileAboutViewDelegate>


-(void)showInfoAboutFile:(ExperimentFile *)file;
@end
