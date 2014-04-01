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
    
    [[NSFileManager defaultManager] createFileAtPath:fileRoot contents:nil attributes:nil];
    
    NSString *str = @"test";
    [str writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    return true;
}


@end
