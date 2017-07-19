//
//  BBWall.m
//  MarPong
//
//  Created by Lunayo on 10/18/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#pragma mark Wall

static NSInteger BBWallVertexStride = 2;
static NSInteger BBWallColorStride = 4;

static NSInteger BBWallOutlineVertexCount = 16;
static CGFloat BBWallOutlineVertexes [32] = {-0.5,0.0, -0.5,0.25, -0.5,0.5,
	-0.25,0.5, 0.0,0.5, 0.25,0.5, 0.5,0.5, 0.5,0.25, 0.5,0.0, 0.5,-0.25, 0.5,-0.5, 0.25,-0.5, 0.0,-0.5, -0.25,-0.5,
	-0.5,-0.5, -0.5,-0.25};

static CGFloat BBWallColorValues [64] = {1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0,
1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0,
1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0};

#import "BBWall.h"
#import "BBCollider.h"
#import "BBMaterialController.h"

@implementation BBWall

- (void)awake {
	mesh = [[BBMesh alloc] initWithVertexes:BBWallOutlineVertexes 
				vertexCount:BBWallOutlineVertexCount vertexSize:BBWallVertexStride 
					renderStyle:GL_LINE_LOOP];
	mesh.colors = BBWallColorValues;
	mesh.colorSize = BBWallColorStride;
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"WallAtlas"];
	self.mesh = [[BBMaterialController sharedMaterialController] quadFromAtlasKey:@"wall"];
	self.mass = 100;
	self.collider = [BBCollider collider];
	[self.collider setCheckForCollision:YES];
}

@end
