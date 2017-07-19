//
//  BBRope.m
//  MarPong
//
//  Created by Lunayo on 11/5/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "BBRope.h"

#pragma mark Rope Mesh

static NSInteger BBRopeVertexStride = 2;
static NSInteger BBRopeColorStride = 4;
static NSInteger BBRopeOutlineVertexCount = 40;


@implementation BBRope

- (void)awake {
	verts = (CGFloat*) malloc(BBRopeOutlineVertexCount * BBRopeVertexStride * sizeof(CGFloat*));
	colors = (CGFloat*) malloc(BBRopeOutlineVertexCount * BBRopeColorStride * sizeof(CGFloat*));
	NSInteger vertexIndex = 0;
	//set vertex
	for (vertexIndex = 0; vertexIndex < BBRopeOutlineVertexCount; vertexIndex++) {
		NSInteger position = vertexIndex * BBRopeVertexStride;
		verts[position] = (-BBRopeOutlineVertexCount/2+vertexIndex)/10;
		verts[position+1] = 0.0;
	}
	//set color
	for (vertexIndex = 0; vertexIndex < BBRopeOutlineVertexCount * BBRopeColorStride; vertexIndex++) {
		colors[vertexIndex] = 1.0;
	}
	mesh = [[BBMesh alloc] initWithVertexes:verts vertexCount:BBRopeOutlineVertexCount vertexSize:BBRopeVertexStride renderStyle:GL_LINE_STRIP];
	mesh.colors = colors;
	mesh.colorSize = BBRopeColorStride;
	timeSpeed = 12;
}

- (void)update {
	[super update];
	elapsedTime += [BBSceneController sharedSceneController].deltaTime;
	NSInteger frame = (int)(elapsedTime/(1/timeSpeed));
	frame = frame % 12;
	if (frame == 1) {
		NSInteger vertexIndex = 0;
		//set vertex
		for (vertexIndex = 0; vertexIndex < BBRopeOutlineVertexCount; vertexIndex++) {
			NSInteger position = vertexIndex * BBRopeVertexStride;
			CGFloat lastPosition = verts[position+1];
			verts[position] = -BBRopeOutlineVertexCount/2+vertexIndex;
			verts[position+1] = RANDOM_INT(0,10);
			while(abs(verts[position+1]-lastPosition)>3) {
				verts[position+1] = RANDOM_INT(0,10);
			}
		}
	}
}

@end
