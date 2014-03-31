//
//  BITMAZEGamePage.h
//  Bit Maze
//
//  Created by Galen and Jack on 3/26/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BITMAZEGamePage : SKScene {
    NSMutableArray* patterns; //Stores patterns, read from patterns.txt
    NSMutableArray* patternOccurences; //Stores [0] starting number and [1] frequency
    
    NSMutableArray* gameGrid; //Stores curent game grid, 52 rows, 40 columns, first index is where player is

    BOOL inPattern; //If pattern is currently being generated
    int currentPatternNumber; //The number of the current pattern
    int currentPatternRow; //The next row to be generated
    
    int numberOfPatternsUsed; //The total number of patterns used
    
    CGSize inGameFrame;
    
    float gameSpeed;
    
    float tileWidth;
    float tileHeight;
    
    BOOL gameHasStarted;
    
    int currentBitX;
    int currentBitY;
    
    float currentBitXFloat;
    float currentBitYFloat;
    
    CGPoint startingPt;
    
    int gameScore; //The current game score
}

typedef enum : uint8_t {
    colliderTypeWall = 1,
    colliderTypeBit = 2,
    colliderTypePowerup = 3,
    colliderTypeCoin = 4
} colliderType;

@property (nonatomic, weak) SKNode *bit;
@property (nonatomic, weak) SKLabelNode *startingTime;

@property (nonatomic, weak) SKLabelNode *scoreLabel;

@end
