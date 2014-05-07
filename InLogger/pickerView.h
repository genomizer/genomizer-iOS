//
//  pickerView.h
//  InLogger
//
//  Created by Linus Öberg on 06/05/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZSearchViewController.h"

@interface pickerView : UIPickerView
@property NSMutableArray *tableCells;
@property NSArray *dataPicker;
@property NSMutableDictionary *annotationsDict;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
