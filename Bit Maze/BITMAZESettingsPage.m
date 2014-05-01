//
//  BITMAZESettingsPage.m
//  Bit Maze
//
//  Created by Jack on 3/28/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import "BITMAZESettingsPage.h"
#import "BITMAZELinkPages.h"

@implementation BITMAZESettingsPage


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        defaults = [NSUserDefaults standardUserDefaults];
        
        /* Setup your scene here */
        
        //self.backgroundColor = [SKColor colorWithRed:0.1 green:0.7 blue:0.4 alpha:1.0];
        SKSpriteNode *backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"HomePageBackground"];
        backgroundImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        backgroundImage.size = CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
        backgroundImage.zPosition = -1;
        
        /*SKLabelNode *homeLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        homeLabel.text = @"Home";
        homeLabel.name = @"homeButton";
        homeLabel.fontSize = 20;
        homeLabel.position = CGPointMake(CGRectGetMidX(self.frame), 2*(CGRectGetHeight(self.frame)/3));*/
        
        SKSpriteNode *homeButton = [SKSpriteNode spriteNodeWithImageNamed:@"home"];
        homeButton.name = @"homeButton";
        homeButton.size = CGSizeMake(50, 50);
        homeButton.position = CGPointMake(CGRectGetMidX(self.frame), 2*(CGRectGetHeight(self.frame)/3));
        
        SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        titleLabel.text = @"Bit Maze";
        titleLabel.fontSize = 30;
        float titleY = 2*(CGRectGetHeight(self.frame))/3 + 50;
        titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), titleY);
        
        
        if([[defaults stringForKey:@"sound"]  isEqual: @"0"]) {
            soundButton = [SKSpriteNode spriteNodeWithImageNamed:@"soundOn"];
        } else {
            soundButton = [SKSpriteNode spriteNodeWithImageNamed:@"soundOff"];
        }
        
        soundButton.size = CGSizeMake(50, 50);
        soundButton.name = @"soundButton";
        soundButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        [self addChild:titleLabel];
        [self addChild:backgroundImage];
        [self addChild:homeButton];
        [self addChild:soundButton];
        
        offsetButton = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        
        if([[defaults stringForKey:@"offset"]  isEqual: @"0"]) {
            offsetButton.text = @"Offset on.";
        } else {
            offsetButton.text = @"Offset off.";
        }
        
        offsetButton.name = @"offsetButton";
        offsetButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 100);
        
        [self addChild:offsetButton];
        
        
        resetButton = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        resetButton.text = @"Reset game";
        resetButton.name = @"resetButton";
        resetButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 150);
        
        [self addChild:resetButton];
        
        injectCoinButton = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        injectCoinButton.text = @"Inject 100 Coins";
        injectCoinButton.name = @"injectCoinButton";
        injectCoinButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 200);
        
        [self addChild:injectCoinButton];
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
    } else if([node.name isEqualToString:@"soundButton"]) {
        [self toggleSound];
    } else if([node.name isEqualToString:@"offsetButton"]) {
        [self toggleOffset];
    } else if([node.name isEqualToString:@"resetButton"]) {
        [self confirmReset];
    } else if([node.name isEqualToString:@"injectCoinButton"]) {
        NSMutableArray *userArray = [BITMAZEFileReader getArray];
        userArray[0][0] = [NSString stringWithFormat : @"%i", [userArray[0][0] intValue] + 100];
        [BITMAZEFileReader storeArray:userArray];
    }
}

-(void) toggleSound {
    [soundButton removeFromParent];
    
    if([[defaults stringForKey:@"sound"] isEqualToString:@"0"]) {
        [defaults setObject:@"1" forKey:@"sound"];
        
        soundButton = [SKSpriteNode spriteNodeWithImageNamed:@"soundOff"];
        
        NSLog(@"%@", [defaults stringForKey:@"sound"]);
        [[AudioPlayer defaultAudioPlayer] pause];
    } else {
        [defaults setObject:@"0" forKey:@"sound"];
        
        soundButton = [SKSpriteNode spriteNodeWithImageNamed:@"soundOn"];
        
        [[AudioPlayer defaultAudioPlayer] play];
        
    }
    
    soundButton.size = CGSizeMake(50, 50);
    soundButton.name = @"soundButton";
    soundButton.position = CGPointMake(CGRectGetMidX(self.frame), (CGRectGetMidY(self.frame)));
    
    [self addChild:soundButton];
    
}

-(void) toggleOffset {
    
    if([[defaults stringForKey:@"offset"] isEqualToString:@"0"]) {
        [defaults setObject:@"1" forKey:@"offset"];
        
        offsetButton.text = @"Offset off.";
    } else {
        [defaults setObject:@"0" forKey:@"offset"];
        
        offsetButton.text = @"Offset on.";
    }

}

- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger) index {
    if(index == 1) { //wants to reset
        [BITMAZEFileReader clearArray];
    }
}

-(void) confirmReset {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure that you want to reset this game? Everything you have will be deleted, and it cannot be undone."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Yes, Reset Game", nil];
    
    [alert show];
    
}



@end
