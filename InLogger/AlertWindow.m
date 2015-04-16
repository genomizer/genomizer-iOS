//
//  AlertWindow.m
//  Genomizer
//
//  Created by Pål Forsberg on 2015-04-15.
//  Copyright (c) 2015 Pål Forsberg. All rights reserved.
//

#import "AlertWindow.h"
#import "AppDelegate.h"

typedef enum {
    kDown,
    kUp
} State;

@implementation AlertWindow{
    UIView *view;
    BOOL animating;
    State currentState;
    void (^totalCompletion)();
}

///Red color which should be used to indicate error
#define kErrorColor [UIColor colorWithRed:212/255.f green:41/255.f blue:41/255.f alpha:1.0]


/**
 Inits the AlertWindow with specified text and type.
 @param title the title text which will be displayed in bigger font.
 @param message message text, more describive.
 @param type "error"
 @return AlertWindow reference.
 */
-(id)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)msg type:(NSString *)type{
    
    if(self = [super initWithFrame:frame]){
        animating = false;
        currentState = kUp;
        
        self.windowLevel = UIWindowLevelStatusBar+1;
        self.hidden = false;
        [self makeKeyAndVisible];
        
        UIImage *image = [AlertWindow imageForType:type];
        UIImageView *imageView;
        
        if(image != nil){
            imageView = ({
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
                iv.image = image;
                iv;
            });
        }

        UILabel *titleLabel = ({
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(64, 6, frame.size.width - 52, 20)];
            l.text = title;
            l.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.f];
            l.textAlignment = NSTextAlignmentLeft;
            l.textColor = [UIColor whiteColor];
            l;
        });
        
        UITextView *messageView = ({
            UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(60, 16, frame.size.width - 70, 52)];
            tv.text = msg;
            tv.font = [UIFont fontWithName:@"HelveticaNeue" size:13.f];
            tv.textAlignment = titleLabel.textAlignment;
            tv.textColor = titleLabel.textColor;
            tv.alpha = 0.8;
            tv.backgroundColor = [UIColor clearColor];
            tv.scrollEnabled = false;
            tv.editable = false;
            tv;
        });
        
        view = ({
            UIView *v = [[UIView alloc] initWithFrame:self.bounds];
            v.transform = CGAffineTransformMakeTranslation(0, -v.frame.size.height);
            v.backgroundColor = [AlertWindow colorForType:type];

            [v addSubview:titleLabel];
            [v addSubview:imageView];
            [v addSubview:messageView];
            
            UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView:)];
            [v addGestureRecognizer:tapper];
            v;
        });
        [self addSubview:view];
    }
    
    return self;
}


+(UIImage *)imageForType:(NSString *)type{
    NSString *imageName;
    if([type isEqualToString:@"error"]){
        imageName = @"Error";
    }
    return [UIImage imageNamed:imageName];
}

+(UIColor *)colorForType:(NSString *)type{
    UIColor *color;
    if([type isEqualToString:@"error"]){
        color = kErrorColor;
    }
    return color;
}

-(void)tappedView:(UITapGestureRecognizer *)tapper{
    [self animateUp:0.2 completion:^{
        [self doneAnimating];
    }];
}

-(void)animateDown:(void(^)())completion{
    animating = true;
    [UIView animateWithDuration:0.3 animations:^{
        view.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        animating = false;
        currentState = kDown;
        completion();
    }];
}

-(void)animateUp:(float)duration completion:(void(^)())completion{
    animating = true;
    [UIView animateWithDuration:duration animations:^{
        view.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
    } completion:^(BOOL finished) {
        animating = false;
        currentState = kUp;
        completion();
        
    }];
}


/**
 Animates a alertWindow down, waits for 2 seconds and then animates up. If user dismisses alertwindow after animating up it wont animate up. 
 @param completion block which gets called after alertwindow have disapperad.
 */
-(void)animateDownAndUp:(void(^)())completion{
    totalCompletion = completion;
    [self animateDown:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if(!animating && currentState == kDown){
                [self animateUp:0.4 completion:^{
                    [self doneAnimating];
                }];
            }
        });
    }];
}

-(void)doneAnimating{

    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app.window makeKeyWindow];
    [view removeFromSuperview];
    [self removeFromSuperview];
    self.hidden = true;
    totalCompletion();
}
@end
