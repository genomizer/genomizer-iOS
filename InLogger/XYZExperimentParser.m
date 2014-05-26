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
    // add annotations
    NSArray *annotationsArray = [json  valueForKey:@"annotations"];
    NSLog(@"created BY: %@", [json objectForKey:@"created by"]);
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
        expFile.name = (NSString *)[file valueForKey:@"filename"];
         NSLog(@"name %@",  expFile.name);
        expFile.uploadedBy = [file valueForKey:@"uploader"];
        expFile.species = [annonDict valueForKey:@"Species"];
        NSLog(@"spicee parser %@",  expFile.species);
        expFile.expID = [file valueForKey:@"expId"];
        NSLog(@"expid %@",  expFile.expID);
        if([file valueForKey:@"grVersion"] != nil){
            expFile.grVersion = [file valueForKey:@"grVersion"];
        }else{
            expFile.grVersion = @"notset";
        }
        NSLog(@"geVersion %@",  expFile.grVersion);
        expFile.author = [file valueForKey:@"author"];
        expFile.date = [file valueForKey:@"date"];
        expFile.metaData = @"astringofmeta";
        [exp.files addExperimentFile:expFile];
    }
    return exp;
}
@end
