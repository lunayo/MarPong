//
//  BBMarbleBooster.m
//  MarPong
//
//  Created by Lunayo on 11/5/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "BBMarbleBooster.h"
#import "BBCollider.h"
#import "BBMaterialController.h"

#pragma mark MarbleBooster Mesh

static NSInteger BBMarbleBoosterVertexStride = 2;
static NSInteger BBMarbleBoosterColorStride = 4;

static NSInteger BBMarbleBoosterOutlineVertexCount = 16;
static CGFloat BBMarbleBoosterOutlineVertexes [32] = {-1.0,0.0, -1.0,0.5, -1.0,1.0,
	-0.5,1.0, 0.0,1.0, 0.5,1.0, 1.0,1.0, 1.0,0.5, 1.0,0.0, 1.0,-0.5, 1.0,-1.0, 0.5,-1.0, 0.0,-1.0, -0.5,-1.0,
	-1.0,-1.0, -1.0,-0.5};

static CGFloat BBMarbleBoosterColorValues [64] = {1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0,
	1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0,
	1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0};

@implementation BBMarbleBooster

- (void)awake {
	mesh = [[BBMesh alloc] initWithVertexes:BBMarbleBoosterOutlineVertexes 
								vertexCount:BBMarbleBoosterOutlineVertexCount vertexSize:BBMarbleBoosterVertexStride 
								renderStyle:GL_LINE_LOOP];
	mesh.colors = BBMarbleBoosterColorValues;
	mesh.colorSize = BBMarbleBoosterColorStride;

	self.mesh = [[BBMaterialController sharedMaterialController] texturedQuadFromImage:@"cpZeoCrystal"];
	
	
	self.collider = [BBCollider collider];
	[self.collider setCheckForCollision:YES];
}

- (void)update {
	[super update];
	if (isCollided)
		[self checkAreaBounds];
}

- (void)checkAreaBounds {
	if (translation.y >= startLocation.y+10 || translation.y <= startLocation.y-10) {
		translation.y = startLocation.y;
		speed.x = 0;
		speed.y = 0;
	}
}

@end
