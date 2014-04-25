//
//  BITMAZEGameStore.m
//  Bit Maze
//
//  Created by Galen & Jack on 3/31/14.
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
        
        [self updateCoins];
        
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
    
    /*SKSpriteNode* vert_line = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:CGSizeMake(0.5, CGRectGetMaxY(self.frame)/2 - (380.0 - CGRectGetMaxY(self.frame)/4))];
    [vert_line setPosition:CGPointMake(CGRectGetMidX(self.frame) + 51, 403.0)];
    [self addChild:vert_line];
    
    SKSpriteNode* vert_line2 = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:CGSizeMake(0.5, CGRectGetMaxY(self.frame)/2 - (380.0 - CGRectGetMaxY(self.frame)/4))];
    [vert_line2 setPosition:CGPointMake(CGRectGetMidX(self.frame) - 51, 403.0)];
    [self addChild:vert_line2];
    
    //Adds powerup and theme labels (SAVING FOR NEXT UPDATE)
    
    SKLabelNode* powerup_label = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
    powerup_label.text = @"Powerups";
    powerup_label.fontSize = 25;
    powerup_label.name = @"powerup_label";
    powerup_label.fontColor = [SKColor blackColor];
    [powerup_label setPosition:CGPointMake(CGRectGetMidX(self.frame), 380.0)];
    [self addChild:powerup_label];
    
    SKLabelNode* theme_label = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
    theme_label.text = @"Themes ";
    theme_label.fontSize = 25;
    theme_label.name = @"theme_label";
    theme_label.fontColor = [SKColor blackColor];
    [theme_label setPosition:CGPointMake(CGRectGetMidX(self.frame) + 97, 380.0)];
    [self addChild:theme_label];
    
    SKLabelNode* more_label = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
    more_label.text = @"More ";
    more_label.fontSize = 25;
    more_label.name = @"more_label";
    more_label.fontColor = [SKColor blackColor];
    [more_label setPosition:CGPointMake(CGRectGetMidX(self.frame) - 97, 380.0)];*/
    
    SKLabelNode* store_label = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
    store_label.text = @" Store ";
    store_label.fontSize = 40;
    store_label.name = @"store_label";
    store_label.fontColor = [SKColor blackColor];
    [store_label setPosition:CGPointMake(CGRectGetMidX(self.frame), 380.0)];
    
    [self addChild:store_label];
    
    //adds each powerup option
    
    [self displayCurrentItem];
    
    [self addArrows];
    
}

-(void) addArrows {
    
    SKSpriteNode *arrow1 = [SKSpriteNode spriteNodeWithImageNamed:@"Arrow1"];
    arrow1.size = CGSizeMake(40, 40);
    arrow1.name = @"forwardArrow";
    
    arrow1.position = CGPointMake(260, 100);
    
    [self addChild:arrow1];
    
    SKSpriteNode *arrow2 = [SKSpriteNode spriteNodeWithImageNamed:@"Arrow2"];
    arrow2.size = CGSizeMake(40, 40);
    arrow2.name = @"backArrow";
    
    arrow2.position = CGPointMake(210, 100);
    
    [self addChild:arrow2];
}

