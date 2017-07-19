//
//  BBTexturedButton.m
//  MarPong
//
//  Created by Lunayo on 11/1/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "BBTexturedButton.h"
#import "BBMaterialController.h"


@implementation BBTexturedButton
@synthesize objectName;

- (id)initWithUpKey:(NSString*)upKey downKey:(NSString*)downKey {
	self = [super init];
	if (self != nil) {
		upQuad = [[BBMaterialController sharedMaterialController] quadFromAtlasKey:upKey];
		downQuad = [[BBMaterialController sharedMaterialController] quadFromAtlasKey:downKey];
		[upQuad retain];
		[downQuad retain];
	}
	return self;
}

// called once when the object is first created.
- (void)awake {
	[self setNotPressedVertexes];
	screenRect = [[BBSceneController sharedSceneController].inputController 
				  screenRectFromMeshRect:self.meshBounds 
				  atPoint:CGPointMake(translation.x, translation.y)];
}

- (void)setPressedVertexes {
	self.mesh = downQuad;
}

- (void)setNotPressedVertexes {
	self.mesh = upQuad;
}

- (void) dealloc {
	[upQuad release];
	[downQuad release];
	[objectName release];
	[super dealloc];
}


@end
