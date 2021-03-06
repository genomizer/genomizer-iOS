//
//  ExperimentParser.m
//  Genomizer
//
//  Class that parses experiment data contained in an NSDictionary into an Experiment object.
//  This class is used in ServerConnection to parse search results into usable data.
//

#import "ExperimentParser.h"


@implementation ExperimentParser


/**
 * Method that parses experiment data in an NSDictionary into an Experiment object.
 *
 * @param experimentData - the experiment data to be parsed
 * @return Experiment containing the parsesd information
 */
+(Experiment*) expParser:(NSDictionary*) experimentData{
    
    Experiment *exp = [[Experiment alloc] init];
    
    exp.name = [experimentData objectForKey:@"name"];
    if(experimentData[@"created by"] != nil){
        exp.createdByUser = experimentData[@"created by"];
    }
    
    
    // add annotations
    NSArray *annotationsArray = [experimentData  valueForKey:@"annotations"];
    NSMutableDictionary* annonDict = [NSMutableDictionary dictionary];
    for(NSDictionary *annon in annotationsArray){
        if(([annon valueForKey:@"value"] != nil) && ([annon valueForKey:@"name"] != nil)){
            [annonDict setObject:[annon objectForKey:@"value"] forKey:[annon objectForKey:@"name"]];
        }
    }
    exp.annotations = annonDict;
    
    // add files
    NSArray *filesArray = [experimentData valueForKey:@"files"];
    for(NSDictionary *file in filesArray){
        ExperimentFile *expFile = [[ExperimentFile alloc] init];
        if([file valueForKey:@"id"] != nil){
            expFile.idFile = [file valueForKey:@"id"];
        }else{
            expFile.idFile = @"Not set!";
        }
        
        if([file valueForKey:@"type"] != nil){
            expFile.type = [ExperimentFile NSStringFileTypeToEnumFileType:[file valueForKey:@"type"]];;
        }else{
            expFile.type = [ExperimentFile NSStringFileTypeToEnumFileType:@"Other"];
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
            expFile.grVersion = @"nothing";
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

        if ([file valueForKey:@"filesize"] != nil) {
            expFile.filesize = [file valueForKey:@"filesize"];
        } else {
            expFile.filesize = @"0MB";
        }
        
        expFile.metaData = @"astringofmeta"; // remove?
        [exp.files addExperimentFile:expFile];
    }
    return exp;
}

@end
