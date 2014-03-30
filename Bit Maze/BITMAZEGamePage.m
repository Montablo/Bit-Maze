//
//  BITMAZEGamePage.m
//  Bit Maze
//
//  Created by Galen and Jack on 3/26/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import "BITMAZEGamePage.h"

@implementation BITMAZEGamePage

static int NUM_ROWS = 52;
static int NUM_COLUMNS = 40;
static int TOP_INDENT = 40;
static int BOTTOM_INDENT = 40;

static float maxSpeed = .1;
static float speedChange = .99;

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
        
        [self initializePhysics];
        
        [self initializeGame];
        
        [self startGame];
    }
    return self;
}

-(void) initializeVariables {
    
    gameSpeed = .3;
    
    patternOccurences = [NSMutableArray array];
}

-(void) initializePhysics {
    //SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame), inGameFrame.width, inGameFrame.height)];
    //SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    // 2 Set physicsBody of scene to borderBody
    //self.physicsBody = borderBody;
    
    //self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    //self.scaleMode = SKSceneScaleModeAspectFit;
    //self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:inGameFrame];
    //self.physicsBody.friction = 0.0f;
}

-(void) initializeGame {
    
    [self initializePatterns];
    
    NSLog(@"%@", patternOccurences);
    
    [self generateGrid];
    
}

-(void) startGame {
    [self scrollScreen];
    
    [self updateScreen];
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
    
    [self removeAllWalls];
    
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
            
            CGRect imageRect = CGRectMake(x, y, width, height);
            
            if([type isEqual : @"1"]) { //wall
                
                image = [SKSpriteNode spriteNodeWithImageNamed:@"1"];
                
                //image.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:imageRect];
                
                image.name = @"wall";
                
            } else if([type isEqual : @"2"]) { //player
                
                image = [SKSpriteNode spriteNodeWithImageNamed:@"0"];
                image.name = @"bit";
                
                self.bit = image;
                
                //image.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(width, height)];
                
                //image.physicsBody.restitution = 1.0f;
                //image.physicsBody.friction = 0.0f;
                
                image.zPosition = 100;
                
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
                //spaceRow[NUM_COLUMNS / 2 - 1] = @"2";
            }
            
            [gameGrid addObject : spaceRow];
            
            
        } else {
        
            NSMutableArray* currentPattern = patterns[currentPatternNumber];
            
            NSMutableArray* nextRow = currentPattern[currentPatternRow];
            
            if(gameGrid.count == 0) {
                //nextRow[NUM_COLUMNS / 2 - 1] = @"2";
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

-(void) removeAllWalls {
    
    [self enumerateChildNodesWithName:@"wall" usingBlock:^(SKNode *node, BOOL *stop) {
        /*if(node.position.y <= BOTTOM_INDENT + ([UIScreen mainScreen].bounds.size.height - (TOP_INDENT + BOTTOM_INDENT)) / NUM_ROWS) {
            [node removeFromParent];
        }
        
        if([self.bit intersectsNode:node]) {
            
        }*/
        [node removeFromParent];
    }];
    
}

-(void) scrollScreen{
    
    NSMutableArray* bottomRow = gameGrid[0];
    
    for(int i=0; i<bottomRow.count; i++) {
        if([bottomRow[i] isEqualToString:@"2"]) {
            [self endGame];
            //return;
        }
    }
    
    [gameGrid removeObjectAtIndex:0];
    
    [self generateGrid];
    
    
    [self updateScreen];
    
    gameSpeed *= speedChange;
    
    if(gameSpeed < maxSpeed) gameSpeed = maxSpeed;
    
    NSLog(@"%f", gameSpeed);
    
    [self performSelector:@selector(scrollScreen) withObject:nil afterDelay:gameSpeed];
}

-(void) endGame {
    NSLog(@"You lose!");
}

-(void)touchesMoved:(NSSet*) touches withEvent:(UIEvent*) event
{
    self.bit.position = [[touches anyObject] locationInNode:self];
}

-(void) update:(NSTimeInterval)currentTime {
    //self.bit.position = CGPointMake(self.bit.position.x+1, self.bit.position.y+1);
}

@end
