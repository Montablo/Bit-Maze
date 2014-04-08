//
//  BITMAZEFileReader.m
//  Bit Maze
//
//  Created by Jack on 4/1/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import "BITMAZEFileReader.h"

@implementation BITMAZEFileReader

+(NSMutableArray*) getArray {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *stringsPlistPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"userdata.plist"];
    
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:stringsPlistPath];
    
    if(array.count == 0) {
        array = [BITMAZEFileReader initializeValues];
        
        [BITMAZEFileReader storeArray:array];
    }
    
    return [NSMutableArray arrayWithArray:array];
    
}

+(BOOL) storeArray:(NSMutableArray *)array {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *stringsPlistPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"userdata.plist"];
    
    return [array writeToFile:stringsPlistPath atomically:YES];
    
}

+(BOOL) clearArray {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *stringsPlistPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"userdata.plist"];
    
    return [[self initializeValues] writeToFile:stringsPlistPath atomically:YES];

}

+(NSMutableArray*) initializeValues{
    NSMutableArray* newArray = [NSMutableArray arrayWithArray:@[[NSMutableArray arrayWithArray:@[]], [NSMutableArray arrayWithArray:@[]]]];
    NSMutableArray* storeSettings = newArray[0];
    
    if(storeSettings.count == 0) {
        [storeSettings addObject:@"0"];
        [storeSettings addObject:@[@"0", @"0", @"0", @"0"]];
    }
    
    NSMutableArray* scoreSettings = newArray[1];
    
    if(scoreSettings.count == 0) {
        [scoreSettings addObject:@[@"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0"]];
    }
    
    return newArray;
}

@end
