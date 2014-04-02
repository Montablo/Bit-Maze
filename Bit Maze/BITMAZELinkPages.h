//
//  BITMAZELinkPages.h
//  Bit Maze
//
//  Created by Jack on 3/31/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BITMAZELinkPages : SKScene

+(void) homePage : (SKScene *) currentPage;
+(void) storePage : (SKScene *) currentPage;
+(void) settingsPage : (SKScene *) currentPage;
+(void) gamePage : (SKScene *) currentPage;
+(void) scorePage : (SKScene *) currentPage;

@end
