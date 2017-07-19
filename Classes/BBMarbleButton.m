//
//  BBMarbleButton.m
//  MarPong
//
//  Created by Lunayo on 1/14/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import "BBMarbleButton.h"
#import "BBMaterialController.h"
#import "BBSelectButton.h"

#pragma mark Marble Mesh

static NSInteger BBMarbleVertexStride = 2;
static NSInteger BBMarbleColorStride = 4;
static NSInteger BBMarbleOutlineVertexCount = 16;


@implementation BBMarbleButton
@synthesize marbleName,origin,description,pressed;


- (void)awake {
	verts = (CGFloat*) malloc(BBMarbleOutlineVertexCount * BBMarbleVertexStride * sizeof(CGFloat*));
	colors = (CGFloat*) malloc(BBMarbleOutlineVertexCount * BBMarbleColorStride * sizeof(CGFloat*));
	screenRect = [[BBSceneController sharedSceneController].inputController screenRectFromMeshRect:self.meshBounds atPoint:CGPointMake(translation.x, translation.y)];
	//radian for angle of each vertex
	CGFloat radians = 0.0;
	CGFloat radianIncrement = (2.0 * 3.14159) / (CGFloat)BBMarbleOutlineVertexCount;
	
	//set Vertex
	NSInteger vertexIndex = 0;
	for (vertexIndex = 0; vertexIndex < BBMarbleOutlineVertexCount; vertexIndex++) {
		NSInteger position = vertexIndex * BBMarbleVertexStride;
		verts[position] = cosf(radians);
		verts[position+1] = sinf(radians);
		//move to next vertex
		radians += radianIncrement;
	}
	
	//set Color
	for (vertexIndex = 0; vertexIndex < BBMarbleOutlineVertexCount * BBMarbleColorStride; vertexIndex++) {
		colors[vertexIndex] = 1.0;
	}
	//implement texture Marble
	self.mesh = [[BBMaterialController sharedMaterialController] quadFromAtlasKey:marbleName];
	pressed = NO;
}

- (void)handleTouches {
	NSSet * touches = [[BBSceneController sharedSceneController].inputController touchEvents];
	if ([touches count] == 0) return;
	
	BOOL pointInBounds = NO;
	for (UITouch * touch in [touches allObjects]) {
		CGPoint touchPoint = [touch locationInView:[touch view]];
		if (CGRectContainsPoint(screenRect, touchPoint)) {
			pointInBounds = YES;
			if (touch.phase == UITouchPhaseBegan || touch.phase == UITouchPhaseStationary) 
				[self touchDown];
		}
		if (touch.phase == UITouchPhaseEnded) [self touchUp];
	}
}
- (void)touchUp {
	if (!pressed) return;
	pressed = NO;
	[[[BBSceneController sharedSceneController].inputController marbleText] setName:marbleName];
	[[[BBSceneController sharedSceneController].inputController marbleText] setOrigin:origin];
	[[[BBSceneController sharedSceneController].inputController marbleText] setDescription:description];
	//set key name for select button
	[[[BBSceneController sharedSceneController].inputController jarImage] setImageName:marbleName];
	[[[BBSceneController sharedSceneController].inputController selectButton] setKeyName:marbleName];
	NSLog(@"%@",[[[BBSceneController sharedSceneController].inputController selectButton] keyName]);
}

- (void)touchDown {
	if (pressed) return;
	pressed = YES;
}

- (void)update {
	[super update];
	[self handleTouches];
	
}

- (void)dealloc {
	[super dealloc];
}

@end
