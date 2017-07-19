//
//  BBScoreController.h
//  MarPong
//
//  Created by Lunayo on 10/21/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBScore.h"
#import "BBScoreController.h"
#import "BBSceneObject.h"
#import "BBScoreBoard.h"

@interface BBScoreController : NSObject {
	
	BBScore * scoreObject;
	BBScoreBoard* scoreBoard;
	BOOL isScoreHighAngle;
	BOOL isScoreJustRight;
	BOOL isScoreFastSwitch;
	BOOL isEnded;
	NSInteger pongoBonus;
	NSInteger finalScore;
}

@property (assign) BBScore * scoreObject;
@property (assign) BBScoreBoard * scoreBoard;
@property (assign) NSInteger finalScore;
@property (assign) BOOL isScoreHighAngle;
@property (assign) BOOL isScoreJustRight;
@property (assign) BOOL isScoreFastSwitch;
@property (assign) BOOL isEnded;

+ (BBScoreController*)sharedScoreController;
- (void)showFinalScore;
- (void)removeScoreBoard;
- (void)calculateScore:(BBSceneObject*)sceneObject with:(NSInteger)life andIsHigh:(BOOL)isHighAngle withPlace:(BOOL)isJustRight andTime:(BOOL)isFastSwitch;

@end
