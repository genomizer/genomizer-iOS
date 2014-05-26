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
    NSMutableDictionary* annonDict = [NSMutableDictionary dictionary];
    for(NSDictionary *annon in annotationsArray){
        if(([annon valueForKey:@"value"] != nil) && ([annon valueForKey:@"name"] != nil)){
            [annonDict setObject:[annon objectForKey:@"value"] forKey:[annon objectForKey:@"name"]];
        }
    }
    exp.annotations = annonDict;
    
    // add files
    NSArray *filesArray = [json valueForKey:@"files"];
    for(NSDictionary *file in filesArray){
        XYZExperimentFile *expFile = [[XYZExperimentFile alloc] init];
        if([file valueForKey:@"id"] != nil){
            expFile.idFile = [file valueForKey:@"id"];
        }else{
            expFile.idFile = @"Not set!";
        }
        
        if([file valueForKey:@"type"] != nil){
            expFile.type = [XYZExperimentFile NSStringFileTypeToEnumFileType:[file valueForKey:@"type"]];;
        }else{
            expFile.type = [XYZExperimentFile NSStringFileTypeToEnumFileType:@"Other"];
        }
        
        if([file valueForKey:@"filename"] != nil){
            expFile.name = (NSString *)[file valueForKey:@"filename"];
        }else{
            expFile.name = @"Not set!";
        }
        
        if([file valueForKey:@"uploader"] != nil){
            expFile.uploadedBy = [file valueForKey:@"uploader"];
        }else{
            expFile.uploadedBy = @"Not set!";
        }
        
        if([annonDict valueForKey:@"Species"] != nil){
            expFile.species = [annonDict valueForKey:@"Species"];
        }else{
            expFile.species = @"Not set!";
        }
        
        if([file valueForKey:@"expId"] != nil){
            expFile.expID = [file valueForKey:@"expId"];
        }else{
            expFile.expID = @"Not set!";
        }
        
        if([file valueForKey:@"grVersion"] != nil){
            expFile.grVersion = [file valueForKey:@"grVersion"];
        }else{
            expFile.grVersion = @"Not set!";
        }
        if([file valueForKey:@"author"] != nil){
            expFile.author = [file valueForKey:@"author"];
        }else{
            expFile.author = @"Not set!";
        }
        
        if([file valueForKey:@"date"] != nil){
            expFile.date = [file valueForKey:@"date"];
        }else{
            expFile.date = @"Not set!";
        }
        expFile.metaData = @"astringofmeta"; // remove?
        [exp.files addExperimentFile:expFile];
    }
    return exp;
}

+ (NSError*) validateData: (NSDictionary*) data
{
    NSArray *valuesToCheck = [NSArray arrayWithObjects: @"grVersion", @"filename", nil];
    
    for(NSString *value in valuesToCheck)
    {
        if([data objectForKey:value] == nil)
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            NSString *message = [NSString stringWithFormat:@"Server sent invalid data on experiment: %@", data];
            [dict setObject:message forKey:NSLocalizedDescriptionKey];
            return [NSError errorWithDomain:@"invalid data" code:5 userInfo:dict];
        }
    }
    return nil;
}

@end
