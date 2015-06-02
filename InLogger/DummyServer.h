//
//  DummyServer.h
//  Genomizer
//
//  Created by Mattias Scherer on 18/05/15.
//  Copyright (c) 2015 Mattias. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Annotation.h"
#import "Experiment.h"
#import "ProcessStatusDescriptor.h"

@interface DummyServer : NSObject

@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) Experiment *experiment;
@property (nonatomic, strong) NSMutableDictionary *process;
@end
