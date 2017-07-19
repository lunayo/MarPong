//
//  BBCollider.h
//  MarPong
//
//  Created by Lunayo on 9/28/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBSceneObject.h"

@protocol BBCollisionHandlerProtocol
- (void)didCollideWith:(BBSceneObject*)sceneObject; 
@end

@interface BBCollider : BBSceneObject {
	BBPoint transformedCentroid;
	BOOL checkForCollision;
	CGFloat maxRadius;
}

@property (assign) BOOL checkForCollision;
@property (assign) CGFloat maxRadius;

+ (BBCollider*)collider;
- (void)updateCollider:(BBSceneObject*)sceneObject;
- (BOOL)doesCollideWithCollider:(BBCollider*)aCollider;
- (BOOL)doesCollideWithMesh:(BBSceneObject *)sceneObject;
- (void)dealloc;

@end
