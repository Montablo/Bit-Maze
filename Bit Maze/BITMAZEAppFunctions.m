//
//  BITMAZEAppFunctions.m
//  Bit Maze
//
//  Created by Dylan Cable on 3/31/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import "BITMAZEAppFunctions.h"

@implementation BITMAZEAppFunctions

-(void) checkSound {
    
    NSError *error;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults stringForKey:@"sound"] == nil) {
        [defaults setObject:@"0" forKey:@"sound"];
    }
    
    if([[defaults stringForKey:@"sound"] isEqualToString:@"0"]) {
        
        NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"BackgroundMusic" withExtension:@"mp3"];
        self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
        self.backgroundMusicPlayer.numberOfLoops = -1;
        [self.backgroundMusicPlayer prepareToPlay];
        [self.backgroundMusicPlayer play];
        
    }
    
}

@end
