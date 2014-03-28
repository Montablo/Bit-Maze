//
//  BITMAZEHomePage.m
//  Bit Maze
//
//  Created by Jack on 3/26/14.
//  Copyright (c) 2014 Montablo Games. All rights reserved.
//

#import "BITMAZEHomePage.h"
#import "BITMAZEGamePage.h"

@implementation BITMAZEHomePage

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.1 green:0.7 blue:0.4 alpha:1.0];
        
        SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithColor: [SKColor colorWithRed:.8 green:.3 blue:.3 alpha:1.0] size:CGSizeMake(50, 50)];
        playButton.name = @"playButton";
        playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        SKLabelNode *playLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue Light"];
        playLabel.text = @"Play";
        playLabel.name = @"playButton";
        playLabel.fontSize = 20;
        playLabel.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        
        [self addChild:playButton];
        [self addChild:playLabel];
        
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
        [self startGame];
    }
}

-(void) startGame {
    NSLog(@"Game is starting");
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [BITMAZEGamePage sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
