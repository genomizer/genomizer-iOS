//
//  OptionsView.h
//  Genomizer
//
//  Created by Pål Forsberg on 2015-04-17.
//  Copyright (c) 2015 Mattias. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OptionsView;
@protocol OptionsViewDelegate <NSObject>

-(void)optionsView:(OptionsView *)ov selectedIndex:(NSUInteger)index;
-(void)optionsViewDidClose:(OptionsView *)ov;

@end
@interface OptionsView : UITableView<UITableViewDataSource, UITableViewDelegate>{
    id<OptionsViewDelegate>optionsDelegate;
}

@property (nonatomic, retain) id<OptionsViewDelegate>optionsDelegate;
@property (nonatomic, retain) UIView *dimView;

-(void)setDataArray:(NSArray *)array;
@end
