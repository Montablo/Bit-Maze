//
//  BITMAZEGamePage.m
//  Bit Maze
//
//  Created by Galen and Jack on 3/26/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import "BITMAZEGamePage.h"

@implementation BITMAZEGamePage

static int NUM_ROWS      = 52;
static int NUM_COLUMNS   = 40;
static int TOP_INDENT    = 40;
static int BOTTOM_INDENT = 40;

static float maxSpeed    = .1;
static float speedChange = .99;

static NSString* BIT_IMG  = @"circle";
static NSString* WALL_IMG = @"metal";
static NSString* COIN_IMG = @"coin";

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        NSLog(@"Started");
        
        inGameFrame = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - ((float) TOP_INDENT + BOTTOM_INDENT));
        
        NSLog(@"Width: %f, Height: %f", inGameFrame.width, inGameFrame.height);
        
        patterns = [NSMutableArray array];
        gameGrid = [NSMutableArray array];
        
        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        
        [self initializeVariables];
        
        [self initializeGame];
        
        [self startGame];
    }
    return self;
}

-(void) initializeVariables {
    
    gameSpeed = .3;
    
    gameScore = 0;
    
    patternOccurences = [NSMutableArray array];
    
    tileWidth = [UIScreen mainScreen].bounds.size.width / NUM_COLUMNS;
    tileHeight = ([UIScreen mainScreen].bounds.size.height - (TOP_INDENT + BOTTOM_INDENT)) / NUM_ROWS ;
    
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
    
    self.scoreLabel.text = @"Score: 0";
    self.scoreLabel.fontSize = 15;
    self.scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), 15);
    
    self.scoreLabel.zPosition = 90;
    
    [self addChild:self.scoreLabel];
    
    self.coinLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
    
    self.coinLabel.text = @"Coins: 0";
    self.coinLabel.fontSize = 15;
    self.coinLabel.position = CGPointMake(CGRectGetMidX(self.frame), 0);
    
    self.coinLabel.zPosition = 90;
    
    [self addChild:self.coinLabel];
    
    SKSpriteNode *restartButton = [SKSpriteNode spriteNodeWithImageNamed:@"restart"];
    restartButton.name = @"restartButton";
    restartButton.size = CGSizeMake(15, 15);
    restartButton.position = CGPointMake(15, 15);
    
    [self addChild:restartButton];
}

-(void) initializeGame {
    
    [self initializePatterns];
    
    [self generateGrid];
    
}

-(void) startGame {
    
    /*self.startingTime = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
    
    self.startingTime.fontSize = 30;
    self.startingTime.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    [self addChild:self.startingTime];
    
    for(int i=1; i<4; i++) {
        self.startingTime.text = [NSString stringWithFormat:@"%i", i];
        sleep(1);
    }
    
    [self.startingTime removeFromParent];*/
    
    [self updateScreen];
    
    gameHasStarted = YES;
    
    [self scrollScreen];
    
    
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
            
            [patternOccurences addObject:[NSMutableArray array]];
            
            NSNumber* numberOfPatternsBefore = [NSNumber numberWithInt: [allLinedStrings[i+1] integerValue]];
            [patternOccurences[patternNumber] addObject: numberOfPatternsBefore];
            
            NSNumber* frequency = [NSNumber numberWithInt: [allLinedStrings[i+2] integerValue]];
            [patternOccurences[patternNumber] addObject: frequency];
            
            i += 2;
            
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
    
    [self removeAllOfName:@"wall"];
    
    [self removeAllOfName:@"coin"];
    
    [self removeAllOfName:@"bit"];
    
    float y = BOTTOM_INDENT;
    
    for(int i=0; i<gameGrid.count; i++) {
        
        float x = 0;
        y += tileHeight;
        
        NSMutableArray* currentRow = gameGrid[i];
        
        for(int j=0; j<currentRow.count; j++) {
            NSString* type = gameGrid[i][j];
            
            SKSpriteNode* image;
            
            x += tileWidth;
            
            if([type isEqual : @"1"]) { //wall
                
                image = [SKSpriteNode spriteNodeWithImageNamed:WALL_IMG];
                
                image.name = @"wall";
                
            } else if([type isEqual : @"5"]) {
                image = [SKSpriteNode spriteNodeWithImageNamed : COIN_IMG];
                image.name = @"coin";
            }
            else {
                continue;
            }
            
            CGPoint location = CGPointMake(x, y);
            
            CGSize size = CGSizeMake(tileWidth, tileHeight);
            
            image.size = size;
            
            image.position = location;
            
            [self addChild:image];
            
            
        }
    }
    
    SKSpriteNode* bit;
    
    bit = [SKSpriteNode spriteNodeWithImageNamed: BIT_IMG];
    bit.name = @"bit";
    
    CGPoint location = CGPointMake(currentBitXFloat, currentBitYFloat);
    
    CGSize size = CGSizeMake(tileWidth, tileHeight);
    
    bit.size = size;
    
    bit.position = location;
    
    [self addChild:bit];
    
    self.bit = bit;
}

