//
//  Process2ViewController.h
//  Genomizer
//
//  Created by Erik Berggren on 25/05/15.
//  Copyright (c) 2015 Mattias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "Process2Cell.h"
#import "TabBar2Controller.h"

@interface Process2ViewController : ViewController<UITableViewDataSource, UITableViewDelegate, OptionsViewDelegate, Process2CellDelegate>

@property (nonatomic, retain) NSArray *filesToProcess;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

-(IBAction)sendProcessRequest:(id)sender;
-(IBAction)addProcessTapped:(id)sender;
-(IBAction)clearTapped:(id)sender;
@end
