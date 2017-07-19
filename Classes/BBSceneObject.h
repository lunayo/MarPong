//
//  BBSceneObject.h
//  BBOpenGLGameTemplate
//
//  Created by ben smith on 1/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>

#import "BBMesh.h"
#import "BBPoint.h"
#import "BBSceneController.h";
#import "BBInputViewController.h";
#import "BBPoint.h";
#import "BBConfiguration.h";

@class BBCollider;
@class BBMesh;

@interface BBSceneObject : NSObject {
	// transform values
	BBPoint scale;
	BBPoint translation;
	BBPoint rotation;
	
	CGRect meshBounds;
	BBPoint startLocation;
	
	BBMesh * mesh;
	
	BOOL active;
	BOOL isCollided;
	
	CGFloat * matrix;
	
	BBCollider * collider;

}

@property (assign) BBPoint translation;
@property (assign) BBPoint scale;
@property (assign) BBPoint rotation;

@property (assign) CGRect meshBounds;
@property (assign) BOOL active;
@property (assign) BBPoint startLocation;
@property (retain) BBMesh * mesh;
@property (assign) CGFloat * matrix;

@property (retain) BBCollider * collider;
@property (assign) BOOL isCollided;

- (id) init;
- (void) dealloc;
- (void)awake;
- (void)render;
- (void)update;


@end
