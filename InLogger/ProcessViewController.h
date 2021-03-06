//
//  ProcessViewController.h
//  Genomizer
//
//  Class that controlls the processView, the processView shows information
//  about all processes that the server have either completed,
//  started, waiting or processes that have crashed.
//  Each tableViewCell contains information about one process.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ExperimentFile.h"

@interface ProcessViewController : ViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;


@end
