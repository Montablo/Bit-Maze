//
//  BITMAZEGamePage.h
//  Bit Maze
//
//  Created by Jack on 3/26/14.
//  Copyright (c) 2014 Montablo Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BITMAZEGamePage : SKScene {
    NSMutableArray* patterns; //Stores patterns, read from patterns.txt
    
    NSMutableArray* gameGrid; //Stores curent game grid
}

@end
