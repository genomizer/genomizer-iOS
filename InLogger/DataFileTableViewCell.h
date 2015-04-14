//
//  DataFileTableViewCell.h
//  Genomizer
//
//  Class that represents a cell in the DataFile tableView.
//

#import <UIKit/UIKit.h>
#import "ExperimentFile.h"
#import "DataFileViewController.h"

@interface DataFileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (weak, nonatomic) IBOutlet UILabel *textField;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;


@property ExperimentFile *file;
@property DataFileViewController* controller;

@end
