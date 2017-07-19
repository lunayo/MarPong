//
//  BBTexturedImage.m
//  MarPong
//
//  Created by Lunayo on 1/12/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import "BBTexturedImage.h"
#import "BBMaterialController.h"


@implementation BBTexturedImage
@synthesize imageName;

- (id)initWithImageName:(NSString *)name {
	self = [super init];
	if (self != nil) {
		imageName = name;
		bgQuad = [[BBMaterialController sharedMaterialController] quadFromAtlasKey:imageName];
		[bgQuad retain];
	}
	return self;
}

- (void)awake {
	self.mesh = bgQuad;
}

- (void)update {
	[super update];
	bgQuad = [[BBMaterialController sharedMaterialController] quadFromAtlasKey:imageName];
	self.mesh = bgQuad;
}

- (void)dealloc {
	[super dealloc];
	[bgQuad dealloc];
}

@end
