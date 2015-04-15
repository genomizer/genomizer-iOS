//
//  FileAboutView.h
//  Genomizer
//
//  Created by Pål Forsberg on 2015-04-14.
//  Copyright (c) 2015 Pål Forsberg. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class FileAboutView : UIView ;
//@protocol FileAboutViewDelegate <NSObject>
//-(void)fileAboutViewDidClose:(FileAboutView *)fav;
//
//@end
@interface FileAboutView : UIView
//{
//    id<FileAboutViewDelegate>delegate;
//}
//@property (nonatomic, retain) id<FileAboutViewDelegate>delegate;
-(void)setText:(NSString *)text;
@end
