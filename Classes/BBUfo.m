//
//  BBUfo.m
//  MarPong
//
//  Created by Lunayo on 11/27/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "BBUfo.h"
#import "BBMaterialController.h"
#import "BBAnimatedQuad.h"


@implementation BBUfo

- (id)init {
	self = [super init];
	if (self != nil) {
		//load texture atlas data
		[[BBMaterialController sharedMaterialController] loadAtlasData:@"anUfo"];
	}
	return self;
}

- (void)awake {
	self.mesh = [[BBMaterialController sharedMaterialController] 
				 animationFromAtlasKeys:[NSArray arrayWithObjects:@"ufo 1",@"ufo 2",@"ufo 3",@"ufo 4",@"ufo 5",@"ufo 6",@"ufo 7",@"ufo 8",@"ufo 9",@"ufo 10",@"ufo 11",@"ufo 12",nil]];
	[(BBAnimatedQuad*)mesh setLoops:YES];
}

- (void)update {
	[super update];
	if ([mesh isKindOfClass:[BBAnimatedQuad class]]) [(BBAnimatedQuad*)mesh updateAnimation];
}

@end
