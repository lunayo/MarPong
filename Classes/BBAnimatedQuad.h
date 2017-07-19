//
//  BBAnimatedQuad.h
//  MarPong
//
//  Created by Lunayo on 11/27/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "BBTexturedQuad.h"


@interface BBAnimatedQuad : BBTexturedQuad {
	NSMutableArray * frameQuads;
	CGFloat speed;
	NSTimeInterval elapsedTime;
	BOOL loops;
	BOOL didFinish;
}

@property (assign) CGFloat speed;
@property (assign) BOOL loops;
@property (assign) BOOL didFinish;

- (id)init;
- (void)dealloc;
- (void)addFrame:(BBTexturedQuad*)aQuad;
- (void)setFrame:(BBTexturedQuad*)quad;
- (void)updateAnimation;

@end
