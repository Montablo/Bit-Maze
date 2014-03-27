//
//  BITMAZEGamePage.h
//  Bit Maze
//
//  Created by Jack on 3/26/14.
//  Copyright (c) 2014 Montablo Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BITMAZEGamePage : SKScene {
    NSMutableArray* patterns; //Stores patterns, read from patterns.txt
    
    NSMutableArray* gameGrid; //Stores curent game grid, 52 rows, 40 columns, first index is where player is

    BOOL inPattern; //If pattern is currently being generated
    int currentPatternNumber; //The number of the current pattern
    int currentPatternRow; //The next row to be generated
    
    int numberOfPatternsUsed; //The total number of patterns used
}

@end
