//
//  BBScoreController.m
//  MarPong
//
//  Created by Lunayo on 10/21/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "BBScoreController.h"
#import "BBStaticMarble.h"
#import "BBScoreBoard.h"


@implementation BBScoreController
@synthesize scoreObject, scoreBoard, finalScore, isScoreHighAngle, isScoreFastSwitch, isScoreJustRight, isEnded;

+(BBScoreController*)sharedScoreController
{
	static BBScoreController *sharedScoreController;
	@synchronized(self)
	{
		if (!sharedScoreController)
			sharedScoreController = [[BBScoreController alloc] init];
	}
	return sharedScoreController;
}

- (id)init {
	self = [super init];
	if (self != nil) {
		scoreObject = [[BBScore alloc] init];
		pongoBonus = 0;
	}
	return self;
}

- (void)addMarbleToPlayerCollection:(BBStaticMarble *)sceneObject {
	//get marble name
	NSString *tempMarble = sceneObject.marbleName;
	//add to player
	[[BBSceneController sharedSceneController].player addMarbleToCollection:tempMarble];
}

- (void)addLeveltoPlayerCollection {
	//get level now
	NSString *tempLevel = [NSString stringWithFormat:@"level %d",[[BBSceneController sharedSceneController].inputController level]+1];
	//add level to player
	[[BBSceneController sharedSceneController].player addLevelToCollection:tempLevel];
}

- (void)addPongoPointToPlayerCollection:(NSInteger)score {
	//get pongo point
	NSInteger tempPoint = [[BBSceneController sharedSceneController].player pongoPoint];
	//add score to pongo point
	tempPoint += score;
	//add score to player pongo point
	[[BBSceneController sharedSceneController].player setPongoPoint:tempPoint];
}

- (void)calculateScore:(BBStaticMarble *)sceneObject with:(NSInteger)life andIsHigh:(BOOL)isHighAngle withPlace:(BOOL)isJustRight andTime:(BOOL)isFastSwitch {
	NSInteger tempScore;
	NSInteger scoreMultiply;
	switch (life) {
		case 3:
			scoreMultiply = 10000;
			break;
		case 2:
			scoreMultiply = 8000;
			break;
		case 1:
			scoreMultiply = 6000;
			break;
		default:
			break;
	}
	//award bonus
	if (isFastSwitch) {
		scoreMultiply = 15000;
		isScoreFastSwitch = YES;
		pongoBonus = scoreMultiply * life;
	}
	//store temporary score in variable
	tempScore = sceneObject.marblePosition * scoreMultiply; 
	if (isHighAngle) {
		tempScore *= 2;
		pongoBonus = tempScore;
		isScoreHighAngle = YES;
	}
	if (isJustRight) {
		tempScore *= 2;
		pongoBonus = tempScore;
		isScoreJustRight = YES;
	}
	//not vs game (normal game score)
	if (![[BBSceneController sharedSceneController].inputController isVSGame]) {
		scoreObject.score = scoreObject.score + tempScore;
		finalScore += tempScore;
	}
	//vs game score
	else {
		scoreObject.score = tempScore ;
		finalScore = tempScore;
	}
	
}

- (void)showFinalScore {
	//add level to collection;
	[self addLeveltoPlayerCollection];
	//add score to player
	[self addPongoPointToPlayerCollection:finalScore];
	NSInteger index;
	//get random marble and add to collection
	for (BBSceneObject * object in [[BBSceneController sharedSceneController] sceneObjects]) {
		if ([object isMemberOfClass:[BBStaticMarble class]]) {
			index = RANDOM_INT(1,5);
			if ([(BBStaticMarble*)object marblePosition] == index) {
				[self addMarbleToPlayerCollection:(BBStaticMarble*)object];
				break;
			}
		}
	}
	scoreBoard = [[[BBScoreBoard alloc] init] autorelease];
	if (isEnded) {
		[scoreBoard setIsGameOver:YES];
	}
	[scoreBoard awake];
	[scoreBoard setScoreWithPongoPoint:finalScore andPongoBonus:pongoBonus withHighAngle:isScoreHighAngle justRight:isScoreJustRight andFastSwitch:isScoreFastSwitch];
}

- (void)removeScoreBoard {
	[scoreBoard removeScoreBoardComponent];
}

- (void)dealloc {
	[scoreObject release];
	[scoreBoard release];
	[super dealloc];
}

@end