-(void) displayCurrentItem {
    
    SKLabelNode* currentName = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
    currentName.text = powerupDefaults[currentItem][0];
    currentName.fontSize = 30;
    currentName.name = @"itemDesc";
    currentName.fontColor = [SKColor blackColor];
    [currentName setPosition:CGPointMake(CGRectGetMidX(self.frame), 330.0)];
    [self addChild:currentName];
    
    int currentNum = [storeSettings[1][currentItem] intValue];
    
    NSString *desc = powerupDefaults[currentItem][1][currentNum][1];
    
    NSArray *descArray = [desc componentsSeparatedByString:@" "];
    
    NSUInteger halfLength = desc.length / 2;
    NSUInteger currentLength = 0;
    
    NSMutableArray *firstLine = [NSMutableArray array];
    NSMutableArray *secondLine = [NSMutableArray array];
    
    BOOL first = YES;
    
    for(int i=0; i<descArray.count; i++) {
        
        NSString *currentWord = descArray[i];
        
        if(first) {
            
            currentLength += currentWord.length;
            
            [firstLine addObject:currentWord];
            
            if(currentLength >= halfLength) {
                first = NO;
            }
        } else {
        
            [secondLine addObject:currentWord];
        }
        
    }
    
    NSString *line1 = [firstLine componentsJoinedByString:@" "];
    NSString *line2 = [secondLine componentsJoinedByString:@" "];
    
    SKLabelNode* currentDescLine1 = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
    currentDescLine1.text = line1;
    currentDescLine1.fontSize = 16;
    currentDescLine1.fontColor = [SKColor blackColor];
    currentDescLine1.name = @"itemDesc";
    
    [currentDescLine1 setPosition:CGPointMake(CGRectGetMidX(self.frame), 300.0)];
    
    if(currentNum == 4) {
        currentDescLine1.text = @"Maximum level.";
    }
    
    [self addChild:currentDescLine1];
    
    SKLabelNode* currentDescLine2 = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
    currentDescLine2.text = line2;
    currentDescLine2.fontSize = 16;
    currentDescLine2.name = @"itemDesc";
    currentDescLine2.fontColor = [SKColor blackColor];
    
    if(currentNum == 4) {
        currentDescLine2.text = @"";
    }
    
    [currentDescLine2 setPosition:CGPointMake(CGRectGetMidX(self.frame), 280.0)];
    [self addChild:currentDescLine2];
    
    
    int cost = [powerupDefaults[currentItem][1][currentNum][0] intValue];
    
    SKSpriteNode* buyButton = [SKSpriteNode spriteNodeWithImageNamed: @"roundButton"];
    buyButton.name = @"buyButton";
    buyButton.zPosition = 10;
    buyButton.position = CGPointMake(CGRectGetMidX(self.frame), 200);
    
    [self addChild:buyButton];
    
    SKLabelNode* buyLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
    buyLabel.name = @"buyButton";
    buyLabel.zPosition = 15;
    buyLabel.fontColor = [SKColor blackColor];
    if(cost > numCoins) {
        buyLabel.fontSize = 15;
        buyLabel.text = @"Not enough coins";
    } else {
        buyLabel.fontSize = 30;
        buyLabel.text = @"Buy";
    }
    
    if(currentNum == 4) {
        buyLabel.text = @"Maximum level.";
        buyLabel.fontSize = 20;
    }
    
    buyLabel.position = CGPointMake(CGRectGetMidX(self.frame), 200);
    
    [self addChild:buyLabel];
    
    SKLabelNode* costLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
    costLabel.name = @"buyButton";
    costLabel.zPosition = 15;
    costLabel.fontSize = 20;
    costLabel.fontColor = [SKColor blackColor];
    costLabel.text = [NSString stringWithFormat:@"%i coins", cost];
    costLabel.position = CGPointMake(CGRectGetMidX(self.frame), 175);
    
    if(currentNum == 4) {
        costLabel.text = @"";
    }
    
    [self addChild:costLabel];
    
}

-(void) initializeStore {
    appSettings = [BITMAZEFileReader getArray];
    
    storeSettings = appSettings[0];
    
    numCoins = [storeSettings[0] intValue];
    
    powerupDefaults = [NSMutableArray array];
    
    themeDefaults = [NSMutableArray array];
    
    currentItem = 0;
    storeType = 0;
    
    //appSettings[0][0] = @"99999";
    
    //[BITMAZEFileReader storeArray:appSettings];
}

-(void) updateItem {
    [self removeCurrentItem];
    
    [self displayCurrentItem];
}

-(void) removeCurrentItem {
    [self enumerateChildNodesWithName:@"itemDesc" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    [self enumerateChildNodesWithName:@"buyButton" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
}

-(void) buyCurrent {
    
    int currentNum = [storeSettings[1][currentItem] intValue];
    
    NSLog(@"%@", storeSettings);
    
    if(currentNum == 3) {
        return;
    }
    
    int cost = [powerupDefaults[currentItem][1][currentNum + 1][0] intValue];
    
    if(numCoins < cost) {
        return;
    }
    
    storeSettings[0] = [NSString stringWithFormat: @"%i", numCoins - cost];
    
    storeSettings[1][currentItem] = [NSString stringWithFormat: @"%i", currentNum + 1];
    
    [BITMAZEFileReader storeArray:appSettings];
    
    [self updateItem];
    
    numCoins = numCoins - cost;
    
    [self updateCoins];
}

-(void) updateCoins {
    [self enumerateChildNodesWithName:@"coinsLabel" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    SKLabelNode *coinsLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
    coinsLabel.text = [NSString stringWithFormat:@"Coins: %i", numCoins];
    coinsLabel.fontSize = 30;
    coinsLabel.name = @"coinsLabel";
    coinsLabel.position = CGPointMake(CGRectGetMidX(self.frame), 0);
    
    [self addChild:coinsLabel];
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
    } else if([node.name isEqualToString:@"backArrow"]) {
        if(currentItem > 0) {
            currentItem--;
            
            [self updateItem];
        }
    } else if([node.name isEqualToString:@"forwardArrow"]) {
        if(storeType == 0) { //powerup
            if(currentItem < powerupDefaults.count - 1) {
                
                currentItem++;
                
                [self updateItem];
            }
        }
        
        if(storeType == 1) { //theme
            if(currentItem < themeDefaults.count - 1) {
                
                currentItem++;
                
                [self updateItem];
                
            }
        }
    } else if([node.name isEqualToString:@"buyButton"]) {
        [self buyCurrent];
    }
}

@end
