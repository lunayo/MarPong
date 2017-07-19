//
//  BBStar.m
//  MarPong
//
//  Created by Lunayo on 11/29/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "BBStar.h"
#import "BBMaterialController.h"


@implementation BBStar

- (id)init {
	self = [super init];
	if (self != nil) {
		//load texture atlas data
		[[BBMaterialController sharedMaterialController] loadAtlasData:@"anStar"];
	}
	return self;
}

- (void)awake {
	self.mesh = [[BBMaterialController sharedMaterialController] 
				 animationFromAtlasKeys:[NSArray arrayWithObjects:@"star 1",@"star 2",@"star 3",nil]];
	[(BBAnimatedQuad*)mesh setLoops:YES];
}

- (void)update {
	[super update];
	if ([mesh isKindOfClass:[BBAnimatedQuad class]]) [(BBAnimatedQuad*)mesh updateAnimation];
}


@end
