//
//  BBArrow.m
//  MarPong
//
//  Created by Lunayo on 12/19/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#pragma mark Arrow

static NSInteger BBArrowVertexStride = 2;
static NSInteger BBArrowColorStride = 4;

static NSInteger BBArrowOutlineVertexCount = 16;
static CGFloat BBArrowOutlineVertexes [32] = {-1.0,0.0, -1.0,0.5, -1.0,1.0,
	-0.5,1.0, 0.0,1.0, 0.5,1.0, 1.0,1.0, 1.0,0.5, 1.0,0.0, 1.0,-0.5, 1.0,-1.0, 0.5,-1.0, 0.0,-1.0, -0.5,-1.0,
	-1.0,-1.0, -1.0,-0.5};

static CGFloat BBArrowColorValues [64] = {1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0,
	1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0,
	1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0};

#import "BBArrow.h"
#import "BBCollider.h"

@implementation BBArrow
@synthesize type;

- (void)awake {
	mesh = [[BBMesh alloc] initWithVertexes:BBArrowOutlineVertexes 
								vertexCount:BBArrowOutlineVertexCount vertexSize:BBArrowVertexStride 
								renderStyle:GL_LINE_LOOP];
	mesh.colors = BBArrowColorValues;
	mesh.colorSize = BBArrowColorStride;
	
	self.collider = [BBCollider collider];
	[self.collider setCheckForCollision:YES];
}

@end
