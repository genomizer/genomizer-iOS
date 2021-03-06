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

@property (nonatomic, retain) IBOutlet UISwitch *switchButton;
@property (nonatomic, retain) IBOutlet UILabel *textField;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) IBOutlet UIButton *starButton;
@property (weak, nonatomic) IBOutlet UILabel *fileSize;
@property (nonatomic, retain) IBOutlet UILabel *numberAddedLabel;

@property ExperimentFile *file;
@property DataFileViewController* controller;

@end
