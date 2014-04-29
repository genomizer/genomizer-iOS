//
//  XYZExperiment.h
//  InLogger
//
//  Created by Patrik Nordström on 29/04/14.
//  Copyright (c) 2014 Patrik Nordström. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZExperiment : NSObject

@property NSString *experimentName;
@property NSString *createdByUser;
@property NSArray *files;
@property NSArray *annotations;

- (XYZExperiment*) init:NSArray;

@end
