//
//  BBParticle.m
//  MarPong
//
//  Created by Lunayo on 11/29/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "BBParticle.h"


@implementation BBParticle
@synthesize position, velocity, life, decay, size, grow;

- (void)update {
	position.x += velocity.x;
	position.y += velocity.y;
	position.z += velocity.z;
	
	life -= decay;
	size += grow;
	if (size < 0.0) size = 0.0;
}

@end
