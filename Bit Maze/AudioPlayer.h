//
//  AudioPlayer.h
//  Bit Maze
//
//  Created by Jack on 5/1/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer : NSObject {
}

+ (AudioPlayer*)defaultAudioPlayer;

- (id)initWithFileNamed:(NSString*) fileName;
-(id)initWithFileNamed:(NSString*) fileName numberOfLoops:(int) numberOfLoops;

-(void) play;
-(void) stop;
-(void) pause;
-(void) setVolume:(float) volume;
@end
