//
//  FileAboutView.m
//  Genomizer
//
//  Created by Pål Forsberg on 2015-04-14.
//  Copyright (c) 2015 Pål Forsberg. All rights reserved.
//

#import "FileAboutView.h"

@implementation FileAboutView


-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        UILabel *headerLabel = ({
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
            l.text = @"File About";
            l.textAlignment = NSTextAlignmentCenter;
            l.textColor = [UIColor blackColor];
            l;
        });
        
        UITextView *infoView = ({
            UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(0, 40, frame.size.width, frame.size.height - 80)];
            tv;
        });
        
        UIButton *closeButton = ({
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            b.frame = CGRectMake(0, frame.size.height-40, frame.size.width, 40);
            [b setTitle:@"Close" forState:UIControlStateNormal];
            [b addTarget:self action:@selector(closeButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
            b;
        });
        
        [self addSubview:infoView];
        [self addSubview:headerLabel];
        [self addSubview:closeButton];
    }
    
    return self;
}

-(void)closeButtonWasTapped:(UIButton *)b{
    [self removeFromSuperview];
}
@end
