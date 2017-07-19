//
//  BBMarble.m
//  MarPong
//
//  Created by Lunayo on 9/4/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "BBMarble.h"
#import "BBMesh.h"
#import "BBSceneController.h"
#import "BBInputViewController.h"
#import "BBMaterialController.h"
#import "BBCollider.h"
#import "BBStaticMarble.h"
#import "BBConfiguration.h"
#import "BBScoreController.h"
#import "BBChain.h"
#import "BBWheel.h"
#import "BBWormhole.h"
#import "BBBlackhole.h"
#import "BBBackground.h"
#import "BBVSScoreBoard.h"

@implementation BBMarble
@synthesize	 life, pressed, isPause;

- (id)init {
	self = [super init];
	if (self != nil) {
		mass = 10.0;
		numberOfChain = 7;
		isMarbleMoving = NO;
		timeCounter = 0;
		VSScoreBoard = [[BBVSScoreBoard alloc] init];
		logBoard = [[BBLogBoard alloc] init];
	}
	return self;
}

- (void)awake {
	[super awake];
	self.collider = [BBCollider collider];
	[self.collider setCheckForCollision:YES];
	screenRect = [[BBSceneController sharedSceneController].inputController screenRectFromMeshRect:self.meshBounds atPoint:CGPointMake(translation.x, translation.y)];
	//set player life
	life = [[BBSceneController sharedSceneController].player marbleLife];
	//create wheel
	wheel = [[BBWheel alloc] init];
	wheel.scale = BBPointMake(50, 50, 1);
	wheel.translation = self.translation;
	wheel.startLocation = wheel.translation;
	[[BBSceneController sharedSceneController]addObjectToScene:wheel];
	[wheel release];
	
	//first add all chain set array to all chain object
	//but set the active to no at first
	chainSet = [[NSMutableArray alloc] init];
	for (NSInteger index = 0; index < numberOfChain; index++) {
		BBChain * chain = [[BBChain alloc] init];
		chain.translation = BBPointMake(0, 0, 0);
		chain.scale = BBPointMake(10, 10, 1);
		chain.startLocation = [chain translation];
		chain.active = NO;
		[chainSet addObject:chain];
		[[BBSceneController sharedSceneController] addObjectToScene:chain];
		[chain release];
	}
	
	[self resetAllChain];
	
	//load particle atlas data
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"anStar"];
	
	//setting particle emitter variable
	particleEmitter = [[BBParticleSystem alloc] init];
	particleEmitter.emissionRange = BBRangeMake(3.0, 0.0);
	particleEmitter.sizeRange = BBRangeMake(8.0, 3.0);
	particleEmitter.growRange = BBRangeMake(0.1, 1.0);
	
	particleEmitter.xVelocityRange = BBRangeMake(-0.5, 2.0);
	particleEmitter.yVelocityRange = BBRangeMake(-0.5, 2.0);
	
	particleEmitter.lifeRange = BBRangeMake(0.0, 1.25);
	particleEmitter.decayRange = BBRangeMake(0.03, 0.05);
	
	[particleEmitter setParticle:@"star 1"];
	particleEmitter.emit = NO;
	//add particle to interface object
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:particleEmitter];	
	//log board
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:logBoard];
	[[logBoard logList] addObject:@"Marble is ready to launch..."];
	
	//vs game init
	if ([[BBSceneController sharedSceneController].inputController isVSGame]) {
		//start vs game
		player1 = [[BBPlayer alloc] init];
		player2 = [[BBPlayer alloc] init];
		playerNow = [[BBPlayer alloc] init];
		turnCount = 0;
		isVSGame = YES;
		player1.name = [[BBSceneController sharedSceneController].player name];
		player2.name = @"Guest";
		//add one more life to player 2
		player2.marbleLife += 1;
		//set now player
		playerNow = player1;
		[[logBoard logList] addObject:[NSString stringWithFormat:@"%@ turn with %d life left..",playerNow.name,playerNow.marbleLife]];
	}
}

