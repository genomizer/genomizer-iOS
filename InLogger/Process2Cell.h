//
//  Process2Cell.h
//  Genomizer
//
//  Created by Erik Berggren on 25/05/15.
//  Copyright (c) 2015 Mattias. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Process2Cell;
@protocol Process2CellDelegate <NSObject>
-(void)processCell2:(Process2Cell *)cell didChangeParams:(NSString *)params;

@end
@interface Process2Cell : UITableViewCell<UITextFieldDelegate>{
    id<Process2CellDelegate>delegate;
}

@property (nonatomic, retain) id<Process2CellDelegate>delegate;
@property (nonatomic, retain) IBOutlet UILabel *inFileLabel;
@property (nonatomic, retain) IBOutlet UILabel *outFileLabel;
@property (nonatomic, retain) IBOutlet UITextField *paramTextField;


@end
