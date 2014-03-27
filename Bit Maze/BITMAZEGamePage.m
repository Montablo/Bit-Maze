//
//  BITMAZEGamePage.m
//  Bit Maze
//
//  Created by Jack on 3/26/14.
//  Copyright (c) 2014 Montablo Games. All rights reserved.
//

#import "BITMAZEGamePage.h"

@implementation BITMAZEGamePage

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        NSLog(@"Started");
        
        patterns = [NSMutableArray array];
        
        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        
        SKSpriteNode* bit = [SKSpriteNode spriteNodeWithImageNamed:@"0"];
        bit.position = CGPointMake(CGRectGetMidX(self.frame), 100);
        
        [self addChild:bit];
        
        [self initializePatterns];
        
        NSLog(@"%@", patterns);
        
        [self generateGrid];
        
        [self updateScreen];
    }
    return self;
}

-(void) initializePatterns {
    NSString* filePath = @"patterns";
    NSString* fileRoot = [[NSBundle mainBundle] pathForResource:filePath ofType:@"txt"];
    
    // read everything from text
    NSString* fileContents = [NSString stringWithContentsOfFile:fileRoot encoding:NSUTF8StringEncoding error:nil];
    
    // first, separate by new line
    NSArray* allLinedStrings = [fileContents componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];

    BOOL patternHasStarted = NO;
    int patternNumber = 0;
    int rowNumber = 0;
    
    for(int i=0; i<allLinedStrings.count; i++) {
        
        if([allLinedStrings[i]  isEqual: @"START"]) { //if starting line, set up the array
            patternHasStarted = YES;
            
            [patterns addObject: [NSMutableArray array]];
            
        } else if([allLinedStrings[i]  isEqual: @"END"]) { //if end, continue to next pattern
            
            patternHasStarted = NO;
            
            patternNumber ++;
            
            rowNumber = 0;

        } else if(patternHasStarted) {
            [patterns[patternNumber] addObject: [NSMutableArray array]];
            for(int j=0; j<[allLinedStrings[i] length]; j++) {
                NSString* currentChar = [allLinedStrings[i] substringWithRange:NSMakeRange(j, 1)];
                
                [patterns[patternNumber][rowNumber] addObject: currentChar];
            }
            
            rowNumber ++;

        }
    }
}

-(void) updateScreen { //adds the board to the screen
    
    float x = 0;
    float y = 0;
    
    for(int i=0; i<gameGrid.count; i++) {
        for(int j=0; j<gameGrid[i]; j++) {
            NSString* type = gameGrid[i][j];
            
            
            
            if([type isEqual : @"1"]) { //wall
                
            }
        }
    }
}

-(void) generateGrid { //a method that can be used for initial board generation and in game generation
    while(gameGrid.count < NUM_ROWS) {
        
        if(!inPattern) {
            
            inPattern = YES;
            currentPatternNumber = [self selectNewPatternNumber];
            currentPatternRow = 0;
            numberOfPatternsUsed ++;
            
        }
        
        NSMutableArray* nextRow = patterns[currentPatternNumber][currentPatternRow];
        
        [gameGrid addObject : nextRow];
        
    }
}

-(int) selectNewPatternNumber { //Generates a random pattern number, in the future may take frequency and starting number into considerasion
    newPatternNumber = arc4random() % (patterns.count - 1);
    
    if(patterns[newPatternNumber].count == 0) {
        return [self selectNewPatternNumber];
    }
    
    return newPatternNumber;
}

@end
