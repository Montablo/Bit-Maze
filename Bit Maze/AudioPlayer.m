//
//  AudioPlayer.m
//  Bit Maze
//
//  Created by Jack on 5/1/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import "AudioPlayer.h"

@implementation AudioPlayer {
    AVAudioPlayer* audioPlayer;
}


static AudioPlayer *_sharedHelper = nil;

+ (AudioPlayer*)defaultAudioPlayer {
    // dispatch_once will ensure that the method is only called once (thread-safe)
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        _sharedHelper = [[AudioPlayer alloc] initWithFileNamed:@"BackgroundMusic.mp3" numberOfLoops:-1];
    });
    return _sharedHelper;
}

- (id)initWithFileNamed:(NSString*) fileName {
    self = [[AudioPlayer alloc] initWithFileNamed:fileName numberOfLoops:1];
    return self;
}

- (id)initWithFileNamed:(NSString*) fileName numberOfLoops:(int) numberOfLoops
{
    self = [super init];
    if (self) {
        // set up everything to play background music
        NSURL* file = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:nil]];
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
        [audioPlayer prepareToPlay];
        // this will play the music infinitely
        audioPlayer.numberOfLoops = numberOfLoops;
    }
    return self;
}

-(void) play {
    [audioPlayer play];
}

-(void) stop {
    [audioPlayer stop];
}

-(void) pause {
    [audioPlayer pause];
}

-(void) setVolume:(float) volume {
    [audioPlayer setVolume:volume];
}


@end
