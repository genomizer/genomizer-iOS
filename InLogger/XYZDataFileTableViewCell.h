//
//  XYZDataFileTableViewCell.h
//  Genomizer
//
//  Class that represents a cell in the DataFile tableView.
//

#import <UIKit/UIKit.h>
#import "XYZExperimentFile.h"
#import "XYZDataFileViewController.h"

@interface XYZDataFileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (weak, nonatomic) IBOutlet UILabel *textField;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;


@property XYZExperimentFile *file;
@property XYZDataFileViewController* controller;

@end
