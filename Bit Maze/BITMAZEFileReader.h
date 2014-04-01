//
//  BITMAZEFileReader.h
//  Bit Maze
//
//  Created by Jack on 3/31/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BITMAZEFileReader : NSObject <NSCoding>

@property int coins;
@property (strong, nonatomic) NSMutableArray* powerups;

@property (strong, nonatomic) NSMutableArray* scores;


@property (copy) NSString *docPath;

- (id)init;
- (id)initWithDocPath:(NSString *)docPath;
- (void)saveData;
- (void)deleteDoc;

@end
