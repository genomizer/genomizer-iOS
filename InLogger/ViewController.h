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
#import "NavController.h"

@interface ViewController : UIViewController


@property (nonatomic, retain, getter=getTabbar) TabBar2Controller *tabBar2Controller;
@end
