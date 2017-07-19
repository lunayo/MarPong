//
//  BBMobileObject.h
//  MarPong
//
//  Created by Lunayo on 9/4/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBSceneObject.h"


@interface BBMobileObject : BBSceneObject {
	BBPoint speed;
	BBPoint rotationalSpeed;
	CGFloat mass;
}

@property (assign) BBPoint speed;
@property (assign) BBPoint rotationalSpeed;
@property (assign) CGFloat mass;

- (CGFloat)pointDirectionWithX:(CGFloat)x1 andY:(CGFloat)y1 onX:(CGFloat)x2 andY:(CGFloat)y2;
- (CGFloat)pointDistanceWithX:(CGFloat)x1 andY:(CGFloat)y1 onX:(CGFloat)x2 andY:(CGFloat)y2;
- (void)enableFriction;
- (void)enableGravity;
- (void)moveByScrollSpeed;
- (CGFloat)getMarbleSpeed;

@end
