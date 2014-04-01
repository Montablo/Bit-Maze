//
//  BITMAZEFileReader.m
//  Bit Maze
//
//  Created by Jack on 3/31/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import "BITMAZEFileReader.h"

@implementation BITMAZEFileReader

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeBool:_coins forKey:@"coins"];
    [coder encodeObject:_powerups    forKey:@"powerups"];
    [coder encodeObject:_scores forKey:@"scores"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    self.coins = [coder decodeBoolForKey:@"coins"];
    NSArray *powerupsArr = [coder decodeObjectForKey:@"powerups"];
    self.powerups   = [[NSMutableArray alloc] initWithArray:powerupsArr copyItems:YES];
    NSArray *scoresArr = [coder decodeObjectForKey:@"scores"];
    self.scores   = [[NSMutableArray alloc] initWithArray:scoresArr copyItems:YES];
    
    return self;
}

@end
