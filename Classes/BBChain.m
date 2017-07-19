//
//  BBChain.m
//  MarPong
//
//  Created by Lunayo on 11/27/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "BBChain.h"
#import "BBMaterialController.h"

@implementation BBChain

- (id)init {
	self = [super init];
	if (self != nil) {
		chainQuad = [[BBMaterialController sharedMaterialController] texturedQuadFromImage:@"cpChain"];
		[chainQuad retain];
	}
	return self;
}

- (void)awake {
	self.mesh = chainQuad;
}

- (void)dealloc {
	[super dealloc];
	[chainQuad release];
}

@end
