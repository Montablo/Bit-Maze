//
//  GCHelper.m
//  SpaceInvadersGameCenter
//
//  Created by Alvin Stanescu on 21.09.13.
//  Copyright (c) 2013 Barbara Köhler. All rights reserved.
//

#import "GCHelper.h"
#import "Constants.h"

@interface GCHelper ()

- (void)loadLeaderBoardInfo;

@end

@implementation GCHelper

@synthesize gameCenterAvailable;

#pragma mark Initialization

static GCHelper *_sharedHelper = nil;

+ (GCHelper*)defaultHelper {
    // dispatch_once will ensure that the method is only called once (thread-safe)
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        _sharedHelper = [[GCHelper alloc] init];
    });
    return _sharedHelper;
}

- (id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        
        if (gameCenterAvailable) {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
        }
    }
    return self;
}

- (BOOL)isGameCenterAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

#pragma mark Authentication

- (void)authenticationChanged {
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = TRUE;
        
        [self loadLeaderBoardInfo];
        [self loadAchievements];
        
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated.");
        userAuthenticated = FALSE;
    }
}

- (void)authenticateLocalUserOnViewController:(UIViewController*)viewController
                            setCallbackObject:(id)obj
                            withPauseSelector:(SEL)selector
{
    if (!gameCenterAvailable) return;
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    NSLog(@"Authenticating local user...");
    if (localPlayer.authenticated == NO) {
        [localPlayer setAuthenticateHandler:^(UIViewController* authViewController, NSError *error) {
            if (authViewController != nil) {
                if (obj) {
                    [obj performSelector:selector withObject:nil afterDelay:0];
                }
                
                [viewController presentViewController:authViewController animated:YES completion:^ {
                }];
            } else if (error != nil) {
                // process error
            }
        }];
    }
    else {
        NSLog(@"Already authenticated!");
    }
}

#pragma mark Leaderboards

- (void)loadLeaderBoardInfo
{
    [GKLeaderboard loadLeaderboardsWithCompletionHandler:^(NSArray *leaderboards, NSError *error) {
        self.leaderboards = leaderboards;
    }];
}

- (void)reportScore:(int64_t)score forLeaderboardID:(NSString*)identifier
{
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    [GKScore reportScores:@[scoreReporter] withCompletionHandler:^(NSError *error) {
        if (error == nil) {
            NSLog(@"Score reported successfully!");
        } else {
            NSLog(@"Unable to report score!");
        }
    }];
}

- (void)showLeaderboardOnViewController:(UIViewController*)viewController
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil) {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gameCenterController.leaderboardIdentifier = kLeaderBoardIdentifier;
        
        [viewController presentViewController: gameCenterController animated: YES completion:nil];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark Achievements

- (void)reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent
{
    GKAchievement *achievement = [self getAchievementForIdentifier:identifier];
    if (achievement && achievement.percentComplete != 100.0) {
        achievement.percentComplete = percent;
        achievement.showsCompletionBanner = YES;
        
        [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"Error while reporting achievement: %@", error.description);
            }
        }];
    }
}

- (void)loadAchievements
{
    self.achievementsDictionary = [[NSMutableDictionary alloc] init];
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
        if (error != nil) {
            // Handle the error.
            NSLog(@"Error while loading achievements: %@", error.description);
        }
        else if (achievements != nil) {
            // Process the array of achievements.
            for (GKAchievement* achievement in achievements)
                self.achievementsDictionary[achievement.identifier] = achievement;
        }
    }];
}

- (GKAchievement*)getAchievementForIdentifier: (NSString*) identifier
{
    GKAchievement *achievement = [self.achievementsDictionary objectForKey:identifier];
    if (achievement == nil) {
        achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        self.achievementsDictionary[achievement.identifier] = achievement;
    }
    return achievement;
}

- (void)resetAchievements
{
    // Clear all locally saved achievement objects.
    self.achievementsDictionary = [[NSMutableDictionary alloc] init];
    // Clear all progress saved on Game Center.
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
     {
         if (error != nil) {
             // handle the error.
             NSLog(@"Error while reseting achievements: %@", error.description);
             
         }
     }];
}

- (void)completeMultipleAchievements:(NSArray*)achievements
{
    [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error while reporting achievements: %@", error.description);
        }
    }];
}

#pragma mark Challenges

- (void)registerListener:(id<GKLocalPlayerListener>)listener
{
    [[GKLocalPlayer localPlayer] registerListener:listener];
}

@end
