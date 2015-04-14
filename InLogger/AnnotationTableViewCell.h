//
//  AnnotationTableViewCell.h
//  Genomizer
//
//  Class that describes a cell in the AnnotationTable.
//


#import <UIKit/UIKit.h>

@interface AnnotationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end
