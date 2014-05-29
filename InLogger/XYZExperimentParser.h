//
//  XYZExperimentParser.m
//  Genomizer
//
//  Class that parses experiment data contained in an NSDictionary into an XYZExperiment object.
//  This class is used in ServerConnection to parse search results into usable data.
//


#import <Foundation/Foundation.h>
#import "XYZExperiment.h"
#import "XYZExperimentFile.h"

@interface XYZExperimentParser : NSObject

+(XYZExperiment *) expParser:(NSDictionary*) experimentData;

@end
