//
//  BITMAZELinkPages.m
//  Bit Maze
//
//  Created by Jack on 3/31/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import "BITMAZELinkPages.h"
#import "BITMAZEHomePage.h"
#import "BITMAZEGameStore.h"
#import "BITMAZEGamePage.h"
#import "BITMAZESettingsPage.h"
#import "BITMAZEScorePage.h"

@implementation BITMAZELinkPages

+(void) homePage : (SKScene *) currentPage {
    // Configure the view.
    SKView * skView = (SKView *)currentPage.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene.
    SKScene * scene = [BITMAZEHomePage sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

+(void) storePage : (SKScene *) currentPage {
    // Configure the view.
    SKView * skView = (SKView *)currentPage.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene.
    SKScene * scene = [BITMAZEGameStore sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

+(void) scorePage : (SKScene *) currentPage {
    // Configure the view.
    SKView * skView = (SKView *)currentPage.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene.
    SKScene * scene = [BITMAZEScorePage sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

+(void) settingsPage : (SKScene *) currentPage {
    // Configure the view.
    SKView * skView = (SKView *)currentPage.view;
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [BITMAZESettingsPage sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

+(void) gamePage : (SKScene *) currentPage {
    // Configure the view.
    SKView * skView = (SKView *)currentPage.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene.
    SKScene * scene = [BITMAZEGamePage sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

@end
