//
//  BITMAZEFileReader.h
//  Bit Maze
//
//  Created by Jack on 3/31/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BITMAZEFileReader : NSObject

+(NSMutableArray *) getFileLines : (NSString *) fileName;

+(BOOL) storeFileLines : (NSMutableArray *) fileLines inFile : (NSString *) fileName;

@end
