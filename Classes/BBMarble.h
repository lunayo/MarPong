//
//  BBMarble.h
//  MarPong
//
//  Created by Lunayo on 9/4/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBStaticMarble.h"
#import "BBScoreController.h"
#import "BBChain.h"
#import "BBWheel.h"
#import "BBParticleSystem.h"
#import "BBVSScoreBoard.h"
#import "BBTextBox.h"
#import "BBLogBoard.h"


@interface BBMarble : BBStaticMarble {

	BOOL pressed;
	BOOL isThrow;
	BOOL isEnded;
	BOOL isVSGame;
	BOOL isPause;
	//award 
	BOOL isHighAngle;
	BOOL isJustRight;
	BOOL isFastSwitch;
	
	CGPoint touchPoint; //touch point
	CGPoint startPoint; //start point
	CGPoint endPoint; //touches ended point
	BBPoint lastTranslation;
	CGRect screenRect;
	
	//angle and distance between two point
	CGFloat angle;
	NSInteger distance;
	NSInteger lastDistance;
	CGFloat timeDistance;
	CGFloat time;
	CGFloat timeCounter;
	CGPoint marbleGamePosition;
	
	//marble life
	NSInteger life;
	NSInteger collidedCount;
	BBScoreController * scoreController;
	BBParticleSystem * particleEmitter;
	
	NSInteger numberOfChain;
	NSMutableArray* chainSet;
	BBWheel * wheel;
	
	BBStaticMarble * marbleObject;
	//player for vs game
	NSInteger turnCount;
	BBPlayer *player1;
	BBPlayer *player2;
	BBPlayer *playerNow;
	BBVSScoreBoard *VSScoreBoard;
	BBLogBoard* logBoard;
	BBTextBox * text;
}

@property (assign) NSInteger life;
@property (assign) BOOL pressed;
@property (assign) BOOL isPause;

- (void)resetAllChain;
- (void)replayGame;
- (void)touchUp;
- (void)touchDown;

@end
