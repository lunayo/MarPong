//
//  BBCollider.m
//  MarPong
//
//  Created by Lunayo on 9/28/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "BBCollider.h"
#import "BBSceneObject.h"
#import "BBMesh.h"

@implementation BBCollider

@synthesize maxRadius,checkForCollision;


+(BBCollider*)collider
{
	BBCollider * collider = [[BBCollider alloc] init];
	collider.checkForCollision = NO;
	return [collider autorelease];	
}


- (void)updateCollider:(BBSceneObject*)sceneObject
{ 
	if (sceneObject == nil) return;
	transformedCentroid = BBPointMatrixMultiply([sceneObject mesh].centroid , [sceneObject matrix]);
	translation = transformedCentroid;
	maxRadius = sceneObject.scale.x;
	if (maxRadius < sceneObject.scale.y) 	maxRadius = sceneObject.scale.y;
	if ((maxRadius < sceneObject.scale.z) && ([sceneObject mesh].vertexSize > 2)) maxRadius = sceneObject.scale.z;
	maxRadius *= [sceneObject mesh].radius;
	
	scale = BBPointMake([sceneObject mesh].radius * sceneObject.scale.x, [sceneObject mesh].radius * sceneObject.scale.y,0.0);
}

- (BOOL)doesCollideWithCollider:(BBCollider *)aCollider {
	//check the distance between two point and radius
	CGFloat collisionDistance = self.maxRadius + aCollider.maxRadius;
	CGFloat objectDistance = BBPointDistance(self.translation, aCollider.translation);
	if (objectDistance < collisionDistance) return YES;
	return NO;
}

- (BOOL)doesCollideWithMesh:(BBSceneObject*)sceneObject
{
	NSInteger index;
	// step through each vertex of the scene object
	// transform it into real space coordinates
	// and check it against our radius
	for (index = 0; index < sceneObject.mesh.vertexCount; index++) {
		NSInteger position = index * sceneObject.mesh.vertexSize;
		BBPoint vert;
		if (sceneObject.mesh.vertexSize > 2) {
			vert = BBPointMake(sceneObject.mesh.vertexes[position], sceneObject.mesh.vertexes[position + 1], sceneObject.mesh.vertexes[position + 2]);		
		} else {
			vert = BBPointMake(sceneObject.mesh.vertexes[position], sceneObject.mesh.vertexes[position + 1], 0.0);
		}
		vert = BBPointMatrixMultiply(vert , [sceneObject matrix]);
		CGFloat distance = BBPointDistance(self.translation, vert);
		if (distance < self.maxRadius) return YES;
	}
	return NO;
}

- (void)dealloc {
	[super dealloc];
}
	
@end
