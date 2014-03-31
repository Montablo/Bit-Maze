//
//  BITMAZEFileReader.m
//  Bit Maze
//
//  Created by Jack on 3/31/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import "BITMAZEFileReader.h"

@implementation BITMAZEFileReader

+(NSArray *) getFileLines : (NSString *) fileName {
    
    NSString* fileRoot = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    
    // read everything from text
    NSString* fileContents = [NSString stringWithContentsOfFile:fileRoot encoding:NSUTF8StringEncoding error:nil];
    
    // first, separate by new line
    NSArray* allLinedStrings = [fileContents componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    
    return [NSMutableArray arrayWithArray:allLinedStrings];
    
}

+(BOOL) storeFileLines : (NSMutableArray *) fileLines inFile : (NSString *) fileName {
    
    NSString *fileRoot = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    
    for(int i=0; i<fileLines.count; i++) {
        NSString *line = fileLines[i];
        
        [line writeToFile:fileRoot atomically:YES];
    }
    return true;
    //return [fileLines writeToFile:fileRoot atomically:YES];
}


@end
