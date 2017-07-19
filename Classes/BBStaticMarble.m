//
//  BBStaticMarble.m
//  MarPong
//
//  Created by Lunayo on 9/27/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "BBStaticMarble.h"
#import "BBWall.h"
#import "BBMesh.h"
#import "BBSceneController.h"
#import "BBInputViewController.h"
#import "BBMaterialController.h"
#import "BBCollider.h"
#import "BBMarbleBooster.h"
#import "BBBackground.h"
#import "BBMarble.h"
#import "BBArrow.h"


#pragma mark Marble Mesh

static NSInteger BBMarbleVertexStride = 2;
static NSInteger BBMarbleColorStride = 4;
static NSInteger BBMarbleOutlineVertexCount = 16;

@implementation BBStaticMarble
@synthesize isMarbleMoving, marbleName, marblePosition;

- (id)init {
	self = [super init];
	if (self != nil) {
		mass = 10.0;
	}
	return self;
}

- (void)awake {
	verts = (CGFloat*) malloc(BBMarbleOutlineVertexCount * BBMarbleVertexStride * sizeof(CGFloat*));
	colors = (CGFloat*) malloc(BBMarbleOutlineVertexCount * BBMarbleColorStride * sizeof(CGFloat*));
	
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
	//set mesh radius to 0.5
	mesh.radius = 0.5;
	
	self.collider = [BBCollider collider];
	[self.collider setCheckForCollision:YES];
}

- (void)update {
	[super update];
	//marble is moving
	if (isMarbleMoving) {
		if (tempPosition.x == 0.0 && tempPosition.y == 0.0) {
			tempPosition.x = translation.x;
			tempPosition.y = translation.y;
		}
		if ([self getMarbleSpeed] <= 1.0) {
			speed.x = 0.0;
		}
		if (speed.x == 0.0f && speed.y == 0.0f)
			isMarbleMoving = NO;

		[self enableFriction];
		[self enableGravity];
		[self checkArenaBounds];
	}
	//marble is not moving
	else {
		speed.x = 0;
		speed.y = 0;
		isMarbleMoving = NO;
	}
	//[self checkArenaBounds];
}

- (void)checkArenaBounds {
	//check if collide with ground
	if (translation.y < (-160 + CGRectGetHeight(self.meshBounds)/2)) {
		translation.y = -160 + CGRectGetHeight(self.meshBounds)/2;
		//calculate the height of the marble when starting to fall
		CGFloat marbleHeight = [self pointDistanceWithX:tempPosition.x andY:tempPosition.y onX:translation.x andY:translation.y];
		
		speed.y = -speed.y * COEFFICIENT_OF_RESTITUTION;
		
		//tell the marble to stop
		if (marbleHeight <= 1.0 ) {
			speed.y = 0;
		}
		
		//reset the marble height
		marbleHeight = 0;
	
		//reset temporary position
		tempPosition.x = 0.0;
		tempPosition.y = 0.0;
	}
}