-(void) generateGrid { //a method that can be used for initial board generation and in game generation
    while(gameGrid.count < NUM_ROWS) {
        
        if(!inPattern) {
            
            inPattern = YES;
            currentPatternNumber = [self selectNewPatternNumber];
            currentPatternRow = 0;
            numberOfPatternsUsed ++;
            
            NSMutableArray* spaceRow = [NSMutableArray arrayWithObjects: @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil];
            
            [gameGrid addObject : [NSMutableArray arrayWithArray:spaceRow]];
            
            if(gameGrid.count == 1) {
                for(int i=0; i<10; i++) {
                    [gameGrid addObject:[NSMutableArray arrayWithArray:spaceRow]];
                }
                
                currentBitY = 3;
                currentBitX = NUM_COLUMNS / 2 - 1;
                
                currentBitYFloat = currentBitY*tileHeight;
                currentBitXFloat = currentBitX*tileWidth;
            }
            
            
        } else {
            
            NSMutableArray* currentPattern = patterns[currentPatternNumber];
            
            NSMutableArray* nextRow = currentPattern[currentPatternRow];
            
            for(int i=0; i<nextRow.count; i++) {
                if([nextRow[i] isEqualToString: @"4"]) {
                    if(arc4random() % 2 == 1) {
                        nextRow[i] = @"0";
                    } else {
                        nextRow[i] = @"5";
                    }
                }
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

-(int) selectNewPatternNumber { //Generates a random pattern number, takes frequency and starting number into considerasion
    NSMutableArray* patternAdj = [NSMutableArray array];
    NSMutableArray* probabilities = [NSMutableArray array];
    int total = 0;
    float sumProbabilities = 0;
    
    for (int i = 0; i < patterns.count; i++) {
        
        NSMutableArray* patternRow = patterns[i];
        
        
        int startingNumber = [patternOccurences[i][0] intValue];
        
        NSNumber* frequencyInt = [NSNumber numberWithInt: [patternOccurences[i][1] intValue]];
        
        if(patternRow.count == 0 && startingNumber > numberOfPatternsUsed) {
            frequencyInt = 0;
        }
        [patternAdj addObject:frequencyInt];
        
        total += [frequencyInt intValue];
        
    }
    
    for(int i = 0; i < patterns.count; i++) {
        NSNumber* patternA = patternAdj[i];
        
        NSNumber* val;
        
        if([patternA floatValue] != 1.0) val = [NSNumber numberWithFloat:sumProbabilities + ([patternA floatValue] / total)];
        else val = 0;
        probabilities[i] = val;
        sumProbabilities += [patternA floatValue] / total;
    }
    
    float randomNumber = arc4random() / ((double) pow(2, 32) - 1);
    
    for(int i=0; i<patterns.count; i++) {
        float firstInt = [probabilities[i] floatValue];
        
        if(i == 0) {
            //Number is selected
            if(randomNumber <= firstInt) return i;
            else continue;
        }
        
        float prev = [probabilities[i-1] floatValue];
        
        if(randomNumber <= firstInt && randomNumber > prev) {
            return i;
        }
    }
    
    //return newPatternNumber;
    return false;
}

-(void) removeAllOfName : (NSString*) name {
    
    [self enumerateChildNodesWithName: name usingBlock:^(SKNode *node, BOOL *stop) {
        /*if(node.position.y <= BOTTOM_INDENT + ([UIScreen mainScreen].bounds.size.height - (TOP_INDENT + BOTTOM_INDENT)) / NUM_ROWS) {
         [node removeFromParent];
         }
         
         if([self.bit intersectsNode:node]) {
         
         }*/
        [node removeFromParent];
    }];
    
}

-(void) scrollScreen{
    if(currentBitY == 0) {
        [self endGame];
        return;
    }
    
    currentBitY--;
    
    currentBitYFloat -= tileHeight;
    
    [gameGrid removeObjectAtIndex:0];
    
    [self generateGrid];
    
    [self updateScreen];
    
    gameSpeed *= speedChange;
    
    if(gameSpeed < maxSpeed) gameSpeed = maxSpeed;
    
    gameScore++;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %i", gameScore];
    
    [self performSelector:@selector(scrollScreen) withObject:nil afterDelay:gameSpeed];
}


-(void) endGame {
    NSLog(@"You lose!");
    //[self resetGame];
}

-(void)touchesMoved:(NSSet*) touches withEvent:(UIEvent*) event
{
    
    CGPoint tappedPt = [[touches anyObject] locationInNode: self];
    
    //Snaps bit to grid
    
    int xInGrid = tappedPt.x / tileWidth; //int type is used so we have an integer value
    int yInGrid = (tappedPt.y - BOTTOM_INDENT) / tileHeight;
    
    float newX = tappedPt.x;
    float newY = tappedPt.y;
    
    if(xInGrid >= NUM_COLUMNS || yInGrid >= NUM_ROWS || xInGrid < 0 || yInGrid < 0) {
        return;
    }
    
    if([self isWallWithX: xInGrid andY: yInGrid]) {
        return;
    }
    
    currentBitX = xInGrid;
    currentBitY = yInGrid;
    
    currentBitXFloat = newX;
    currentBitYFloat = newY;
    
    NSString* currentSpace = gameGrid[currentBitX][currentBitY];
    
    if([currentSpace isEqualToString:@"5"]) { //coin
        
        NSLog(@"You hit a coin!");

        //[self processCoinAtBit];

    }

    [self updateScreen];
}

-(void) processCoinAtBit {
    gameGrid[currentBitX][currentBitY] = @"0";
    
    coins ++;
    
    self.coinLabel.text = [NSString stringWithFormat:@"%i", coins];
}

-(BOOL) isWallWithX: (int) xInGrid andY: (int) yInGrid {
    int smallerY = MIN(yInGrid, currentBitY);
    int smallerX = MIN(xInGrid, currentBitX);
    
    int largerY = MAX(yInGrid, currentBitY);
    int largerX = MAX(xInGrid, currentBitX);
    
    for(int i=smallerY; i<=largerY; i++) {
        NSMutableArray* row = gameGrid[i];
        for(int j = smallerX; j<=largerX; j++) {
            if([row[j] isEqualToString:@"1"]) return true;
        }
    }
    
    return false;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    //NSLog(@"Node name where touch began: %@", node.name);
    
    if ([node.name isEqualToString:@"restartButton"]) {
        //Play button is touched
        [self resetGame];
    }
}

-(void) resetGame {
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene.
    SKScene * scene = [BITMAZEGamePage sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

-(void) update:(NSTimeInterval)currentTime {
    
}
@end
