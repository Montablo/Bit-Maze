//
//  BITMAZEGameStore.m
//  Bit Maze
//
//  Created by Jack on 3/31/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import "BITMAZEGameStore.h"
#import "BITMAZELinkPages.h"
#import "BITMAZEFileReader.h"

@implementation BITMAZEGameStore

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        /* Setup your scene here */
        
        storeSettings = [BITMAZEFileReader getFileLines:@"store"];
        NSString* STRINGnumCoins = storeSettings[0];
        numCoins = STRINGnumCoins.intValue;
        
        //self.backgroundColor = [SKColor colorWithRed:0.1 green:0.7 blue:0.4 alpha:1.0];
        SKSpriteNode *backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"HomePageBackground"];
        backgroundImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        backgroundImage.zPosition = -1;
        backgroundImage.alpha = 0.7;
        
        SKSpriteNode *homeButton = [SKSpriteNode spriteNodeWithImageNamed:@"home"];
        homeButton.name = @"homeButton";
        homeButton.size = CGSizeMake(50, 50);
        homeButton.position = CGPointMake(CGRectGetMidX(self.frame), 2*(CGRectGetHeight(self.frame)/3));
        
        SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        titleLabel.text = @"Bit Maze";
        titleLabel.fontSize = 30;
        titleLabel.zPosition = 100;
        float titleY = 2*(CGRectGetHeight(self.frame))/3 + 50;
        titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), titleY);
        
        SKLabelNode *coinsLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        coinsLabel.text = [NSString stringWithFormat:@"Coins: %i", numCoins];
        coinsLabel.fontSize = 20;
        coinsLabel.position = CGPointMake(CGRectGetMidX(self.frame), titleY - 125);
        
        [self addChild:coinsLabel];
        [self addChild:titleLabel];
        [self addChild:backgroundImage];
        [self addChild:homeButton];
        
        storeSettings[0] = @"150";
        
        [BITMAZEFileReader storeFileLines:storeSettings inFile:@"store"];
        
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    //NSLog(@"Node name where touch began: %@", node.name);
    
    if ([node.name isEqualToString:@"homeButton"]) {
        //Play button is touched
        [BITMAZELinkPages homePage:self];
    }
}

@end
