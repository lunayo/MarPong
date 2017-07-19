//
//  BBWheel.m
//  MarPong
//
//  Created by Lunayo on 11/27/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "BBWheel.h"
#import "BBMaterialController.h"


@implementation BBWheel

- (id)init {
	self = [super init];
	if (self != nil) {
		wheelQuad = [[BBMaterialController sharedMaterialController] texturedQuadFromImage:@"cpWheel"];
		[wheelQuad retain];
	}
	return self;
}

- (void)awake {
	self.mesh = wheelQuad;
}

- (void)dealloc {
	[super dealloc];
	[wheelQuad release];
}

@end
