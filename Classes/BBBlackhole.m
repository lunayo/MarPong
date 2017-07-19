//
//  BBBlackhole.m
//  MarPong
//
//  Created by Lunayo on 11/29/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "BBBlackhole.h"
#import "BBMaterialController.h"
#import "BBAnimatedQuad.h"
#import "BBCollider.h"

static NSInteger BBBlackholeVertexStride = 2;
static NSInteger BBBlackholeColorStride = 4;
static NSInteger BBBlackholeOutlineVertexCount = 16;


@implementation BBBlackhole

- (id)init {
	self = [super init];
	if (self != nil) {
		//load texure atlas
		[[BBMaterialController sharedMaterialController] loadAtlasData:@"anBlackHole"];
	}
	return self;
}

- (void)awake {
	verts = (CGFloat*) malloc(BBBlackholeOutlineVertexCount * BBBlackholeVertexStride * sizeof(CGFloat*));
	colors = (CGFloat*) malloc(BBBlackholeOutlineVertexCount * BBBlackholeColorStride * sizeof(CGFloat*));
	
	//radian for angle of each vertex
	CGFloat radians = 0.0;
	CGFloat radianIncrement = (2.0 * 3.14159) / (CGFloat)BBBlackholeOutlineVertexCount;
	
	//set Vertex
	NSInteger vertexIndex = 0;
	for (vertexIndex = 0; vertexIndex < BBBlackholeOutlineVertexCount; vertexIndex++) {
		NSInteger position = vertexIndex * BBBlackholeVertexStride;
		verts[position] = cosf(radians);
		verts[position+1] = sinf(radians);
		//move to next vertex
		radians += radianIncrement;
	}
	
	//set Color
	for (vertexIndex = 0; vertexIndex < BBBlackholeOutlineVertexCount * BBBlackholeColorStride; vertexIndex++) {
		colors[vertexIndex] = 1.0;
	}
	//implement texture Blackhole
	self.mesh = [[BBMaterialController sharedMaterialController] animationFromAtlasKeys:[NSArray arrayWithObjects:@"blackhole 1",@"blackhole 2",@"blackhole 3",@"blackhole 4",@"blackhole 5",@"blackhole 6",@"blackhole 7",@"blackhole 8",@"blackhole 9",@"blackhole 10",@"blackhole 11",@"blackhole 12",@"blackhole 13",nil]];
	
	[(BBAnimatedQuad*)mesh setLoops:YES];
	
	//set mesh radius to 0.5
	mesh.radius = 0.5;
	
	self.collider = [BBCollider collider];
	[self.collider setCheckForCollision:YES];
}

- (void)update {
	[super update];
	if ([mesh isKindOfClass:[BBAnimatedQuad class]]) [(BBAnimatedQuad*)mesh updateAnimation];
}

@end
