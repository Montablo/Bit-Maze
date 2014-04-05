//
//  BITMAZEGameStore.h
//  Bit Maze
//
//  Created by Jack on 3/31/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BITMAZEGameStore : SKScene {

    NSMutableArray *appSettings;
    
    NSMutableArray* storeSettings;
    int numCoins;

    NSMutableArray *powerupDefaults;
    NSMutableArray *themeDefaults;
    
    int currentItem;
    int storeType; //powerup or theme
}

@end