- (void)changePlayerTurn {
	isHighAngle = NO;
	isJustRight = NO;
	isFastSwitch = NO;
	if ((player1.marbleLife == 0 && player2.marbleLife == 0) || player1.marbleObject.marblePosition == 5 
		|| player2.marbleObject.marblePosition == 5) {
		//game ended
		printf("ended");
		[VSScoreBoard setScoreWithPongoPoint:player1.marbleScore andPongoPoint2:player2.marbleScore withHighAngle1:player1.isHighAngle justRight1:player1.isJustRight andFastSwitch1:player1.isJustRight andHighAngle2:player2.isHighAngle justRight2:player2.isJustRight andFastSwitch2:player2.isFastSwitch]; 
	}
	else {
		//player score
		playerNow.marbleScore += [[BBScoreController sharedScoreController] finalScore];
		//achivement
		if (!playerNow.isHighAngle) {
			playerNow.isHighAngle = [[BBScoreController sharedScoreController] isScoreHighAngle];
		}
		if (!playerNow.isFastSwitch) {
			playerNow.isFastSwitch = [[BBScoreController sharedScoreController] isScoreFastSwitch];
		}
		if (!playerNow.isJustRight) {
			playerNow.isJustRight = [[BBScoreController sharedScoreController] isScoreJustRight];
		}
		
		if (playerNow == player1) {
			player1 = playerNow;
			playerNow = player2;
		}
		else {
			player2 = playerNow;
			playerNow = player1;
		}
		playerNow.marbleLife -= 1;
		life = playerNow.marbleLife;
		marblePosition = playerNow.marbleObject.marblePosition;
	}
	[[logBoard logList] addObject:[NSString stringWithFormat:@"%@ turn with %d life left..",playerNow.name,playerNow.marbleLife]];
}

- (void)handleTouches {
	NSSet * touches = [[BBSceneController sharedSceneController].inputController touchEvents];
	if ([touches count] == 0) return;
	
	BOOL pointInBounds = NO;
	for (UITouch * touch in [touches allObjects]) {
		touchPoint = [touch locationInView:[touch view]];
		if (CGRectContainsPoint(screenRect, touchPoint)) {
			pointInBounds = YES;
			if (touch.phase == UITouchPhaseBegan || touch.phase == UITouchPhaseStationary) 
				[self touchDown];
		}
		if (touch.phase == UITouchPhaseEnded) [self touchUp];
		endPoint = touchPoint;
	}
}

- (void)resetAllChain {
	//set all chain object active to no first
	for (BBSceneObject * object in chainSet) {
		[object setActive:NO];
	}
}

- (void)touchUp {
	if (!pressed) return;
	pressed = NO;
	isMarbleMoving = YES;
	//calculate the angle
	angle = [self pointDirectionWithX:startPoint.x andY:startPoint.y onX:endPoint.x andY:endPoint.y];
	//calculate the distance
	distance = [self pointDistanceWithX:startPoint.x andY:startPoint.y onX:endPoint.x andY:endPoint.y];
	//validate the minimum distance
	if (distance <= 0.0)
		distance = 1.0;
	
	//validate if dragged to the right
	if (angle > 0 && angle < 180)
		angle = 0;
	//set the max distance
	if (distance >= MAX_DISTANCE)
		distance = MAX_DISTANCE;
	
	CGFloat force = distance * DRAGGED_SPEED_FACTOR;
	CGFloat accelerate = force / self.mass;
	
	//set the speed by angle
	speed.x += sinf((angle-180)/BBRADIANS_TO_DEGREES)* accelerate * 60;
	speed.y += cosf((angle-180)/BBRADIANS_TO_DEGREES)* accelerate * 60;
	//set throw to true
	isThrow = YES;
	
	[self resetAllChain];
	
	//set the particle emit to yes
	if (!particleEmitter.emit && isThrow) {
		particleEmitter.emit = YES;
	}
	timeDistance = fabs(timeCounter - timeDistance);
}

- (void)touchDown {
	if (pressed) return;
	if (!isThrow) {
		pressed = YES;
		startPoint = touchPoint;
		[self resetAllChain];
		time = timeCounter;
	}
}

- (void)replayGame {
	life = [[BBSceneController sharedSceneController].player marbleLife];
	time = 0;
	isMarbleMoving = NO;
	particleEmitter.emit = NO;
	isCollided = NO;
	isEnded = NO;
	isThrow = NO;
	collidedCount = 0;
	marblePosition = 0;
	for (BBSceneObject * object in [[BBSceneController sharedSceneController] sceneObjects]) {
		if ([object isMemberOfClass:[BBStaticMarble class]]) {
			[(BBStaticMarble*)object setIsMarbleMoving:NO];
		}
	}
	[[BBScoreController sharedScoreController] removeScoreBoard];
	[[BBSceneController sharedSceneController] resetAllObjectPosition];
	//set all chain object active to no first
	[self resetAllChain];
	[[[BBScoreController sharedScoreController] scoreObject] setScore:0];
	[[BBScoreController sharedScoreController] setFinalScore:0];
}

