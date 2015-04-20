//
//  TableViewController.h
//  Genomizer
//
//  The TableViewController contains methods to automatically avoid
//  two segues to be executed at the same time.
//
//  All subclasses of this class must call the corresponding super methods
//  when overriding them.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController


@property (nonatomic, retain, getter=getTabbar) UIViewController *tabBar2Controller;
@end
