//
//  BBBackground.m
//  MarPong
//
//  Created by Lunayo on 11/1/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "BBBackground.h"
#import "BBMaterialController.h"
#import "BBChain.h"
#import "BBMarble.h"


@implementation BBBackground

#define HORIZ_SWIPE_DRAG_MIN 25
#define VERT_SWIPE_DRAG_MAX 8

- (id)initWithBackgroundImage:(NSString *)imageName {
	self = [super init];
	if (self != nil) {
		bgQuad = [[BBMaterialController sharedMaterialController] quadFromAtlasKey:imageName];
		[bgQuad retain];
	}
	return self;
}

- (void)awake {
	self.mesh = bgQuad;
	screenRect = [[BBSceneController sharedSceneController].inputController screenRectFromMeshRect:self.meshBounds atPoint:CGPointMake(translation.x, translation.y)];
	backgroundWidth = CGRectGetWidth([self  meshBounds]);
	backgroundHeight = CGRectGetHeight([self meshBounds]);
}

- (void)handleTouches
{
	NSSet * touches = [[BBSceneController sharedSceneController].inputController touchEvents];
	if ([touches count] == 0) return;
	
	BOOL pointInBounds = NO;
	for (UITouch * touch in [touches allObjects]) {
		touchPoint = [touch locationInView:[touch view]];
		if (CGRectContainsPoint(screenRect, touchPoint)) {
			pointInBounds = YES;
			if ((touch.phase == UITouchPhaseBegan) || ((touch.phase == UITouchPhaseStationary))) [self touchDown];				
		}
		if (touch.phase == UITouchPhaseEnded) [self touchUp];
		endPosition = touchPoint;
	}
	
}

- (void)touchUp {
	if (!pressed) return; // we were already up
	pressed = NO;
}

- (void)touchDown {
	if (pressed) return; // we were already down
	pressed = YES;
	startPosition = touchPoint;
}

- (void)update {
	[super update];
	[self handleTouches];
	BOOL marblePressed;
	BOOL marbleMoving;
	//search hero marble
	for (BBSceneObject* object in [[BBSceneController sharedSceneController] sceneObjects]) {
		if ([object isMemberOfClass:[BBMarble class]]) {
			marblePressed = [(BBMarble*)object pressed];
			marbleMoving = [(BBMarble*)object isMarbleMoving];
			break;
		}
	}
	if (pressed && !marblePressed && !marbleMoving) {
		//check user slide direction
		if (fabsf(startPosition.x - endPosition.x) >= HORIZ_SWIPE_DRAG_MIN && 
			fabsf(startPosition.y - endPosition.y) <= VERT_SWIPE_DRAG_MAX) {
			//verical swipe 
			//swipe to up
			if (startPosition.x < endPosition.x) {
				pixelPerSwipe.x = 0;
				pixelPerSwipe.y = -10;
				[self moveAllObjectBy:pixelPerSwipe];	
			}
			//swipe to down
			else {
				pixelPerSwipe.x = 0;
				pixelPerSwipe.y = 10;
				[self moveAllObjectBy:pixelPerSwipe];				
			}
		}
		else if (fabsf(startPosition.y - endPosition.y) >= HORIZ_SWIPE_DRAG_MIN && 
				 fabsf(startPosition.x - endPosition.x) <= VERT_SWIPE_DRAG_MAX) {
			//horizontal Swipe 
			//swipe to left
			if (startPosition.y > endPosition.y) {
				pixelPerSwipe.x = -10;
				pixelPerSwipe.y = 0;
				[self moveAllObjectBy:pixelPerSwipe];
			}
			//swipe to right
			else {
				pixelPerSwipe.x = 10;
				pixelPerSwipe.y = 0;
				[self moveAllObjectBy:pixelPerSwipe];
			}
		}
	}
}

- (void)moveAllObjectBy:(CGPoint)pixel {
	CGPoint gamePosition = [[BBSceneController sharedSceneController] gamePosition];
	NSString *logPosition = @"null";
	gamePosition.x -= pixel.x;
	gamePosition.y -= pixel.y;
	
	//validate game postition for not over the background image
	if (gamePosition.x > backgroundWidth - 320) {
		pixel.x = 0;
		gamePosition.x = backgroundWidth - 320;
	}
	else if (gamePosition.x < IPHONE_BACKING_WIDTH/2) {
		pixel.x = 0;
		gamePosition.x = IPHONE_BACKING_WIDTH/2;
		logPosition = @"left";
	}
	if (gamePosition.y >= backgroundHeight - 200) {
		pixel.y = 0;
		gamePosition.y = backgroundHeight - 200;
	}
	else if (gamePosition.y < IPHONE_BACKING_HEIGHT/2) {
		pixel.y = 0;
		gamePosition.y = IPHONE_BACKING_HEIGHT/2;
		logPosition = @"down";
	}
	
	//move all object by speed
	for (BBSceneObject* object in [[BBSceneController sharedSceneController] sceneObjects]) {
		BBPoint objectTranslation = [object translation];
		BBPoint objectStartTranslation = [object startLocation];
		objectTranslation.x += pixel.x;
		objectTranslation.y += pixel.y;
		if (pixel.x == 0 && [logPosition isEqualToString:@"left"]) {
			objectTranslation.x = objectStartTranslation.x;
		}
		if (pixel.y == 0 && [logPosition isEqualToString:@"down"]) {
			objectTranslation.y = objectStartTranslation.y;
		}
		[object setTranslation:objectTranslation];
	}
	[[BBSceneController sharedSceneController] setGamePosition:gamePosition];
	
}

- (void)dealloc {
	[super dealloc];
	[bgQuad dealloc];
}

@end