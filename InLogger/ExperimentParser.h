//
//  ExperimentParser.m
//  Genomizer
//
//  Class that parses experiment data contained in an NSDictionary into an Experiment object.
//  This class is used in ServerConnection to parse search results into usable data.
//


#import <Foundation/Foundation.h>
#import "Experiment.h"
#import "ExperimentFile.h"

@interface ExperimentParser : NSObject

+(Experiment *) expParser:(NSDictionary*) experimentData;

@end
