//
//  XYZExperimentParser.h
//  InLogger
//
//  Created by Linus Öberg on 30/04/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYZExperiment.h"
#import "XYZExperimentFile.h"

@interface XYZExperimentParser : NSObject

+(XYZExperiment *) expParser:(NSDictionary*) json;

@end
