//
//  BBSceneController.m
//  BBOpenGLGameTemplate
//
//  Created by Lunayo on 9/4/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "BBSceneController.h"
#import "BBInputViewController.h"
#import "EAGLView.h"
#import "BBSceneObject.h"
#import "BBButton.h"
#import "BBMarble.h"
#import "BBLevelReader.h"
#import "BBCollisionController.h"
#import "BBMaterialController.h"
#import "BBPlayer.h"
#import "BBBackground.h"
#import "BBEditorObject.h"
#import "BBLogBoard.h"

@implementation BBSceneController

@synthesize inputController, openGLView;
@synthesize animationInterval, animationTimer, levelStartDate, deltaTime, scrollSpeed, player, sceneObjects, gamePosition;

// Singleton accessor.  this is how you should ALWAYS get a reference
// to the scene controller.  Never init your own. 
+(BBSceneController*)sharedSceneController
{
  static BBSceneController *sharedSceneController;
  @synchronized(self)
  {
    if (!sharedSceneController)
      sharedSceneController = [[BBSceneController alloc] init];
	}
	return sharedSceneController;
}

- (id)init {
	self = [super init];
	if (self != nil) {
		//load game position for the first time
		gamePosition.x = IPHONE_BACKING_WIDTH/2;
		gamePosition.y = IPHONE_BACKING_HEIGHT/2;
		player = [[BBPlayer alloc] init];
	}
	return self;
}

#pragma mark save and load user data

- (NSString*)dataFilePath {
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [path objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"user data"];
}

- (void)saveUserData {
	NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
	//set player name
	[tempDict setObject:[player name] forKey:@"player name"];
	//set marble collection
	[tempDict setObject:[NSMutableArray arrayWithArray:[player marbleCollection]] forKey:@"marble collection"];
	//set level collection
	[tempDict setObject:[NSMutableArray arrayWithArray:[player levelCollection]] forKey:@"level collection"];
	//change integer to number
	NSNumber* tempNumber = [NSNumber numberWithInt:[player pongoPoint]];
	//set pongo point
	[tempDict setObject:tempNumber forKey:@"pongo point"];
	//write to file path
	[tempDict writeToFile:[self dataFilePath] atomically:YES];
	[tempDict release];
}

- (void)loadUserData {
	NSString *filePath = [self dataFilePath];
	//if save data exist, set it to player
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
		//load data to player
		player.name = [dict objectForKey:@"player name"];
		player.marbleCollection = [NSMutableArray arrayWithArray:[dict objectForKey:@"marble collection"]];
		player.levelCollection = [NSMutableArray arrayWithArray:[dict objectForKey:@"level collection"]];
		player.pongoPoint = [[dict objectForKey:@"pongo point"] floatValue];
	}
	else {
		player.name = @"Lunayo";
	}

}

#pragma mark scene preload

// this is where we initialize all our scene objects
- (void)loadScene {
	// this is where we store all our objects
	sceneObjects = [[NSMutableArray alloc] init];
	
	[self loadUserData];
	//level reader
	[[BBLevelReader sharedLevelReader] readLevel:@"Main Menu"];
	//[inputController triggerEditor];
		
	//1 level every start game
	[player addLevelToCollection:@"level 1"];
	
	//collision controller
	collisionController = [[BBCollisionController alloc] init];
	collisionController.sceneObjects = sceneObjects;
	
}

- (void)addObjectToScene:(BBSceneObject*)sceneObject {
	if(objectsToAdd == nil) objectsToAdd = [[NSMutableArray alloc]init];
	sceneObject.active = YES;
	[sceneObject awake];
	[objectsToAdd addObject:sceneObject];
}

- (void)removeObjectFromScene:(BBSceneObject*)sceneObject {
	if(objectsToRemove == nil) objectsToRemove = [[NSMutableArray alloc] init];
	[objectsToRemove addObject:sceneObject];
}

- (void)removeAllObjectOnScene {
	sceneObjects = [[NSMutableArray alloc] init];
}

-(void) startScene
{
	self.animationInterval = 1.0/60.0;
	[self startAnimation];
	//reset clock
	self.levelStartDate = [NSDate date];
	lastFrameStartTime = 0;
}

#pragma mark Larger Screen Ability

