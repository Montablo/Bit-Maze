//
//  GameKitHelper.h
//  Bit Maze
//
//  Created by Jack on 5/2/14.
//  Copyright (c) 2014 Montablo. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GameKit;

@interface GameKitHelper : NSObject

extern NSString *const PresentAuthenticationViewController;

@property (nonatomic, readonly) UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *lastError;

+ (instancetype)sharedGameKitHelper;

- (void)authenticateLocalPlayer;

@end
