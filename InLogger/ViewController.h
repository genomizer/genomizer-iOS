//
//  ViewController.h
//  Genomizer
//
//  The ViewController contains methods to automatically avoid
//  two segues to be executed at the same time.
//
//  All subclasses of this class must call the corresponding super methods
//  when overriding them.
//

#import <UIKit/UIKit.h>
#import "TabBar2Controller.h"
@interface ViewController : UIViewController


@property (nonatomic, retain, getter=getTabbar) UIViewController *tabBar2Controller;
@end
