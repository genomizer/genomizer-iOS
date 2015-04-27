//
//  AdvancedSearchView.m
//  Genomizer
//
//  Created by Pål Forsberg on 2015-04-17.
//  Copyright (c) 2015 Mattias. All rights reserved.
//

#import "AdvancedSearchView.h"

@implementation AdvancedSearchView{
    UITextView *textView;
}
@synthesize dimView;
@synthesize delegate = _delegate;
-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = ({
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, frame.size.width, 40)];
            l.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.f];
            l.text = @"Advanced Search";
            l.textAlignment = NSTextAlignmentCenter;
            l;
        });
        textView = ({
            UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(0, 38, frame.size.width, frame.size.height - 84)];
            tv.frame = CGRectInset(tv.frame, 10, 0);
            tv.font = [UIFont fontWithName:@"HelveticaNeue" size:16.f];
            tv.delegate = self;
            tv;
        });
        
        UIButton *close = ({
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            b.frame = CGRectMake(0, textView.frame.origin.y + textView.frame.size.height-4, frame.size.width/2, 44);

            [b addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [b setTitle:@"Close" forState:UIControlStateNormal];
            b.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.f];
            
            [b setTitleColor:[UIColor colorWithRed:74/255.f green:144/255.f blue:226/255.f alpha:1.0]
                    forState:UIControlStateNormal];
            b.showsTouchWhenHighlighted = true;
            b;
        });
        
        UIButton *search = ({
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            b.frame = CGRectMake(frame.size.width/2, textView.frame.origin.y + textView.frame.size.height-4, frame.size.width/2, 44);
            [b addTarget:self action:@selector(searchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [b setTitle:@"Search" forState:UIControlStateNormal];
            b.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.f];
            [b setTitleColor:[UIColor colorWithRed:74/255.f green:144/255.f blue:226/255.f alpha:1.0] forState:UIControlStateNormal];
            b.showsTouchWhenHighlighted = true;
            b;
        });
        
        [self addSubview:titleLabel];
        [self addSubview:textView];
        [self addSubview:close];
        [self addSubview:search];
    }
    return self;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -100);
    }];
    return  true;
}

-(void)setSearchText:(NSString *)text{
    textView.text = text;
}

-(NSString *)getSearchText{
    return textView.text;
}
-(void)closeButtonTapped:(UIButton *)button{
    [self.delegate advancedSearchViewDidClose:self];
}
-(void)searchButtonTapped:(UIButton *)button{
    [self.delegate advancedSearchViewDidSearch:self];
}


-(BOOL)textView:(UITextView *)_textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [_textView resignFirstResponder];
        return NO;
    }
    return true;
}

@end