- (void)didCollideWith:(BBSceneObject*)sceneObject {
	if ([sceneObject isKindOfClass:[BBStaticMarble class]]) {
		//get the collidee variable
		BBPoint collideeSpeed = [(BBStaticMarble*)sceneObject speed];
		CGFloat collideeMass = [(BBStaticMarble*)sceneObject mass];
		BBPoint collideeTranslation = [(BBStaticMarble*)sceneObject translation];
		
		CGFloat dt;
		CGFloat r1,r2;
		r1 = self.collider.maxRadius;
		r2 = [[(BBStaticMarble*)sceneObject collider] maxRadius];
		
		CGFloat dx = collideeTranslation.x-self.translation.x, dy=collideeTranslation.y-self.translation.y; 
		CGFloat d = sqrt(dx*dx+dy*dy);
		
		//First calculate the component of velocity in the direction of (dx,dy)
		CGFloat vp1 = self.speed.x * dx/d + self.speed.y * dy/d;
		CGFloat vp2 = collideeSpeed.x * dx/d + collideeSpeed.y * dy/d;
		//Collision should have happened dt before you have detected r1+r2
		dt =(r1+r2-d) / (vp1-vp2);// the collision should have occurred at t-dt (Actually this is also an approximation).
		//check if divide by zero
		if (abs((vp1 - vp2)) <= 0.0)
			dt = r1+r2-d;
		
		//move those two ball backward
		translation.x -= speed.x * dt;
		translation.y -= speed.y * dt;
		collideeTranslation.x -= collideeSpeed.x * dt;
		collideeTranslation.y -= collideeSpeed.y * dt;
		
		dx = collideeTranslation.x-translation.x, dy = collideeTranslation.y-translation.y;
		// where x1,y1 are center of ball1, and x2,y2 are center of ball2
		CGFloat centerDistance = sqrt(dx*dx+dy*dy);
		// Unit vector in the direction of the collision
		CGFloat ax = dx/centerDistance, ay = dy/centerDistance; 
		// Projection of the velocities in these axes
		CGFloat va1 = (self.speed.x * ax + self.speed.y * ay), vb1=(-self.speed.x * ay + self.speed.y * ax); 
		CGFloat va2 = (collideeSpeed.x * ax + collideeSpeed.y * ay), vb2=(-collideeSpeed.x * ay + collideeSpeed.y * ax);
		// New velocities in these axes (after collision): ed<=1,  for elastic collision ed=1
		CGFloat ed = 0.9;
		CGFloat vaP1 = va1 + (1+ed) * (va2-va1) / (1+self.mass/collideeMass);
		CGFloat vaP2 = va2 + (1+ed) * (va1-va2) / (1+collideeMass/self.mass);
		// Undo the projections
		// new vx,vy for ball 1 after collision
		speed.x = vaP1 * ax-vb1 * ay;  speed.y = vaP1*ay + vb1*ax;
		// new vx,vy for ball 2 after collision
		collideeSpeed.x = vaP2 * ax-vb2 * ay; collideeSpeed.y = vaP2*ay + vb2*ax;
		
		translation.x += speed.x * dt;
		translation.y += speed.y * dt;
		collideeTranslation.x += collideeSpeed.x * dt;
		collideeTranslation.y += collideeSpeed.y * dt;
		
		//set the collidee variable
		[(BBStaticMarble*)sceneObject setTranslation:collideeTranslation];
		[(BBStaticMarble*)sceneObject setSpeed:collideeSpeed];
		[(BBStaticMarble*)sceneObject setIsMarbleMoving:YES];
		isCollided = YES;
	}
	//hit wall
	else if ([sceneObject isKindOfClass:[BBWall class]]) {
		
		if (![self.collider doesCollideWithMesh:sceneObject]) return;
		BBPoint collideeSpeed = [(BBWall*)sceneObject speed];
		CGFloat collideeMass = [(BBWall*)sceneObject mass];
		BBPoint collideeTranslation = [(BBWall*)sceneObject translation];
		
		CGFloat dt = 0.03;
		
		//So you should move those two ball backward
		translation.x -= speed.x * dt;
		translation.y -= speed.y * dt;
		collideeTranslation.x -= collideeSpeed.x * dt;
		collideeTranslation.y -= collideeSpeed.y * dt;
		
		CGFloat dx = collideeTranslation.x-translation.x, dy = collideeTranslation.y-translation.y;
		// where x1,y1 are center of ball1, and x2,y2 are center of ball2
		CGFloat centerDistance = sqrt(dx*dx+dy*dy);
		// Unit vector in the direction of the collision
		CGFloat ax = dx/centerDistance, ay = dy/centerDistance; 
		// Projection of the velocities in these axes
		CGFloat va1 = (self.speed.x * ax + self.speed.y * ay), vb1=(-self.speed.x * ay + self.speed.y * ax); 
		CGFloat va2 = (collideeSpeed.x * ax + collideeSpeed.y * ay), vb2=(-collideeSpeed.x * ay + collideeSpeed.y * ax);
		// New velocities in these axes (after collision): ed<=1,  for elastic collision ed=1
		CGFloat ed = 0.7;
		CGFloat vaP1 = va1 + (1+ed) * (va2-va1) / (1+self.mass/collideeMass);
		CGFloat vaP2 = va2 + (1+ed) * (va1-va2) / (1+collideeMass/self.mass);
		// Undo the projections
		// new vx,vy for ball 1 after collision
		speed.x = vaP1 * ax-vb1 * ay;  speed.y = vaP1*ay + vb1*ax;
		// new vx,vy for ball 2 after collision
		collideeSpeed.x = vaP2 * ax-vb2 * ay; collideeSpeed.y = vaP2*ay + vb2*ax;
		
		translation.x += speed.x * dt;
		translation.y += speed.y * dt;
		collideeTranslation.x += collideeSpeed.x * dt;
		collideeTranslation.y += collideeSpeed.y * dt;
		
	}
	//hit marble booster
	else if ([sceneObject isKindOfClass:[BBMarbleBooster class]]) {
		if (![self.collider doesCollideWithMesh:sceneObject]) return;
		BBPoint collideeTranslation = [(BBMarbleBooster*)sceneObject translation];
		BBPoint collideeSpeed = [(BBMarbleBooster*)sceneObject speed];
		CGFloat timeStep = 0.2;
		//So you should move those ball backward
		translation.x -= speed.x * timeStep;
		translation.y -= speed.y * timeStep;
		collideeTranslation.x -= collideeSpeed.x * timeStep;
		collideeTranslation.y -= collideeSpeed.y * timeStep;
		
		if ([self pointDirectionWithX:translation.x andY:translation.y onX:collideeTranslation.x andY:collideeTranslation.y] >= 240 && 
			[self pointDirectionWithX:translation.x andY:translation.y onX:collideeTranslation.x andY:collideeTranslation.y] <= 300) {
			//moving the booster up
			collideeTranslation.y = speed.y * 0.7;
			[(BBMarbleBooster*)sceneObject setSpeed:collideeSpeed];
			//set the ball speed after hit by booster
			speed.y = -speed.y;
			speed.x = speed.x * MARBLE_BOOSTER_FACTOR;
			//moving the booster down
			collideeTranslation.y = speed.y * 0.7;
			[(BBMarbleBooster*)sceneObject setSpeed:collideeSpeed];
		}
		else {
			speed.x = -speed.x * COEFFICIENT_OF_RESTITUTION;
		}
		//move it back
		translation.x += speed.x * timeStep;
		translation.y += speed.y * timeStep;
		collideeTranslation.x += collideeSpeed.x * timeStep;
		collideeTranslation.y += collideeSpeed.y * timeStep;
		//set the variable
		[(BBMarbleBooster*)sceneObject setSpeed:collideeTranslation];
		[(BBMarbleBooster*)sceneObject setIsCollided:YES];
	}
	//hit arrow
	else if ([sceneObject isKindOfClass:[BBArrow class]]) {
		if (![self.collider doesCollideWithMesh:sceneObject]) return;
		//speed variable
		NSInteger iterateSpeedAdd = 20;
		//check arrow type
		//right
		if ([[(BBArrow*)sceneObject type] isEqualToString:@"right"]) {
			speed.x += iterateSpeedAdd;
		}
		//left
		else if ([[(BBArrow*)sceneObject type] isEqualToString:@"left"]) {
			speed.x -= iterateSpeedAdd;
		}
		//up
		else if ([[(BBArrow*)sceneObject type] isEqualToString:@"up"]) {
			speed.y += iterateSpeedAdd;
		}
		//down
		else {
			speed.y -= iterateSpeedAdd;
		}
	}
}

- (void)dealloc {
	[super dealloc];
	[marbleName release];
}

@end
