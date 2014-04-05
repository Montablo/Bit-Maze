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
        
        [self initializeStore];
        
        [self readStoreDefaults];
        
        [self displayStore];
        
        //self.backgroundColor = [SKColor colorWithRed:0.1 green:0.7 blue:0.4 alpha:1.0];
        SKSpriteNode *backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"HomePageBackground"];
        backgroundImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        backgroundImage.size = CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
        backgroundImage.zPosition = -1;
        
        SKSpriteNode *homeButton = [SKSpriteNode spriteNodeWithImageNamed:@"home"];
        homeButton.name = @"homeButton";
        homeButton.size = CGSizeMake(50, 50);
        homeButton.position = CGPointMake(CGRectGetMidX(self.frame), 2*(CGRectGetHeight(self.frame)/3) + 100);
        
        SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        titleLabel.text = @"Bit Maze";
        titleLabel.fontSize = 30;
        titleLabel.zPosition = 100;
        float titleY = 2*(CGRectGetHeight(self.frame))/3 + 150;
        titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), titleY);
        
        SKLabelNode *coinsLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        coinsLabel.text = [NSString stringWithFormat:@"Coins: %i", numCoins];
        coinsLabel.fontSize = 30;
        coinsLabel.position = CGPointMake(CGRectGetMidX(self.frame), 0);
        
        [self addChild:coinsLabel];
        [self addChild:titleLabel];
        [self addChild:backgroundImage];
        [self addChild:homeButton];
        
    }
    
    return self;
}

-(void) readStoreDefaults {
    
    [self readPowerups];
    [self readThemes];
    
}

-(void) readPowerups {
    NSString* filePath = @"powerups";
    NSString* fileRoot = [[NSBundle mainBundle] pathForResource:filePath ofType:@"txt"];
    
    // read everything from text
    NSString* fileContents = [NSString stringWithContentsOfFile:fileRoot encoding:NSUTF8StringEncoding error:nil];
    
    // first, separate by new line
    NSArray* allLinedStrings = [fileContents componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    
    BOOL inItem = NO;
    
    for(int i=0; i<allLinedStrings.count; i++) {
        NSString *line = allLinedStrings[i];
        
        if(inItem) {
            
            [powerupDefaults addObject:[NSMutableArray array]];
            
            NSMutableArray *currentPowerup = powerupDefaults[powerupDefaults.count - 1];
            
            [currentPowerup addObject:line];
            
            i++;
            
            [currentPowerup addObject:[NSMutableArray array]];
            
            while(![allLinedStrings[i] isEqualToString:@"END"]) {
                
                NSMutableArray *powerupCosts = currentPowerup[1];
                
                [powerupCosts addObject:[NSMutableArray array]];
                
                NSMutableArray *currentArray = powerupCosts[powerupCosts.count - 1];
                
                [currentArray addObject:[NSNumber numberWithInt: [allLinedStrings[i] intValue]]]; //cost
                
                [currentArray addObject:allLinedStrings[i + 1]]; //desc
                
                i += 2;
            }
            
            inItem = NO;
            
        } else if([line isEqualToString:@"START"]) {
            inItem = YES;
        }
    }
    NSLog(@"done");
}

-(void) readThemes {
    
    NSString* filePath = @"themes";
    NSString* fileRoot = [[NSBundle mainBundle] pathForResource:filePath ofType:@"txt"];
    
    // read everything from text
    NSString* fileContents = [NSString stringWithContentsOfFile:fileRoot encoding:NSUTF8StringEncoding error:nil];
    
    // first, separate by new line
    NSArray* allLinedStrings = [fileContents componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    
    BOOL inItem = NO;
    for(int i=0; i<allLinedStrings.count; i++) {
        NSString *line = allLinedStrings[i];
        
        if(inItem) {
            
            if([allLinedStrings[i] isEqualToString:@"END"]) {
                inItem = NO;
                continue;
            }
            
            [themeDefaults[themeDefaults.count - 1] addObject:allLinedStrings[i]];
            
        } else if([line isEqualToString:@"START"]) {
            inItem = YES;
            
            [themeDefaults addObject:[NSMutableArray array]];
        }
    }
    NSLog(@"done");

}

-(void) displayStore {
    //Adds main box
    
    SKSpriteNode *storeBackground = [SKSpriteNode spriteNodeWithImageNamed:@"storeBackground"];
    storeBackground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    storeBackground.size = CGSizeMake(CGRectGetMaxY(self.frame)/2, CGRectGetMaxY(self.frame)/2);
    [self addChild:storeBackground];
    
    //Adds header
    
    SKSpriteNode* horiz_line = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:CGSizeMake(CGRectGetMaxY(self.frame)/2, 0.5)];
    [horiz_line setPosition:CGPointMake(CGRectGetMidX(self.frame), 380.0)];
    [self addChild:horiz_line];
    
    SKSpriteNode* vert_line = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:CGSizeMake(0.5, CGRectGetMaxY(self.frame)/2 - (380.0 - CGRectGetMaxY(self.frame)/4))];
    [vert_line setPosition:CGPointMake(CGRectGetMidX(self.frame) + 50, 403.0)];
    [self addChild:vert_line];
    
    //Adds powerup and theme labels
    
    SKLabelNode* powerup_label = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
    powerup_label.text = @"Powerups";
    powerup_label.fontSize = 35;
    powerup_label.name = @"powerup_label";
    powerup_label.fontColor = [SKColor blackColor];
    [powerup_label setPosition:CGPointMake(CGRectGetMidX(self.frame) - 24, 380.0)];
    [self addChild:powerup_label];
    
    SKLabelNode* theme_label = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
    theme_label.text = @"Themes ";
    theme_label.fontSize = 25;
    theme_label.name = @"theme_label";
    theme_label.fontColor = [SKColor blackColor];
    [theme_label setPosition:CGPointMake(CGRectGetMidX(self.frame) + 93, 380.0)];
    [self addChild:theme_label];
    
    //adds each powerup option
    
    for(int i=0; i < powerupDefaults.count; i++) {
        
        SKLabelNode* currentName = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        currentName.text = powerupDefaults[i][0];
        currentName.fontSize = 20;
        currentName.fontColor = [SKColor blackColor];
        [currentName setPosition:CGPointMake(CGRectGetMaxX(self.frame) - CGRectGetMidY(self.frame), 364.0 - (i * (CGRectGetMaxY(self.frame) / 2 / powerupDefaults.count)))];
        [self addChild:currentName];
        
        int currentNum = [storeSettings[1][i] intValue];
        
        SKLabelNode* currentDesc = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        currentDesc.text = powerupDefaults[i][1][currentNum][1];
        currentDesc.fontSize = 12;
        currentDesc.fontColor = [SKColor blackColor];
        
        [currentDesc setPosition:CGPointMake((CGRectGetMaxX(self.frame) - CGRectGetMidY(self.frame)) + 110, 345.0 - (i * (CGRectGetMaxY(self.frame) / 2 / powerupDefaults.count)))];
        [self addChild:currentDesc];
    }
    
}

-(void) initializeStore {
    storeSettings = [BITMAZEFileReader getArray][0];
    
    numCoins = [storeSettings[0] intValue];
    
    powerupDefaults = [NSMutableArray array];
    
    themeDefaults = [NSMutableArray array];
    
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
