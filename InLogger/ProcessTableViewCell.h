//
//  ProcessTableViewCell.h
//  Genomizer
//
//  Class that represents one cell in the tableview. 
//

#import <UIKit/UIKit.h>

@interface ProcessTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *file;
@property (weak, nonatomic) IBOutlet UILabel *process;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *added;
@property (weak, nonatomic) IBOutlet UILabel *started;
@property (weak, nonatomic) IBOutlet UILabel *finished;
@property (weak, nonatomic) IBOutlet UILabel *noProcesses;

@end
