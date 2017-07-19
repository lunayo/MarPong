//
//  BBSceneController.h
//  BBOpenGLGameTemplate
//
//  Created by ben smith on 1/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBSceneObject.h"
#import "BBCollisionController.h"
#import "BBPlayer.h"

@class BBInputViewController;
@class EAGLView;
@class BBCollisionController;
@class BBSceneObject;

@interface BBSceneController : NSObject {
	NSMutableArray * sceneObjects;
	NSMutableArray * objectsToAdd;
	NSMutableArray * objectsToRemove;
	NSMutableArray * scrollObject;
	
	BBInputViewController * inputController;
	BBCollisionController * collisionController;
	EAGLView * openGLView;
	
	NSTimer *animationTimer;
	NSTimeInterval animationInterval;
	NSTimeInterval deltaTime;
	NSDate *levelStartDate;
	NSTimeInterval lastFrameStartTime;
	NSTimeInterval thisFrameStartTime;
	
	BBPoint scrollSpeed;
	BBPlayer* player;
	CGPoint gamePosition;
}

@property (retain) BBInputViewController * inputController;
@property (retain) BBPlayer * player;
@property (retain) EAGLView * openGLView;
@property (retain) NSDate * levelStartDate;
@property (assign) NSMutableArray * sceneObjects;
@property NSTimeInterval animationInterval;
@property NSTimeInterval deltaTime;
@property (assign) BBPoint scrollSpeed;
@property (nonatomic, assign) NSTimer *animationTimer;
@property (assign) CGPoint gamePosition;

+ (BBSceneController*)sharedSceneController;
- (void) dealloc;
- (void) loadScene;
- (void) startScene;
- (void)gameLoop;
- (void)renderScene;
- (void)resetCollisionController;
- (void)setAnimationInterval:(NSTimeInterval)interval ;
- (void)setAnimationTimer:(NSTimer *)newTimer ;
- (void)startAnimation ;
- (void)stopAnimation ;
- (void)updateModel;
- (void)addObjectToScene:(BBSceneObject*)sceneObject;
- (void)removeObjectFromScene:(BBSceneObject*)sceneObject;
- (void)moveAllObjectBackward;
- (void)resetAllObjectPosition;
- (void)removeAllObjectOnScene;
- (NSString*)dataFilePath;
- (void)saveUserData;
- (void)loadUserData;

// 15 methods

@end
