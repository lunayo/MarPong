//
//  BBStaticMarble.h
//  MarPong
//
//  Created by Lunayo on 9/27/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBMobileObject.h"
#import "BBTexturedQuad.h"

@interface BBStaticMarble : BBMobileObject {
	NSInteger marblePosition;
	NSString * marbleName;
	
	CGFloat * verts;
	CGFloat * colors;
	
	BOOL isMarbleMoving;
	
	CGPoint tempPosition;
	BBTexturedQuad * marbleQuad;
}

@property (assign) BOOL isMarbleMoving;
@property (assign) NSInteger marblePosition;
@property (assign) NSString	* marbleName;

- (void)checkArenaBounds;
- (void)didCollideWith:(BBSceneObject *)sceneObject;

@end
