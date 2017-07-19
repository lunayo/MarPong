//
//  BBMobileObject.m
//  MarPong
//
//  Created by Lunayo on 9/4/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "BBMobileObject.h"
#import "BBSceneController.h"
#import "BBConfiguration.h"


@implementation BBMobileObject

@synthesize speed, rotationalSpeed, mass;

- (void)update {
	CGFloat deltaTime = [[BBSceneController sharedSceneController] deltaTime];
	//using formula new position = last positon + velocity * delta time
	translation.x += speed.x * deltaTime;
	translation.y += speed.y * deltaTime;
	translation.z += speed.z * deltaTime;
	
	rotation.x += rotationalSpeed.x * deltaTime;
	rotation.y += rotationalSpeed.y * deltaTime;
	rotation.z += rotationalSpeed.z * deltaTime;
	
	[super update];
}

- (void)enableFriction {
	CGFloat Fn = self.mass * GRAVITY_FACTOR;
	CGFloat friction = COEFFICIENT_FRICTION * Fn;
	if(speed.x > 0)
		speed.x -= friction;
	if(speed.x < 0)
		speed.x += friction;
	if(speed.y > 0) 
		speed.y -= friction;
	if(speed.y < 0)
		speed.y += friction;
}

- (void)enableGravity {
	// The direction for the gravity to be in. 
	CGFloat gravityForce = self.mass * GRAVITY_FACTOR;
	speed.y += sinf(GRAVITY_DIRECTION/BBRADIANS_TO_DEGREES) * gravityForce;
}

- (CGFloat)pointDirectionWithX:(CGFloat)x1 andY:(CGFloat)y1 onX:(CGFloat)x2 andY:(CGFloat)y2 {
	//pytagoras to find angle
	CGFloat xOffset = x2 - x1;
	CGFloat yOffset = y2 - y1;
	CGFloat hypotenuses = sqrt(((xOffset)*(xOffset) + (yOffset)*(yOffset)));
	//validate divide by zero cases
	if (abs(xOffset) == 0.0 && abs(yOffset) == 0.0 )
		hypotenuses = 1;
	CGFloat angle = acos(xOffset/hypotenuses);
	angle = angle * BBRADIANS_TO_DEGREES;
	if (yOffset < 0 ) {
		angle = 360 - angle;
	}
	return angle;
}

- (void)moveByScrollSpeed {
	BBPoint scrollSpeed = [[BBSceneController sharedSceneController] scrollSpeed];
	translation.x -= scrollSpeed.x;
	translation.y -= scrollSpeed.y;
	
}	

- (CGFloat)pointDistanceWithX:(CGFloat)x1 andY:(CGFloat)y1 onX:(CGFloat)x2 andY:(CGFloat)y2 {
	return sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
}

- (CGFloat)getMarbleSpeed {
	return sqrt((speed.x * speed.x) + (speed.y * speed.y));
}

@end
