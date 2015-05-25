//
//  TabBar2ControllerViewController.h
//  Genomizer
//
//  Created by Pål Forsberg on 2015-04-17.
//  Copyright (c) 2015 Mattias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileAboutView.h"
#import "ExperimentFile.h"
#import "AlertWindow.h"
#import "AdvancedSearchView.h"

#import "OptionsView.h"
/**
 Child of UITabBarController, handles error messages as well.
 */
//@class TabBar2Controller;
@interface TabBar2Controller : UIViewController <FileAboutViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) AlertWindow *window;
@property (nonatomic, setter=setSelectedViewController:, getter=getSelectedViewController) UIViewController *selectedViewController;
@property (nonatomic, retain) IBOutlet UIView *tabBar;
@property (nonatomic, retain) IBOutlet UIPanGestureRecognizer *panner;
-(void)showInfoAboutFile:(ExperimentFile *)file;
-(void)showPopDownWithTitle:(NSString *)title andMessage:(NSString *)msg type:(NSString *)type;
-(void)showPopDownWithError:(NSError *)error;

-(void)showAdvancedSearchView:(NSString *)searchText delegate:(id<AdvancedSearchViewDelegate>)del;
-(void)zoomViewRestore;
-(void)showOptions:(NSArray *)options delegate:(id<OptionsViewDelegate>)delegate;
-(IBAction)tabbarButtonTapped:(UIButton *)sender;
@end
