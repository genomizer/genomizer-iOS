//
//  XYZExperimentParser.m
//  InLogger
//
//  Created by Linus Öberg on 30/04/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import "XYZExperimentParser.h"


@implementation XYZExperimentParser

+(XYZExperiment*) expParser:(NSDictionary*) json{
    
    XYZExperiment *exp = [[XYZExperiment alloc] init];
    //NSLog(@"adsadsads %@", [json valueForKey:@"name"][0]);
    exp.name = [json valueForKey:@"name"][0];
    exp.createdByUser = [json valueForKey:@"created by"][0];
    
    // add annotations
    NSArray *annotationsArray = [json  valueForKey:@"annotations"];
    NSLog(@"*******2 %@", [json objectForKey:@"created by"]);
    NSMutableDictionary* annonDict = [NSMutableDictionary dictionary];
    for(NSDictionary *annon in annotationsArray){
        [annonDict setObject:[annon objectForKey:@"value"] forKey:[annon objectForKey:@"name"]];
    }
    exp.annotations = annonDict;
    
    // add files
    NSArray *filesArray = [json valueForKey:@"files"];
    for(NSDictionary *file in filesArray){
        XYZExperimentFile *expFile = [[XYZExperimentFile alloc] init];
        expFile.idFile = [file valueForKey:@"id"];
        expFile.type = [XYZExperimentFile NSStringFileTypeToEnumFileType:[file valueForKey:@"type"]];
        expFile.name = (NSString *)[file valueForKey:@"name"];
        expFile.uploadedBy = [file valueForKey:@"uploadedBy"];
        expFile.date = [file valueForKey:@"date"];
        expFile.size = [file valueForKey:@"size"];
        expFile.URL = [file valueForKey:@"URL"];
        [exp addExperimentFile:expFile];
    }
    return exp;
}
@end