- (void)update {
	[self handleTouches];
	[super update];
	CGFloat lastAngle = [self pointDirectionWithX:translation.x andY:translation.y onX:lastTranslation.x andY:lastTranslation.y];
	screenRect = [[BBSceneController sharedSceneController].inputController screenRectFromMeshRect:self.meshBounds atPoint:CGPointMake(translation.x, translation.y)];	
	//calculate the distance
	distance = [self pointDistanceWithX:startPoint.x andY:startPoint.y onX:endPoint.x andY:endPoint.y];
	if (pressed && distance <= MAX_DISTANCE) {
		//set marble position
		self.translation = BBPointMake(touchPoint.y-240,touchPoint.x-160, 0.0);
		//create chain for marble
		NSInteger objectIndex;
		//validate object to remove
		if (distance < lastDistance) {
			if (distance % 10 == 0) {
				objectIndex = distance / 10;
				//set active all chain after to no too
				for (NSInteger index = objectIndex; index < [chainSet count]; index++) {
					[[chainSet objectAtIndex:index] setActive:NO];
				}
			}
		}
		else if(distance > lastDistance){
			if (distance % 10 == 0) {
				objectIndex = distance / 10;
				//set active all chain before to yes too
				for (NSInteger index = 0; index < objectIndex; index++) {
					[[chainSet objectAtIndex:index] setActive:YES];
				}
			}
		}
		
		BBPoint wheelTranslation = [wheel translation];
		//find the angle between wheel and marble
		CGFloat wheelAngle = [self pointDirectionWithX:translation.x andY:translation.y onX:wheelTranslation.x andY:wheelTranslation.y];
		for (NSInteger index = 0; index < [chainSet count]; index++) {
			if ([[chainSet objectAtIndex:index] isKindOfClass:[BBChain class]]) {
				BBPoint chainTranslation = [[chainSet objectAtIndex:index] translation];
				chainTranslation.x = (-10 * index) * cosf(wheelAngle/BBRADIANS_TO_DEGREES) + wheelTranslation.x;
				chainTranslation.y = (-10 * index) * sinf(wheelAngle/BBRADIANS_TO_DEGREES) + wheelTranslation.y;
				[[chainSet objectAtIndex:index] setTranslation:chainTranslation];
			}
		}
		
	}
	if (isMarbleMoving) {
		marbleGamePosition = [[BBSceneController sharedSceneController] gamePosition];
		if (marbleGamePosition.y >= 400)
			isHighAngle = YES;
	}
	//if marble does not collided or contact with other marble
	if (isThrow && !isMarbleMoving && (!isCollided || !isEnded) &&!isPause ) {
		isThrow = NO;
		life -= 1;
		[[logBoard logList] addObject:@"Marble is ready to launch.."];
		//if vs game
		if (isVSGame) {
			[self changePlayerTurn];
		}
		if (life > 0) {
			//call reset to position
			[[BBSceneController sharedSceneController] resetAllObjectPosition];
			//reset all chain
			[self resetAllChain];
			//get all static marble and check its position remove from scene
			for (BBSceneObject * object in [[BBSceneController sharedSceneController] sceneObjects]) {
				if ([object isMemberOfClass:[BBStaticMarble class]]) {
					[(BBStaticMarble*)object setIsMarbleMoving:NO];
					if ([(BBStaticMarble*)object marblePosition] <= marblePosition) {
						//[[BBSceneController sharedSceneController] removeObjectFromScene:(BBStaticMarble*)object];
						object.active = NO;
						object.translation = BBPointMake(-320, -200, 0);
					}
				}
				
			}
			isHighAngle = NO;
			isJustRight = NO;
			isFastSwitch = NO;
			//marblePosition = 0;
			collidedCount = 0;
			//disable particle emit
			particleEmitter.emit = NO;
		}
		else { 
			//vs game over
			if (isVSGame) {
				//show score board of 2 player
				[VSScoreBoard awake];
				[VSScoreBoard setScoreWithPongoPoint:player1.marbleScore andPongoPoint2:player2.marbleScore withHighAngle1:player1.isHighAngle justRight1:player1.isJustRight andFastSwitch1:player1.isJustRight andHighAngle2:player2.isHighAngle justRight2:player2.isJustRight andFastSwitch2:player2.isFastSwitch];
			}
			//normal game over
			else {
				printf("Game Over");
				[[BBScoreController sharedScoreController] setIsEnded:YES];
				[[BBScoreController sharedScoreController] showFinalScore];
			}
			
		}
	}
	//marble did collided with other marble
	else {
		if (collidedCount == 1 && marbleObject) {
			//check award
			if (marbleGamePosition.y >= 400) {
				isHighAngle = YES;
			}
			if (life == ([marbleObject marblePosition] - 4)) {
				isJustRight = YES;
			}
			if (timeDistance <= 0.08) {
				isFastSwitch = YES;
			}
			marblePosition = [marbleObject marblePosition];
			//calculate the score
			[[BBScoreController sharedScoreController] calculateScore:marbleObject with:life andIsHigh:isHighAngle withPlace:isJustRight andTime:isFastSwitch];
			if ([marbleObject marblePosition] < 5) {
				//set the logboard for any achievement
				if (isHighAngle) [[logBoard logList] addObject:@"High Angle Achievement!"];
				if (isJustRight) [[logBoard logList] addObject:@"Just Right Achievement!"];
				if (isFastSwitch) [[logBoard logList] addObject:@"Fast Switch Achievement!"];
				//set score has achieved
				[[logBoard logList] addObject:@"Score has achieved!"];
				isThrow = YES;
				isEnded = NO;
			}
			else {
				isEnded = YES;
				isThrow = NO;
				isCollided = NO;
				//if vs game
				if (!isVSGame) {
					[[BBScoreController sharedScoreController] setIsEnded:NO];
					//win the game show the final score board
					[[BBScoreController sharedScoreController] showFinalScore];
				}
				else {
					isThrow = YES;
					isEnded = NO;
					//show score board of 2 player
					playerNow.marbleScore += [[BBScoreController sharedScoreController] finalScore];
					if (!playerNow.isHighAngle) {
						playerNow.isHighAngle = [[BBScoreController sharedScoreController] isScoreHighAngle];
					}
					if (!playerNow.isFastSwitch) {
						playerNow.isFastSwitch = [[BBScoreController sharedScoreController] isScoreFastSwitch];
					}
					if (!playerNow.isJustRight) {
						playerNow.isJustRight = [[BBScoreController sharedScoreController] isScoreJustRight];
					}
					if (playerNow == player1) {
						player1 = playerNow;
					}
					else {
						player2 = playerNow;
					}

					[VSScoreBoard awake];
					[VSScoreBoard setScoreWithPongoPoint:player1.marbleScore andPongoPoint2:player2.marbleScore withHighAngle1:player1.isHighAngle justRight1:player1.isJustRight andFastSwitch1:player1.isJustRight andHighAngle2:player2.isHighAngle justRight2:player2.isJustRight andFastSwitch2:player2.isFastSwitch];
				}
				
			}
			collidedCount = 2;
		}
	}
	//disable particle if is collided with other object
	if (isCollided) particleEmitter.emit = NO;
	
	//calculate particle position
	BBPoint tempParticleTranslation;
	tempParticleTranslation.x = -15 * cosf((lastAngle-180)/BBRADIANS_TO_DEGREES) + translation.x;
	tempParticleTranslation.y = -15 * sinf((lastAngle-180)/BBRADIANS_TO_DEGREES) + translation.y;
	//set particle translation
	particleEmitter.translation = tempParticleTranslation;
	//save the last distance for compare
	lastDistance = distance;
	//save the last translation
	lastTranslation = translation;
	
	//adding time counter per update
	timeCounter += 0.001;
	
	
}

