//
//  BITMAZEHomePage.m
//  Bit Maze
//
//  Created by Galen and Jack on 3/26/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import "BITMAZEHomePage.h"
#import "BITMAZELinkPages.h"
#import "AudioPlayer.h"
#import "BITMAZEFileReader.h"

@implementation BITMAZEHomePage

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        [BITMAZEFileReader getArray];
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        NSLog(@"%@", [defaults stringForKey:@"sound"]);
        
        if([defaults stringForKey:@"sound"] == nil) {
            [defaults setObject:@"0" forKey:@"sound"];
        }
        
        if([[defaults stringForKey:@"sound"] isEqualToString:@"0"]) {
            
            
            
            [[AudioPlayer defaultAudioPlayer] play];
            
        }
        
        //self.backgroundColor = [SKColor colorWithRed:0.1 green:0.7 blue:0.4 alpha:1.0];
        SKSpriteNode *backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"HomePageBackground"];
        backgroundImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        backgroundImage.zPosition = -1;
        backgroundImage.size = CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
        
        SKSpriteNode *playButton = [SKSpriteNode new];
        playButton.size = CGSizeMake(50, 50);
        playButton.name = @"playButton";
        playButton.position = CGPointMake(CGRectGetWidth(self.frame)/3, CGRectGetMidY(self.frame));
        
        SKSpriteNode *playIcon = [SKSpriteNode spriteNodeWithImageNamed:@"PlayIcon"];
        playIcon.name = @"playButton";
        playIcon.size = CGSizeMake(50, 50);
        playIcon.position = CGPointMake(CGRectGetWidth(self.frame)/3, CGRectGetMidY(self.frame));
        
        SKSpriteNode *settingIcon = [SKSpriteNode spriteNodeWithImageNamed:@"GearIcon"];
        settingIcon.name = @"settingButton";
        settingIcon.size = CGSizeMake(50, 50);
        settingIcon.position = CGPointMake(2*(CGRectGetWidth(self.frame)/3), CGRectGetMidY(self.frame));
        
        SKSpriteNode *titleImage = [SKSpriteNode spriteNodeWithImageNamed:@"BitMazeTitle"];
        titleImage.size = CGSizeMake(300, 80);
        float titleY = 2*(CGRectGetHeight(self.frame))/3 + 50;
        titleImage.position = CGPointMake(CGRectGetMidX(self.frame), titleY);
        
        SKSpriteNode *storeButton = [SKSpriteNode spriteNodeWithImageNamed:@"store"];
        storeButton.name = @"storeButton";
        storeButton.zPosition = 151;
        storeButton.size = CGSizeMake(50, 50);
        storeButton.position = CGPointMake(CGRectGetWidth(self.frame)/3, CGRectGetMaxY(self.frame)/3 - 70);
        
        SKSpriteNode *scoreButton = [SKSpriteNode spriteNodeWithImageNamed:@"highscores"];
        scoreButton.name = @"scoreButton";
        scoreButton.zPosition = 151;
        scoreButton.size = CGSizeMake(50, 50);
        scoreButton.position = CGPointMake(2*(CGRectGetWidth(self.frame)/3), CGRectGetMaxY(self.frame)/3 - 70);
        
        //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //if([defaults ])
        
        
        [self addChild:playButton];
        [self addChild:playIcon];
        [self addChild:titleImage];
        [self addChild:backgroundImage];
        [self addChild:settingIcon];
        [self addChild:storeButton];
        [self addChild:scoreButton];
        
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    //NSLog(@"Node name where touch began: %@", node.name);
    
    if ([node.name isEqualToString:@"playButton"]) {
        //Play button is touched
        [BITMAZELinkPages gamePage:self];
    } else if ([node.name isEqualToString:@"settingButton"]) {
        //Settings button is touched
        [BITMAZELinkPages settingsPage:self];
    } else if([node.name isEqualToString:@"storeButton"]) {
        [BITMAZELinkPages storePage:self];
    } else if([node.name isEqualToString:@"scoreButton"]) {
        
        [BITMAZELinkPages scorePage:self];
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
