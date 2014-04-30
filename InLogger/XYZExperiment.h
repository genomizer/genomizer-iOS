//
//  XYZExperiment.h
//  InLogger
//
//  Created by Patrik Nordström on 29/04/14.
//  Copyright (c) 2014 Patrik Nordström. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZExperiment : NSObject

@property NSString *name;
@property NSString *createdByUser;
@property NSMutableArray *files;
@property NSDictionary *annotations;

- (XYZExperiment*) init:NSArray;
@end