- (void)didCollideWith:(BBSceneObject *)sceneObject {
	[super didCollideWith:sceneObject];
	if ([sceneObject isMemberOfClass:[BBStaticMarble class]]) {
		if (collidedCount == 0) {
			if (marbleObject == nil)
				marbleObject = [[BBStaticMarble alloc] init];
			//set collided marble object
			marbleObject = (BBStaticMarble*)sceneObject;
			collidedCount = 1;
			if (isVSGame) {
				playerNow.marbleObject = marbleObject;
			}
		}
		isCollided = YES;
	}
	//hit blackhole
	if ([sceneObject isMemberOfClass:[BBBlackhole class]]) {
		BBPoint collideeTranslation = [(BBBlackhole*)sceneObject translation];
		CGFloat tempDistance = [self pointDistanceWithX:translation.x andY:translation.y onX:collideeTranslation.x andY:collideeTranslation.y];
		//if distance is 0, same with black hole distance
		if (tempDistance <= 20) {
			speed.x = cosf(RANDOM_INT(0,360)/BBRADIANS_TO_DEGREES)*100;
			speed.y = sinf(RANDOM_INT(0,360)/BBRADIANS_TO_DEGREES)*100;
		}
	}
	//hit wormhole
	else if ([sceneObject isMemberOfClass:[BBWormhole class]]) {
		//if worm hole is active and is type of in
		if ([[(BBWormhole*)sceneObject type] isEqualToString:@"in"]) {
			//wormhole translation
			//BBPoint collideeTranslation = [(BBWormhole*)sceneObject translation];
			//wormhole type out translation
			BBPoint outWormholeTranslation;
			//temporary translation
			BBPoint tempTranslation;
			//distance between marble and wormhole
			//CGFloat tempDistance = [self pointDistanceWithX:translation.x andY:translation.y onX:collideeTranslation.x andY:collideeTranslation.y];
			NSMutableArray * tempSceneObject = [[BBSceneController sharedSceneController] sceneObjects];
			//get game position now
			CGPoint gamePosition = [[BBSceneController sharedSceneController] gamePosition];
			//iterate all scene object to get wormhole type out translation
			for (BBSceneObject * object in tempSceneObject) {
				//search wormhole type out and same groupname
				if ([object isKindOfClass:[BBWormhole class]] && [[(BBWormhole*)object type] isEqualToString:@"out"] && 
					[[(BBWormhole*)object groupName] isEqualToString:[(BBWormhole*)sceneObject groupName]])
				{
					//set the translation
					outWormholeTranslation = [object translation];
					//return earlier
					break;
				}
			}
			
			//if distance is 0, same with black hole distance
			//if (tempDistance == 0) {
				//set all object position to wormhole out translation
				for (BBSceneObject * object in tempSceneObject) {
					//marble hero does not move
					if (![object isMemberOfClass:[BBMarble class]])
					{
						BBPoint objectTranslation = [object translation];
						objectTranslation.x -= outWormholeTranslation.x;
						objectTranslation.y -= outWormholeTranslation.y;
						[object setTranslation:objectTranslation];
						//set new translation of out wormhole
						if ([object isMemberOfClass:[BBWormhole class]] && [[(BBWormhole*)object type] isEqualToString:@"out"])
							tempTranslation = [object translation];
					}
				}
				//set marble translation and out wormhole translation same place
				translation = tempTranslation;
				//modify game position
				gamePosition.x += outWormholeTranslation.x;
				gamePosition.y += outWormholeTranslation.y;
				//set marble and wormhole random location
				//set wormhole to not active
				[(BBWormhole*)sceneObject setIsRun:NO];
				[[BBSceneController sharedSceneController] setGamePosition:gamePosition];
			//}
			
		}
	}
}

- (void)checkArenaBounds {
	//disable particle emit if hit ground
	if (translation.y < (-160 + CGRectGetHeight(self.meshBounds)/2))
		particleEmitter.emit = NO; //disable particle to emit
	[super checkArenaBounds];
	//check if collide with wall
 	if (translation.x > (240 - CGRectGetWidth(self.meshBounds)/2)) {
		translation.x = 240 - CGRectGetWidth(self.meshBounds)/2;
		speed.x = -speed.x * COEFFICIENT_OF_RESTITUTION;
	}
}

- (void)dealloc {
	[scoreController release];
	[wheel release];
	[chainSet release];
	[marbleObject release];
	if (particleEmitter != nil) [[BBSceneController sharedSceneController] removeObjectFromScene:particleEmitter];
	[particleEmitter release];
	[player1 release];
	[player2 release];
	[playerNow release];
	[VSScoreBoard release];
	[logBoard release];		
	[super dealloc];
}

@end
