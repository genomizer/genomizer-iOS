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
    exp.name = [json objectForKey:@"name"];
    exp.createdByUser = [json objectForKey:@"created by"];
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
        expFile.idFile = [file valueForKey:@"fileId"];
        expFile.type = [XYZExperimentFile NSStringFileTypeToEnumFileType:[file valueForKey:@"type"]];
        expFile.name = (NSString *)[file valueForKey:@"filename"];
        expFile.uploadedBy = [file valueForKey:@"uploader"];
        expFile.date = @"2012-02-29"; //[file valueForKey:@"date"];
        [exp addExperimentFile:expFile];
    }
    return exp;
}
@end
