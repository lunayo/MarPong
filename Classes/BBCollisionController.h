//
//  BBCollisionController.h
//  MarPong
//
//  Created by Lunayo on 9/28/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBSceneObject.h"

@class BBSceneObject;

@interface BBCollisionController : NSObject {
	NSArray * sceneObjects;
	NSMutableArray * allColliders;
	NSMutableArray * collidersToCheck;
}

@property (retain) NSArray * sceneObjects;

- (void)handleCollisions;

@end
