//
//  BITMAZEScorePage.m
//  Bit Maze
//
//  Created by Jack on 4/1/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import "BITMAZEScorePage.h"

@implementation BITMAZEScorePage

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        /* Setup your scene here */
        
        [self initializeScores];
        
        //self.backgroundColor = [SKColor colorWithRed:0.1 green:0.7 blue:0.4 alpha:1.0];
        SKSpriteNode *backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"HomePageBackground"];
        backgroundImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        backgroundImage.size = CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
        backgroundImage.zPosition = -1;
        
        SKSpriteNode *homeButton = [SKSpriteNode spriteNodeWithImageNamed:@"home"];
        homeButton.name = @"homeButton";
        homeButton.size = CGSizeMake(50, 50);
        homeButton.position = CGPointMake(CGRectGetMidX(self.frame), 2*(CGRectGetHeight(self.frame)/3));
        
        SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        titleLabel.text = @"High Scores";
        titleLabel.fontSize = 30;
        titleLabel.zPosition = 100;
        float titleY = 2*(CGRectGetHeight(self.frame))/3 + 50;
        titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), titleY);
        
        SKLabelNode *labelLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        labelLabel.text = @"Bit Maze";
        labelLabel.fontSize = 30;
        labelLabel.zPosition = 100;
        labelLabel.position = CGPointMake(CGRectGetMidX(self.frame), titleY+50);
        
        SKSpriteNode *gamecenterButton = [SKSpriteNode spriteNodeWithImageNamed:@"gamecenter"];
        gamecenterButton.name = @"gamecenterButton";
        gamecenterButton.zPosition = 151;
        gamecenterButton.size = CGSizeMake(50, 50);
        gamecenterButton.position = CGPointMake(CGRectGetMidX(self.frame), 30);
        
        [self displayScores];
        
        [self addChild:gamecenterButton];
        [self addChild:titleLabel];
        [self addChild:backgroundImage];
        [self addChild:homeButton];
        [self addChild:labelLabel];
        
        
    }
    
    return self;
}

-(void) initializeScores {
    scoreSettings = [BITMAZEFileReader getArray][1];
    
}

-(void) displayScores {
    NSMutableArray *scoresArr = scoreSettings[0];
    for(int i=0; i<scoresArr.count; i++) {
        
        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        scoreLabel.text = [NSString stringWithFormat:@"%i: %@", (i+1), scoresArr[i]];
        scoreLabel.fontSize = 20;
        scoreLabel.name = @"scoreLabel";
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), (2*(CGRectGetHeight(self.frame))/3 - 75) - (25*i));
        
        [self addChild:scoreLabel];
        
    }
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
    } else if([node.name isEqualToString:@"gamecenterButton"]) {
        [[GameKitHelper sharedGameKitHelper] showLeaderboardOnViewController:self.scene.view.window.rootViewController];
    }
}


@end
