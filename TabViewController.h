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
#import "AdvancedSearchView.h"

/**
 Child of UITabBarController, handles error messages as well.
 */
@interface TabViewController : UITabBarController <UITabBarControllerDelegate, FileAboutViewDelegate>

@property (strong, nonatomic) AlertWindow *window;
-(void)showInfoAboutFile:(ExperimentFile *)file;
-(void)showPopDownWithTitle:(NSString *)title andMessage:(NSString *)msg type:(NSString *)type;
-(void)showPopDownWithError:(NSError *)error;

-(void)showAdvancedSearchView:(NSString *)searchText delegate:(id<AdvancedSearchViewDelegate>)del;
-(void)zoomViewRestore;
@end
