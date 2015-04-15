//
//  FileAboutView.m
//  Genomizer
//
//  Created by Pål Forsberg on 2015-04-14.
//  Copyright (c) 2015 Pål Forsberg. All rights reserved.
//

#import "FileAboutView.h"

@implementation FileAboutView{
    UITextView *infoTextView;
}


-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *headerLabel = ({
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
            l.text = @"File About";
            l.textAlignment = NSTextAlignmentCenter;
            l.textColor = [UIColor blackColor];
            l;
        });
        
        infoTextView = ({
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
        
        [self addSubview:infoTextView];
        [self addSubview:headerLabel];
        [self addSubview:closeButton];
    }
    
    return self;
}

-(void)setText:(NSString *)text{
    infoTextView.text = text;
}
-(void)closeButtonWasTapped:(UIButton *)b{
    [self removeFromSuperview];
}
@end
