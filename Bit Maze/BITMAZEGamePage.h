//
//  BITMAZEGamePage.h
//  Bit Maze
//
//  Created by Galen and Jack on 3/26/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>
#import "GameKitHelper.h"

@interface BITMAZEGamePage : SKScene <ADBannerViewDelegate>
{
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
    BOOL gameIsPaused;
    
    int currentBitX;
    int currentBitY;
    
    float currentBitXFloat;
    float currentBitYFloat;
    
    CGPoint startingPt;
    
    int gameScore; //The current game score
    
    int coins;
    
    int currentPowerup;//The number of the current powerup
    int currentKey;
    
    int TOUCH_Y_OFFSET;
    
    NSMutableArray *userArray;
}

@property (nonatomic, weak) SKNode *bit;
@property (nonatomic, weak) SKLabelNode *startingTime;

@property (nonatomic, strong) SKSpriteNode *pauseButton;

@property (nonatomic, strong) SKLabelNode *scoreLabel;
@property (nonatomic, strong) SKLabelNode *coinLabel;

@property (nonatomic, weak) SKLabelNode *inGridY;
@property (nonatomic, weak) SKLabelNode *inGridX;

@property (nonatomic, strong) SKLabelNode *touchToPlay;
@property (nonatomic, strong) SKSpriteNode *touchImage;

@end
