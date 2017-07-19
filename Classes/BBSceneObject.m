//
//  BBSceneObject.m
//  BBOpenGLGameTemplate
//
//  Created by ben smith on 1/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BBSceneObject.h"
#import "BBSceneController.h"
#import "BBInputViewController.h"
#import "BBMesh.h"
#import "BBCollider.h"

#pragma mark Spinny Square mesh
static CGFloat spinnySquareVertices[8] = {
	-0.5f, -0.5f,
	0.5f,  -0.5f,
	-0.5f,  0.5f,
	0.5f,   0.5f,
};

static CGFloat spinnySquareColors[16] = {
	1.0, 1.0,   0, 1.0,
	0,   1.0, 1.0, 1.0,
	0,     0,   0,   0,
	1.0,   0, 1.0, 1.0,
};

@implementation BBSceneObject

@synthesize translation,scale,rotation,active,meshBounds,mesh,matrix,collider,startLocation, isCollided;

- (id) init
{
	self = [super init];
	if (self != nil) {
		translation = BBPointMake(0.0,0.0,0.0);
		scale = BBPointMake(1.0,1.0,1.0);
		rotation = BBPointMake(0.0,0.0,0.0);
		matrix = (CGFloat *) malloc(16 * sizeof(CGFloat*));
		active = NO;
		meshBounds = CGRectZero;
		self.collider = nil;
	}
	return self;
}

- (CGRect)meshBounds {
	if (CGRectEqualToRect(meshBounds, CGRectZero)) {
		meshBounds = [BBMesh meshBounds:mesh scale:scale];
	}
	return meshBounds;
}

// called once when the object is first created.
-(void)awake
{
	mesh = [[BBMesh alloc] initWithVertexes:spinnySquareVertices 
															vertexCount:4 
														 vertexSize:2
															renderStyle:GL_TRIANGLE_STRIP];
	mesh.colors = spinnySquareColors;
	mesh.colorSize = 4;
}

// called once every frame
-(void)update
{
	// clear the matrix
	glPushMatrix();
	glLoadIdentity();
	
	// move to my position
	glTranslatef(translation.x, translation.y, translation.z);
	
	// rotate
	glRotatef(rotation.x, 1.0f, 0.0f, 0.0f);
	glRotatef(rotation.y, 0.0f, 1.0f, 0.0f);
	glRotatef(rotation.z, 0.0f, 0.0f, 1.0f);
	
	//scale
	glScalef(scale.x, scale.y, scale.z);
	
	//save the matrix transform
	glGetFloatv(GL_MODELVIEW_MATRIX, matrix);
	
	//restore the matrix
	glPopMatrix();
	
	if (collider != nil) [collider updateCollider:self];
}

// called once every frame
-(void)render
{
	if (!mesh || !active) return;
	//clear the matrix
	glPushMatrix();
	glLoadIdentity();
	//set transform
	glMultMatrixf(matrix);
	[mesh render];
	glPopMatrix();
}


- (void) dealloc
{
	[mesh release];
	[collider release];
	free(matrix);
	[super dealloc];
}

@end
