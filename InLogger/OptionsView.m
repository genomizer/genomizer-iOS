//
//  OptionsView.m
//  Genomizer
//
//  Created by Pål Forsberg on 2015-04-17.
//  Copyright (c) 2015 Mattias. All rights reserved.
//

#import "OptionsView.h"

@implementation OptionsView{
    NSArray *options;
}

@synthesize dimView;
@synthesize optionsDelegate = _optionsDelegate;
-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        self.scrollEnabled = false;
    }
    return self;
}

-(void)setDataArray:(NSArray *)array{
    options = array;
    [self reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return options.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSString *option = options[indexPath.row];
    cell.textLabel.text = option;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.f];
    cell.textLabel.textColor = [UIColor colorWithRed:74/255.f green:144/255.f blue:226/255.f alpha:1.0];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.text = @"Select task";
    label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.f];
    label.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:label];
    
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor colorWithRed:74/255.f green:144/255.f blue:226/255.f alpha:1.0] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, self.frame.size.width, 50);
    
    return button;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self removeSelf];
    [self.optionsDelegate optionsView:self selectedIndex:indexPath.row];
}
-(void)cancelButtonTapped:(UIButton *)button{

    [self removeSelf];
    [self.optionsDelegate optionsViewDidClose:self];
}

-(void)removeSelf{
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height);
        dimView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [dimView removeFromSuperview];
    }];
}


@end
