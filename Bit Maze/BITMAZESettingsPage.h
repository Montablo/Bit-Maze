//
//  BITMAZESettingsPage.h
//  Bit Maze
//
//  Created by Jack on 3/28/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BITMAZEFileReader.h"
#import "AudioPlayer.h"

@interface BITMAZESettingsPage : SKScene {
    NSUserDefaults *defaults;
    
    SKSpriteNode *soundButton;
    SKLabelNode *offsetButton;
    SKLabelNode *resetButton;
    SKLabelNode *injectCoinButton;
}

@end
