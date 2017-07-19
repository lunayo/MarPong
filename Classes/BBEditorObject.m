//
//  BBEditorObject.m
//  MarPong
//
//  Created by Lunayo on 1/20/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import "BBEditorObject.h"
#import "BBMaterialController.h"

#pragma mark square
static NSInteger BBSquareVertexSize = 2;
static NSInteger BBSquareColorSize = 4;
static GLenum BBSquareOutlineRenderStyle = GL_LINE_LOOP;
static NSInteger BBSquareOutlineVertexesCount = 4;
static CGFloat BBSquareOutlineVertexes[8] = {-0.5f, -0.5f, 0.5f,  -0.5f, 0.5f,   0.5f, -0.5f,  0.5f};
static CGFloat BBSquareOutlineColorValues[16] = {1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0};

@implementation BBEditorObject

@synthesize imageName, objectName, objectType, bgActive, extraType, screenRect;

#define HORIZ_SWIPE_DRAG_MIN 50
#define VERT_SWIPE_DRAG_MAX 8

- (id)initWithImageName:(NSString *)name {
	self = [super init];
	if (self != nil) {
		imageName = name;
		bgQuad = [[BBMaterialController sharedMaterialController] quadFromAtlasKey:imageName];
		[bgQuad retain];
	}
	return self;
}

- (void)awake {
	self.mesh = bgQuad;
	pressed = NO;
	mesh = [[BBMesh alloc] initWithVertexes:BBSquareOutlineVertexes vertexCount:BBSquareOutlineVertexesCount vertexSize:BBSquareVertexSize renderStyle:BBSquareOutlineRenderStyle];
	mesh.colors = BBSquareOutlineColorValues;
	mesh.colorSize = BBSquareColorSize;
	screenRect = [[BBSceneController sharedSceneController].inputController 
				  screenRectFromMeshRect:self.meshBounds 
				  atPoint:CGPointMake(translation.x, translation.y)];
	bgActive = YES;
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
	}
	endPosition = touchPoint;
}

- (void)touchUp {
	if (!pressed) return; // we were already up
	pressed = NO;
	//set editor object now
	[[BBSceneController sharedSceneController].inputController setEditorObject:self];
	for (BBSceneObject * object in [[BBSceneController sharedSceneController] sceneObjects]) {
		if ([object isMemberOfClass:[BBEditorObject class]]) {
			if ([[(BBEditorObject*)object objectType] isEqualToString:@"background"]) {
				[(BBEditorObject*)object setBgActive:YES];
				break;
			}
		}
	}
}

- (void)touchDown {
	if (pressed) return; // we were already down
	pressed = YES;
	startPosition = touchPoint;
}


- (void)update {
	[super update];
	[self handleTouches];
	bgQuad = [[BBMaterialController sharedMaterialController] quadFromAtlasKey:imageName];
	self.mesh = bgQuad;
	if (pressed && [objectType isEqualToString:@"background"] && bgActive) {
		//check user slide direction
		if (fabsf(startPosition.x - endPosition.x) >= HORIZ_SWIPE_DRAG_MIN && 
			fabsf(startPosition.y - endPosition.y) <= VERT_SWIPE_DRAG_MAX) {
			//verical swipe 
			//swipe to up
			if (startPosition.x < endPosition.x) {
				pixelPerSwipe.x = 0;
				pixelPerSwipe.y = -480;
				[self moveAllObjectBy:pixelPerSwipe];	
				pressed = NO;
			}
			//swipe to down
			else {
				pixelPerSwipe.x = 0;
				pixelPerSwipe.y = 480;
				[self moveAllObjectBy:pixelPerSwipe];	
				pressed = NO;
			}
		}
		else if (fabsf(startPosition.y - endPosition.y) >= HORIZ_SWIPE_DRAG_MIN && 
				 fabsf(startPosition.x - endPosition.x) <= VERT_SWIPE_DRAG_MAX) {
			//horizontal Swipe 
			//swipe to left
			if (startPosition.y > endPosition.y) {
				pixelPerSwipe.x = -640;
				pixelPerSwipe.y = 0;
				[self moveAllObjectBy:pixelPerSwipe];
				pressed = NO;
			}
			//swipe to right
			else {
				pixelPerSwipe.x = 640;
				pixelPerSwipe.y = 0;
				[self moveAllObjectBy:pixelPerSwipe];
				pressed = NO;
			}
		}
	}
	//not background
	if (pressed && ![objectType isEqualToString:@"background"]) {
		//set the object position
		self.translation = BBPointMake(touchPoint.y-240,touchPoint.x-160, 0.0);
		screenRect = [[BBSceneController sharedSceneController].inputController 
					  screenRectFromMeshRect:self.meshBounds 
					  atPoint:CGPointMake(translation.x, translation.y)];
		for (BBSceneObject * object in [[BBSceneController sharedSceneController] sceneObjects]) {
			if ([object isMemberOfClass:[BBEditorObject class]]) {
				if ([[(BBEditorObject*)object objectType] isEqualToString:@"background"]) {
					[(BBEditorObject*)object setBgActive:NO];
					break;
				}
			}
		}
	}
}

- (void)moveAllObjectBy:(CGPoint)pixel {
	CGPoint gamePosition = [[BBSceneController sharedSceneController] gamePosition];
	gamePosition.x -= pixel.x;
	gamePosition.y -= pixel.y;
	//validate game postition for not over the background image
	if (gamePosition.x > 1520) {
		pixel.x = 0;
		gamePosition.x = 1520;
	}
	else if (gamePosition.x < 240) {
		pixel.x = 0;
		gamePosition.x = 240;
	}
	if (gamePosition.y > 1120) {
		pixel.y = 0;
		gamePosition.y = 1120;
	}
	else if (gamePosition.y < 160) {
		pixel.y = 0;
		gamePosition.y = 160;
	}
	//move all object by speed
	for (BBSceneObject* object in [[BBSceneController sharedSceneController] sceneObjects]) {
		BBPoint objectTranslation = [object translation];
		objectTranslation.x += pixel.x;
		objectTranslation.y += pixel.y;
		[object setTranslation:objectTranslation];
		if ([object isMemberOfClass:[BBEditorObject class]]) {
			if (![[(BBEditorObject*)object objectType] isEqualToString:@"background"]) {
				[(BBEditorObject*)object setScreenRect:[[BBSceneController sharedSceneController].inputController 
														screenRectFromMeshRect:[(BBEditorObject*)object meshBounds]
														atPoint:CGPointMake(object.translation.x, object.translation.y)]];
			}
		}
	}
	[[BBSceneController sharedSceneController] setGamePosition:gamePosition];
	
}

- (void)dealloc {
	[super dealloc];
}

@end
