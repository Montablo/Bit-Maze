//
//  BITMAZEFileReader.h
//  Bit Maze
//
//  Created by Jack on 4/1/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BITMAZEFileReader : NSObject

+(NSMutableArray*) getArray;
+(BOOL) storeArray : (NSMutableArray*) array;
+(BOOL) clearArray;

@end
