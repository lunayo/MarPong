//
//  BBCollisionController.m
//  MarPong
//
//  Created by Lunayo on 9/28/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "BBCollisionController.h"
#import "BBCollider.h"
#import "BBMobileObject.h"
#import "BBStaticMarble.h"


@implementation BBCollisionController

@synthesize sceneObjects;

- (void)handleCollisions {
	//two types of collision
	//one need to be checked, another do not
	if (allColliders == nil) allColliders = [[NSMutableArray alloc] init];
	[allColliders removeAllObjects];
	if (collidersToCheck == nil) collidersToCheck = [[NSMutableArray alloc] init];
	[collidersToCheck removeAllObjects];
	
	for (BBSceneObject * obj in sceneObjects) {
		if (obj.collider != nil){
			[allColliders addObject:obj];
			if (obj.collider.checkForCollision) [collidersToCheck addObject:obj];
		}	
	}
	
	// now check to see if anything is hitting anything else
	for (int i=0;i<[collidersToCheck count];i++) {
		for (int j=i+1;j<[allColliders count];j++) {
			if ([[[collidersToCheck objectAtIndex:i] collider] doesCollideWithCollider:[[allColliders objectAtIndex:j] collider]]) {
				if ([[collidersToCheck objectAtIndex:i] respondsToSelector:@selector(didCollideWith:)]) 
					[[collidersToCheck objectAtIndex:i] didCollideWith:[allColliders objectAtIndex:j]];
			}
		}
	}
}

@end
