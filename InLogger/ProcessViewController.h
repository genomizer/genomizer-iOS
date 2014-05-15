//
//  ProcessViewController.h
//  Genomizer
//
//  Created by Linus Öberg on 15/05/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZExperimentFIle.h"
@interface ProcessViewController : UIViewController

+ (void) addProcessingExperiment:(XYZExperimentFile *) file;

@end
