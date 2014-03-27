//
//  BITMAZEGamePage.m
//  Bit Maze
//
//  Created by Jack on 3/26/14.
//  Copyright (c) 2014 Montablo Games. All rights reserved.
//

#import "BITMAZEGamePage.h"

@implementation BITMAZEGamePage

static int NUM_ROWS = 52;
static int NUM_COLUMNS = 40;
static int TOP_INDENT = 40;
static int BOTTOM_INDENT = 40;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        NSLog(@"Started");
        
        patterns = [NSMutableArray array];
        gameGrid = [NSMutableArray array];
        
        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        
        //SKSpriteNode* bit = [SKSpriteNode spriteNodeWithImageNamed:@"0"];
        //bit.position = CGPointMake(CGRectGetMidX(self.frame), 100);
        
        //[self addChild:bit];
        
        [self initializePatterns];
        
        [self generateGrid];
        
        [self startGame];
        
        [self updateScreen];
    }
    return self;
}

-(void) startGame {
    //gameGrid[0][19] = @"2";
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
    
    float width = [UIScreen mainScreen].bounds.size.width / NUM_COLUMNS;
    float height = ([UIScreen mainScreen].bounds.size.height - (TOP_INDENT + BOTTOM_INDENT)) / NUM_ROWS ;
    
    float y = BOTTOM_INDENT;
    
    for(int i=0; i<gameGrid.count; i++) {
        
        float x = 0;
        y += height;

        NSMutableArray* currentRow = gameGrid[i];
        
        for(int j=0; j<currentRow.count; j++) {
            NSString* type = gameGrid[i][j];
            
            SKSpriteNode* image;
            
            x += width;
            
            if([type isEqual : @"1"]) { //wall
                
                image = [SKSpriteNode spriteNodeWithImageNamed:@"1"];
                
            } else if([type isEqual : @"2"]) { //player
                
                
                NSLog(@"I: %i J: %i", i, j);
                image = [SKSpriteNode spriteNodeWithImageNamed:@"0"];
                
            } else {
                continue;
            }
            
            CGPoint location = CGPointMake(x, y);
            
            CGSize size = CGSizeMake(width, height);
            
            image.size = size;
            
            image.position = location;
            
            [self addChild:image];
            
            
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
            
            NSMutableArray* spaceRow = [NSMutableArray arrayWithObjects: @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil];
            
            
            if(gameGrid.count == 0) {
                spaceRow[NUM_COLUMNS / 2 - 1] = @"2";
            }
            
            [gameGrid addObject : spaceRow];
            
            
        } else {
        
            NSMutableArray* currentPattern = patterns[currentPatternNumber];
            
            NSMutableArray* nextRow = currentPattern[currentPatternRow];
            
            if(gameGrid.count == 0) {
                nextRow[NUM_COLUMNS / 2 - 1] = @"2";
            }
            
            [gameGrid addObject : nextRow];
            
            
            
            if(currentPatternRow == currentPattern.count - 1) { //it was the last row
                inPattern = NO;
            } else {
                currentPatternRow ++;
            }
        
        }
        
    }
}

-(int) selectNewPatternNumber { //Generates a random pattern number, in the future may take frequency and starting number into considerasion
    int newPatternNumber = arc4random() % (patterns.count);
    
    NSMutableArray* pattern = patterns[newPatternNumber];
    if(pattern.count == 0) {
        return [self selectNewPatternNumber];
    }
    
    return newPatternNumber;
}

@end