- (void)moveAllObjectBackward {
	BBPoint tempSpeed;
	BBPoint tempTranslation;
	NSInteger backgroundHeight, backgroundWidth;
	scrollObject = [[NSMutableArray alloc] init];
	[scrollObject addObjectsFromArray:sceneObjects];
	//remove object from temp array
	//all object move backward except hero marble
	for (int i = 0; i < [sceneObjects count] ; i++) {
		if ([[sceneObjects objectAtIndex:i] isKindOfClass:[BBMarble class]]) {
			tempSpeed = [(BBMarble*)[sceneObjects objectAtIndex:i] speed];
			tempTranslation = [(BBMarble*)[sceneObjects objectAtIndex:i] translation];
			if ([[scrollObject objectAtIndex:i] isKindOfClass:[BBMarble class]]) {
				[scrollObject removeObjectAtIndex:i];
			}
			break;
		}
		//get background width and height
		if ([[sceneObjects objectAtIndex:i] isKindOfClass:[BBBackground class]]) {
			backgroundWidth = CGRectGetWidth([[sceneObjects objectAtIndex:i] meshBounds]);
			backgroundHeight = CGRectGetHeight([[sceneObjects objectAtIndex:i] meshBounds]);
		}
		else {
			tempSpeed.x = 0;
			tempSpeed.y = 0;
		}

	}
	if (abs(tempSpeed.x) <= 1.0) scrollSpeed.x = 0.0;
	if (abs(tempSpeed.y) <= 1.0) scrollSpeed.y = 0.0;
	scrollSpeed.x = tempSpeed.x * 0.055;
	scrollSpeed.y = tempSpeed.y * 0.07;
	gamePosition.x += scrollSpeed.x;
	gamePosition.y += scrollSpeed.y;
	//validate game postition for not over the background image
	if (gamePosition.x <= IPHONE_BACKING_WIDTH/2  || gamePosition.x >= backgroundWidth - 300)
		scrollSpeed.x = 0;
	if (gamePosition.y <= IPHONE_BACKING_HEIGHT/2 || gamePosition.y >= backgroundHeight - 300)
		scrollSpeed.y = 0;
		
	//move all mobile object
	[scrollObject makeObjectsPerformSelector:@selector(moveByScrollSpeed)];
	[scrollObject release];
}

- (void)resetCollisionController {
	//collision controller
	collisionController = [[BBCollisionController alloc] init];
	collisionController.sceneObjects = sceneObjects;
}

- (void)resetAllObjectPosition {
	for (int i = 0; i < [sceneObjects count] ; i++) {
		BBPoint tempLocation = [[sceneObjects objectAtIndex:i] translation];
		tempLocation = [[sceneObjects objectAtIndex:i] startLocation];
		[[sceneObjects objectAtIndex:i] setTranslation:tempLocation];
		[[sceneObjects objectAtIndex:i] setIsCollided:NO];
		[[sceneObjects objectAtIndex:i] setActive:YES];
	}
	//reset game position
	gamePosition.x = IPHONE_BACKING_WIDTH/2;
	gamePosition.y = IPHONE_BACKING_HEIGHT/2;
}

#pragma mark Game Loop

- (void)gameLoop
{
	//auto release pool for garbage collection
	NSAutoreleasePool * apool = [[NSAutoreleasePool alloc] init];
	
	thisFrameStartTime = [levelStartDate timeIntervalSinceNow];
	deltaTime = lastFrameStartTime - thisFrameStartTime;
	lastFrameStartTime = thisFrameStartTime;
	
	//add any queued scene object
	if ([objectsToAdd count] > 0) {
		[sceneObjects addObjectsFromArray:objectsToAdd];
		[objectsToAdd removeAllObjects];
	}
	// apply our inputs to the objects in the scene
	[self updateModel];
	// deal with collision
	[collisionController handleCollisions];
	// send our objects to the renderer
	[self renderScene];
	
	//move all the object backward if marble move forward
	//larger screen ability
	[self moveAllObjectBackward];
	
	//remove any object that need removal
	if ([objectsToRemove count] > 0) {
		[sceneObjects removeObjectsInArray:objectsToRemove];
		[objectsToRemove removeAllObjects];
	}
	[apool release];
}

- (void)updateModel
{
	// simply call 'update' on all our scene objects
	[inputController updateInterface];
	[sceneObjects makeObjectsPerformSelector:@selector(update)];
	// be sure to clear the events
	[inputController clearEvents];
}

- (void)renderScene
{
	// turn openGL 'on' for this frame
	[openGLView beginDraw];
	// simply call 'render' on all our scene objects
	[sceneObjects makeObjectsPerformSelector:@selector(render)];
	// draw the interface on top of everything
	[inputController renderInterface];
	// finalize this frame
	[openGLView finishDraw];
}


#pragma mark Animation Timer

// these methods are copied over from the EAGLView template

- (void)startAnimation {
	self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}

- (void)stopAnimation {
	self.animationTimer = nil;
}

- (void)setAnimationTimer:(NSTimer *)newTimer {
	[animationTimer invalidate];
	animationTimer = newTimer;
}

- (void)setAnimationInterval:(NSTimeInterval)interval {	
	animationInterval = interval;
	if (animationTimer) {
		[self stopAnimation];
		[self startAnimation];
	}
}

#pragma mark dealloc

- (void) dealloc
{
	[self stopAnimation];
	[sceneObjects release];
	[objectsToAdd release];
	[objectsToRemove release];
	[inputController release];
	[player release];
	[openGLView release];
	[collisionController release];
	[super dealloc];
}


@end
