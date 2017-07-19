//
//  BBInputViewController.m
//  BBOpenGLGameTemplate
//
//  Created by ben smith on 1/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BBInputViewController.h"
#import "BBSceneController.h"
#import "BBLevelReader.h"
#import "BBStaticMarble.h"
#import "BBMarble.h"
#import "BBMaterialController.h"
#import "BBMarbleButton.h"
#import "BBMarbleText.h"
#import "BBSelectButton.h"
#import "BBResumeBoard.h"
#import "BBEditorObject.h"
#import "BBTexturedButton.h"
#import "BBTexturedImage.h"
#import "addObjectBoard.h"


@implementation BBInputViewController

@synthesize touchEvents,levelName, level, marbleText, isVSGame, keyName, selectButton, editorObject;
@synthesize jarImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// init our touch storage set
		touchEvents = [[NSMutableSet alloc] init];
		interfaceObjects = [[NSMutableArray alloc] init];
		//create resume board
		resumeBoard = [[BBResumeBoard alloc] init];
		editorBoard = [[addObjectBoard alloc] init];
	}
	return self;
}

- (void)loadView {
}

- (CGRect)screenRectFromMeshRect:(CGRect)rect atPoint:(CGPoint)meshCenter {
	CGPoint screenCenter = CGPointZero;
	CGPoint rectOrigin = CGPointZero;
	
	screenCenter.x = meshCenter.y + 160.0;
	screenCenter.y = meshCenter.x + 240.0;
	
	rectOrigin.x = screenCenter.x - (CGRectGetHeight(rect)/2.0);
	rectOrigin.y = screenCenter.y - (CGRectGetWidth(rect)/2.0);
	
	return CGRectMake(rectOrigin.x, rectOrigin.y, CGRectGetHeight(rect), CGRectGetWidth(rect));
	
}

#pragma mark Touch Event Handlers

// just a handy way for other object to clear our events
- (void)clearEvents
{
	[touchEvents removeAllObjects];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// just store them all in the big set.
	[touchEvents addObjectsFromArray:[touches allObjects]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	// just store them all in the big set.
	[touchEvents addObjectsFromArray:[touches allObjects]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	// just store them all in the big set.
	[touchEvents addObjectsFromArray:[touches allObjects]];
}


#pragma mark unload, dealloc

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark Button Function

- (void)level1ButtonDown {
}

- (void)level1ButtonUp {
	//change scene
	[[BBLevelReader sharedLevelReader] readLevel:@"Level 1"];
	//set level name
	levelName = @"Level 1";
	level = 1;
	[[BBSceneController sharedSceneController] resetCollisionController];
}

- (void)level2ButtonDown {
}

- (void)level2ButtonUp {
	//change scene
	[[BBLevelReader sharedLevelReader] readLevel:@"Level 2"];
	levelName = @"Level 2";
	level = 2;
	[[BBSceneController sharedSceneController] resetCollisionController];
}

- (void)level3ButtonDown {
}

- (void)level3ButtonUp {
	//change scene
	[[BBLevelReader sharedLevelReader] readLevel:@"Level 3"];
	levelName = @"Level 3";
	level = 3;
	[[BBSceneController sharedSceneController] resetCollisionController];
}

- (void)level4ButtonDown {
}

- (void)level4ButtonUp {
	//change scene
	[[BBLevelReader sharedLevelReader] readLevel:@"Level 4"];
	levelName = @"Level 4";
	level = 4;
	[[BBSceneController sharedSceneController] resetCollisionController];
}

- (void)level5ButtonDown {
}

- (void)level5ButtonUp {
	//change scene
	[[BBLevelReader sharedLevelReader] readLevel:@"Level 5"];
	levelName = @"Level 5";
	level = 5;
	[[BBSceneController sharedSceneController] resetCollisionController];
}

- (void)zodiacButtonDown{
}

- (void)zodiacButtonUp {
	[[BBLevelReader sharedLevelReader] getMarbleCollection];
	[[BBLevelReader sharedLevelReader] readLevel:@"Zodiac Menu"];
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"MarbleAtlas"];
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"ButtonAtlas"];
	
	NSString* tempMarbleName;
	NSMutableDictionary * marbleDictionary = [[BBLevelReader sharedLevelReader] kindOfMarble];
	NSInteger index = 1;
	NSInteger horizontal = 0;
	marbleText = [[BBMarbleText alloc] init];
	[marbleText awake];
	marbleText.translation = BBPointMake(110, -55, 0);
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:marbleText];
	[marbleText release];

	selectButton = [[BBSelectButton alloc] init];
	selectButton.translation = BBPointMake(170, 110, 0);
	selectButton.scale = BBPointMake(30, 30, 1);
	[selectButton awake];
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:selectButton];
	[selectButton release];
	
	for (id key in [marbleDictionary allKeys]) {
		NSDictionary * record = [marbleDictionary objectForKey:key];
		if ([[record valueForKey:@"type"] isEqualToString:@"zodiac"]) {
			if (index%5==0) {
				horizontal++;
				index = 1;
			}
			if ([[[BBSceneController sharedSceneController].player marbleCollection] containsObject:key]) {
				//if contain zodiac marble in player marble collection
				
				if (marbleText.name == nil) {
					marbleText.name = key;
					marbleText.origin = [record valueForKey:@"origin"];
					marbleText.description = [record valueForKey:@"description"];
					tempMarbleName = key;
				}
				
				BBMarbleButton * marble = [[BBMarbleButton alloc] init];
				marble.scale = BBPointMake(35, 35, 1);
				marble.translation = BBPointMake(-205+index*45, 70-45*horizontal, 1);
				marble.marbleName = key;
				marble.origin = [record valueForKey:@"origin"];
				marble.description = [record valueForKey:@"description"];
				[marble awake];
				[self addObjectToInterface:marble];
				[marble release];
				
			}
			else {
				//not contain will gray out or didnt appear
				BBTexturedImage * marble = [[BBTexturedImage alloc] initWithImageName:@"marble lock"];
				marble.scale = BBPointMake(35, 35, 1);
				marble.translation = BBPointMake(-205+index*45, 70-45*horizontal, 1);
				[marble awake];
				[self addObjectToInterface:marble];
				[marble release];
			}
			index++;
		}
	}
	
	jarImage = [[BBTexturedImage alloc] init];
	[jarImage awake];
	jarImage.imageName = tempMarbleName;
	jarImage.translation = BBPointMake(57, 55, 0);
	jarImage.scale = BBPointMake(40, 40, 1);
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:jarImage];
	
	levelName = @"jar 2 menu";
}

- (void)rainbowButtonUp{
	[[BBLevelReader sharedLevelReader] getMarbleCollection];
	[[BBLevelReader sharedLevelReader] readLevel:@"Rainbow Menu"];
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"MarbleAtlas"];
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"ButtonAtlas"];
	NSString* tempMarbleName;
	NSMutableDictionary * marbleDictionary = [[BBLevelReader sharedLevelReader] kindOfMarble];
	NSInteger index = 1;
	NSInteger horizontal = 0;
	marbleText = [[BBMarbleText alloc] init];
	[marbleText awake];
	marbleText.translation = BBPointMake(110, -55, 0);
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:marbleText];
	[marbleText release];
	
	selectButton = [[BBSelectButton alloc] init];
	selectButton.translation = BBPointMake(170, 110, 0);
	selectButton.scale = BBPointMake(30, 30, 1);
	[selectButton awake];
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:selectButton];
	[selectButton release];
	
	for (id key in [marbleDictionary allKeys]) {
		NSDictionary * record = [marbleDictionary objectForKey:key];
		if ([[record valueForKey:@"type"] isEqualToString:@"rainbow"]) {
			if (index%5==0) {
				horizontal++;
				index = 1;
			}
			if (marbleText.name == nil) {
				marbleText.name = key;
				marbleText.origin = [record valueForKey:@"origin"];
				marbleText.description = [record valueForKey:@"description"];
				tempMarbleName = key;
			}
			if ([[[BBSceneController sharedSceneController].player marbleCollection] containsObject:key]) {
				//if contain zodiac marble in plaer marble collection
				BBMarbleButton * marble = [[BBMarbleButton alloc] init];
				marble.scale = BBPointMake(35, 35, 1);
				marble.translation = BBPointMake(-205+index*45, 70-45*horizontal, 1);
				marble.marbleName = key;
				marble.origin = [record valueForKey:@"origin"];
				marble.description = [record valueForKey:@"description"];
				[marble awake];
				[self addObjectToInterface:marble];
				[marble release];
			}
			else {
				//not contain will gray out or didnt appear
				BBTexturedImage * marble = [[BBTexturedImage alloc] initWithImageName:@"marble lock"];
				marble.scale = BBPointMake(35, 35, 1);
				marble.translation = BBPointMake(-205+index*45, 70-45*horizontal, 1);
				[marble awake];
				[self addObjectToInterface:marble];
				[marble release];
			}
			index++;
		}
	}
	
	jarImage = [[BBTexturedImage alloc] init];
	[jarImage awake];
	jarImage.imageName = tempMarbleName;
	jarImage.translation = BBPointMake(57, 55, 0);
	jarImage.scale = BBPointMake(40, 40, 1);
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:jarImage];
	
	levelName = @"jar 2 menu";
}
- (void)rainbowButtonDown{
}

- (void)natureButtonUp{
	[[BBLevelReader sharedLevelReader] getMarbleCollection];
	[[BBLevelReader sharedLevelReader] readLevel:@"Nature Menu"];
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"MarbleAtlas"];
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"ButtonAtlas"];
	NSString* tempMarbleName;
	NSMutableDictionary * marbleDictionary = [[BBLevelReader sharedLevelReader] kindOfMarble];
	NSInteger index = 1;
	NSInteger horizontal = 0;
	marbleText = [[BBMarbleText alloc] init];
	[marbleText awake];
	marbleText.translation = BBPointMake(110, -55, 0);
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:marbleText];
	[marbleText release];
	
	selectButton = [[BBSelectButton alloc] init];
	selectButton.translation = BBPointMake(170, 110, 0);
	selectButton.scale = BBPointMake(30, 30, 1);
	[selectButton awake];
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:selectButton];
	[selectButton release];
	
	for (id key in [marbleDictionary allKeys]) {
		NSDictionary * record = [marbleDictionary objectForKey:key];
		if ([[record valueForKey:@"type"] isEqualToString:@"nature"]) {
			if (index%5==0) {
				horizontal++;
				index = 1;
			}
			if (marbleText.name == nil) {
				marbleText.name = key;
				marbleText.origin = [record valueForKey:@"origin"];
				marbleText.description = [record valueForKey:@"description"];
				tempMarbleName = key;
			}
			if ([[[BBSceneController sharedSceneController].player marbleCollection] containsObject:key]) {
				//if contain zodiac marble in plaer marble collection
				BBMarbleButton * marble = [[BBMarbleButton alloc] init];
				marble.scale = BBPointMake(35, 35, 1);
				marble.translation = BBPointMake(-205+index*45, 70-45*horizontal, 1);
				marble.marbleName = key;
				marble.origin = [record valueForKey:@"origin"];
				marble.description = [record valueForKey:@"description"];
				[self addObjectToInterface:marble];
				[marble release];
			}
			else {
				//not contain will gray out or didnt appear
				BBTexturedImage * marble = [[BBTexturedImage alloc] initWithImageName:@"marble lock"];
				marble.scale = BBPointMake(35, 35, 1);
				marble.translation = BBPointMake(-205+index*45, 70-45*horizontal, 1);
				[marble awake];
				[self addObjectToInterface:marble];
				[marble release];
			}
			index++;
		}
	}
	
	jarImage = [[BBTexturedImage alloc] init];
	[jarImage awake];
	jarImage.imageName = tempMarbleName;
	jarImage.translation = BBPointMake(57, 55, 0);
	jarImage.scale = BBPointMake(40, 40, 1);
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:jarImage];
	
	levelName = @"jar 2 menu";
}
- (void)natureButtonDown{
}

- (void)backButtonUp {
	if ([levelName isEqualToString:@"jar 2 menu"]) {
		[[BBLevelReader sharedLevelReader] readLevel:@"Jar Menu"];
		levelName = @"jar menu";
	}
	else if ([levelName isEqualToString:@"jar menu"] || [levelName isEqualToString:@"vs menu"]) {
		[[BBLevelReader sharedLevelReader] readLevel:@"Main Menu"];
		levelName = @"main menu";
	}
}
- (void)backButtonDown {
}

- (void)vsButtonUp {
	[[BBLevelReader sharedLevelReader] readLevel:@"Level Selection Versus"];
	NSInteger levelCount = [[[[BBSceneController sharedSceneController] player] levelCollection] count];
	NSInteger row = 110;
	NSInteger line = 120;
	NSInteger horizontal = 0;
	for (int index = 1; index <= 17; index++) {
		NSInteger vertical = index - 1;
		vertical=vertical%3;
		if (vertical == 0) {
			horizontal+=1;
		}
		if (index <= levelCount) {
			BBTexturedButton *button = [[BBTexturedButton alloc] initWithUpKey:[NSString stringWithFormat:@"level%d %@",index,@"button up"] downKey:[NSString stringWithFormat:@"level%d %@",index,@"button down"]];
			button.scale = BBPointMake(104,70,1);
			button.translation = BBPointMake(-163+line*vertical,190-row*horizontal,0);
			button.enabled = YES;
			button.target = [BBSceneController sharedSceneController].inputController;
			NSString * tempString = [NSString stringWithFormat:@"level%dButtonUp",index];
			button.buttonUpAction = NSSelectorFromString(tempString);
			tempString = [NSString stringWithFormat:@"level%dButtonDown",index];
			button.buttonDownAction = NSSelectorFromString(tempString);
			[[BBSceneController sharedSceneController].inputController addObjectToInterface:button];
			[button release];
		}
		else {
			//level havent reach image
		}
	}
	levelName = @"vs menu";
	isVSGame = YES;
}
- (void)vsButtonDown {
}

- (void)playButtonUp {
	[[BBLevelReader sharedLevelReader] readLevel:@"Level Selection"];
	NSInteger levelCount = [[[[BBSceneController sharedSceneController] player] levelCollection] count];
	NSInteger row = 90;
	NSInteger line = 93;
	NSInteger horizontal = 0;
	for (int index = 1; index <= 17; index++) {
		NSInteger vertical = index;
		vertical=index%6;
		if (vertical == 0) {
			horizontal+=1;
		}
		if (index <= levelCount) {
			BBTexturedButton *button = [[BBTexturedButton alloc] initWithUpKey:[NSString stringWithFormat:@"level%d %@",index,@"button up"] downKey:[NSString stringWithFormat:@"level%d %@",index,@"button down"]];
			button.scale = BBPointMake(50,50,1);
			button.translation = BBPointMake(-283+line*vertical,80-row*horizontal,0);
			button.enabled = YES;
			button.target = [BBSceneController sharedSceneController].inputController;
			NSString * tempString = [NSString stringWithFormat:@"level%dButtonUp",index];
			button.buttonUpAction = NSSelectorFromString(tempString);
			tempString = [NSString stringWithFormat:@"level%dButtonDown",index];
			button.buttonDownAction = NSSelectorFromString(tempString);
			[[BBSceneController sharedSceneController].inputController addObjectToInterface:button];
			[button release];
		}
		else {
			BBTexturedButton *button = [[BBTexturedButton alloc] initWithUpKey:@"lock button up" downKey:@"lock button up"];
			button.scale = BBPointMake(50,50,1);
			button.translation = BBPointMake(-283+line*vertical,80-row*horizontal,0);
			button.enabled = NO;
			button.target = [BBSceneController sharedSceneController].inputController;
			[[BBSceneController sharedSceneController].inputController addObjectToInterface:button];
			[button release];
		}
	}
	isVSGame = NO;
}

- (void)resumeButtonUp {
	for (BBSceneObject * object in [[BBSceneController sharedSceneController] sceneObjects]) {
		if ([object isMemberOfClass:[BBMarble class]]) {
			[(BBMarble*)object setSpeed:tempSpeed];
			[(BBMarble*)object setIsMarbleMoving:YES];
			[(BBMarble*)object setIsPause:NO];
			break;
		}
	}
	[resumeBoard removeScoreBoardComponent];
	//set the pause button to enable for click
	for (BBSceneObject * object in interfaceObjects) {
		if ([object isMemberOfClass:[BBTexturedButton class]] &&
			[[(BBTexturedButton*)object objectName] isEqualToString:@"pause"]) {
			[(BBTexturedButton*)object setEnabled:YES];
			break;
		}
	}
}

- (void)resumeButtonDown {
}

- (void)mainMenuButtonUp {
	[[BBLevelReader sharedLevelReader] readLevel:@"Main Menu"];
}

- (void)mainMenuButtonDown {
}

- (void)pauseButtonUp {
	//pause button action
	for (BBSceneObject * object in [[BBSceneController sharedSceneController] sceneObjects]) {
		if ([object isMemberOfClass:[BBMarble class]]) {
			tempSpeed = [(BBMarble*)object speed];
			[(BBMarble*)object setSpeed:BBPointMake(0, 0, 0)];
			[(BBMarble*)object setIsPause:YES];
			break;
		}
	}
	//set the pause button to disable for click
	for (BBSceneObject * object in interfaceObjects) {
		if ([object isMemberOfClass:[BBTexturedButton class]] &&
			[[(BBTexturedButton*)object objectName] isEqualToString:@"pause"]) {
			[(BBTexturedButton*)object setEnabled:NO];
			break;
		}
	}
	
	[resumeBoard awake];
}

- (void)helpButtonUp {
	[[BBLevelReader sharedLevelReader] readLevel:@"Tutorial1 Menu"];
}

- (void)helpButtonDown {
}

- (void)pauseButtonDown {
}

- (void)playButtonDown {
}

- (void)replayButtonUp {
	//change scene
	/*for (BBSceneObject * object in [[BBSceneController sharedSceneController] sceneObjects]) {
		if ([object isMemberOfClass:[BBMarble class]]) {
			[(BBMarble*)object replayGame];
			break;
		}
	}*/
	[[BBLevelReader sharedLevelReader] readLevel:[NSString stringWithFormat:@"Level %d",level]];
	[[BBSceneController sharedSceneController] resetAllObjectPosition];
	[[BBSceneController sharedSceneController] resetCollisionController];
}
	
- (void)replayButtonDown {
}

- (void)nextLevelButtonUp {
	level = level + 1;
	[[BBLevelReader sharedLevelReader] readLevel:[NSString stringWithFormat:@"Level %d",level]];
	[[BBSceneController sharedSceneController] resetAllObjectPosition];
	[[BBSceneController sharedSceneController] resetCollisionController];
}

- (void)nextLevelButtonDown {
}

- (void)quitButtonUp {
	[[BBLevelReader sharedLevelReader] readLevel:@"Level Selection"];
	NSInteger levelCount = [[[[BBSceneController sharedSceneController] player] levelCollection] count];
	NSInteger row = 90;
	NSInteger line = 93;
	NSInteger horizontal = 0;
	for (int index = 1; index <= 17; index++) {
		NSInteger vertical = index;
		vertical=index%6;
		if (vertical == 0) {
			horizontal+=1;
		}
		if (index <= levelCount) {
			BBTexturedButton *button = [[BBTexturedButton alloc] initWithUpKey:[NSString stringWithFormat:@"level%d %@",index,@"button up"] downKey:[NSString stringWithFormat:@"level%d %@",index,@"button down"]];
			button.scale = BBPointMake(50,50,1);
			button.translation = BBPointMake(-283+line*vertical,80-row*horizontal,0);
			button.enabled = YES;
			button.target = [BBSceneController sharedSceneController].inputController;
			NSString * tempString = [NSString stringWithFormat:@"level%dButtonUp",index];
			button.buttonUpAction = NSSelectorFromString(tempString);
			tempString = [NSString stringWithFormat:@"level%dButtonDown",index];
			button.buttonDownAction = NSSelectorFromString(tempString);
			[[BBSceneController sharedSceneController].inputController addObjectToInterface:button];
			[button release];
		}
		else {
			BBTexturedButton *button = [[BBTexturedButton alloc] initWithUpKey:@"lock button up" downKey:@"lock button up"];
			button.scale = BBPointMake(50,50,1);
			button.translation = BBPointMake(-283+line*vertical,80-row*horizontal,0);
			button.enabled = NO;
			button.target = [BBSceneController sharedSceneController].inputController;
			[[BBSceneController sharedSceneController].inputController addObjectToInterface:button];
			[button release];
		}
	}
	
}

- (void)quitButtonDown {
}

- (void)vsReplayButtonUp {
	isVSGame = YES;
	[[BBLevelReader sharedLevelReader] readLevel:[NSString stringWithFormat:@"Level %d",level]];
	[[BBSceneController sharedSceneController] resetAllObjectPosition];
	[[BBSceneController sharedSceneController] resetCollisionController];
}

- (void)vsReplayButtonDown {
}

- (void)jarButtonUp {
	[[BBLevelReader sharedLevelReader] readLevel:@"Jar Menu"];
	levelName = @"jar menu";
}
- (void)jarButtonDown {
}

- (void)firstButtonUp {
	[[BBLevelReader sharedLevelReader] readLevel:@"Tutorial1 Menu"];
	
}

- (void)firstButtonDown {
}

- (void)secondButtonUp {
	[[BBLevelReader sharedLevelReader] readLevel:@"Tutorial2 Menu"];
}

- (void)secondButtonDown {
}

- (void)thirdButtonUp {
	[[BBLevelReader sharedLevelReader] readLevel:@"Tutorial3 Menu"];
}

- (void)thirdButtonDown {
}

- (void)endButtonUp {
	[[BBLevelReader sharedLevelReader] readLevel:@"Main Menu"];
}

- (void)endButtonDown {
}

#pragma mark editor button

- (void)triggerEditor {
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"MarbleAtlas"];
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"Level1Atlas"];
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"ButtonAtlas"];
	
	BBTexturedButton * addButton = [[BBTexturedButton alloc] initWithUpKey:@"pause button up" downKey:@"pause button down"];
	addButton.translation = BBPointMake(-200, 140, 0);
	addButton.scale = BBPointMake(40, 40, 1);
	[addButton awake];
	addButton.active = YES;
	addButton.target = self;
	addButton.buttonUpAction = @selector(addObjectButtonUp);
	addButton.buttonDownAction = @selector(addObjectButtonDown);
	addButton.enabled = YES;
	[self addObjectToInterface:addButton];
	[addButton release];
	
	addButton = [[BBTexturedButton alloc] initWithUpKey:@"pause button up" downKey:@"pause button down"];
	addButton.translation = BBPointMake(-150, 140, 0);
	addButton.scale = BBPointMake(40, 40, 1);
	[addButton awake];
	addButton.active = YES;
	addButton.target = self;
	addButton.buttonUpAction = @selector(deleteObjectButtonUp);
	addButton.buttonDownAction = @selector(deleteObjectButtonDown);
	addButton.enabled = YES;
	[self addObjectToInterface:addButton];
	[addButton release];
	
	addButton = [[BBTexturedButton alloc] initWithUpKey:@"pause button up" downKey:@"pause button down"];
	addButton.translation = BBPointMake(200, 140, 0);
	addButton.scale = BBPointMake(40, 40, 1);
	[addButton awake];
	addButton.active = YES;
	addButton.target = self;
	addButton.buttonUpAction = @selector(commitButtonUp);
	addButton.buttonDownAction = @selector(commitButtonDown);
	addButton.enabled = YES;
	[self addObjectToInterface:addButton];
	[addButton release];
	
	BBEditorObject * background = [[BBEditorObject alloc] initWithImageName:@"level 1 screen"];
	background.translation = BBPointMake(640, 480, 0);
	background.scale = BBPointMake(1920, 1280, 1);
	background.startLocation = background.translation;
	background.objectType = @"background";
	background.objectName = @"Level 1";
	[[BBSceneController sharedSceneController] addObjectToScene:background];
	[background release];
}

- (void)ufoButtonUp {
	//remove editor board all component
	[editorBoard removeScoreBoardComponent];
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"anUfo"];
	BBEditorObject * ufoImage = [[BBEditorObject alloc] initWithImageName:@"ufo 1"];
	ufoImage.translation = BBPointMake(0, 0, 0);
	ufoImage.scale = BBPointMake(70, 50, 1);
	ufoImage.objectType = @"ufo";
	ufoImage.startLocation = ufoImage.translation;
	[[BBSceneController sharedSceneController] addObjectToScene:ufoImage];
	[ufoImage release];
}

- (void)ufoButtonDown {
}

- (void)starButtonUp {
	//remove editor board all component
	[editorBoard removeScoreBoardComponent];
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"anStar"];
	BBEditorObject * starImage = [[BBEditorObject alloc] initWithImageName:@"star 3"];
	starImage.translation = BBPointMake(0, 0, 0);
	starImage.scale = BBPointMake(50, 50, 1);
	starImage.objectType = @"star";
	starImage.startLocation = starImage.translation;
	[[BBSceneController sharedSceneController] addObjectToScene:starImage];
	[starImage release];
}

- (void)starButtonDown {
}

- (void)wallButtonUp {
	//remove editor board all component
	[editorBoard removeScoreBoardComponent];
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"WallAtlas"];
	BBEditorObject * wallImage = [[BBEditorObject alloc] initWithImageName:@"wall"];
	wallImage.translation = BBPointMake(0, 0, 0);
	wallImage.scale = BBPointMake(80, 30, 1);
	wallImage.objectType = @"wall";
	wallImage.startLocation = wallImage.translation;
	[[BBSceneController sharedSceneController] addObjectToScene:wallImage];
	[wallImage release];
}

- (void)wallButtonDown {
}

- (void)blackholeInButtonUp {
	//remove editor board all component
	[editorBoard removeScoreBoardComponent];
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"anBlackhole"];
	BBEditorObject * blackholeImage = [[BBEditorObject alloc] initWithImageName:@"blackhole 3"];
	blackholeImage.translation = BBPointMake(0, 0, 0);
	blackholeImage.scale = BBPointMake(50, 50, 1);
	blackholeImage.objectType = @"blackhole";
	blackholeImage.extraType = @"in";
	blackholeImage.startLocation = blackholeImage.translation;
	[[BBSceneController sharedSceneController] addObjectToScene:blackholeImage];
	[blackholeImage release];
}

- (void)blackholeInButtonDown {
}

- (void)blackholeOutButtonUp {
	//remove editor board all component
	[editorBoard removeScoreBoardComponent];
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"anBlackhole"];	
	BBEditorObject * blackholeImage = [[BBEditorObject alloc] initWithImageName:@"blackhole 5"];
	blackholeImage.translation = BBPointMake(0, 0, 0);
	blackholeImage.scale = BBPointMake(50, 50, 1);
	blackholeImage.objectType = @"blackhole";
	blackholeImage.extraType = @"out";
	blackholeImage.startLocation = blackholeImage.translation;
	[[BBSceneController sharedSceneController] addObjectToScene:blackholeImage];
	[blackholeImage release];
}

- (void)blackholeOutButtonDown {
}

- (void)addObjectButtonUp {
	[editorBoard awake];
}

- (void)addObjectButtonDown {
}

- (void)deleteObjectButtonUp {
	if (editorObject != nil) {
		[[BBSceneController sharedSceneController] removeObjectFromScene:editorObject];
	}
}

- (void)deleteObjectButtonDown {
}

- (NSString*)dataFilePath {
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [path objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"custom data"];
}

- (void)commitButtonUp {
	//save level to dictionary and write to file
	NSMutableDictionary *root = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *levelDict = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *levelObjectDict = [[NSMutableDictionary alloc] init];
	
	for (BBSceneObject *object in [[BBSceneController sharedSceneController] sceneObjects]) {
		if ([object isMemberOfClass:[BBEditorObject class]]) {
			if ([[(BBEditorObject*)object objectType] isEqualToString:@"background"]) {
				[levelObjectDict setObject:[NSString stringWithFormat:@"%@Atlas",[[(BBEditorObject*)object objectName] stringByReplacingOccurrencesOfString:@" " withString:@""]] forKey:@"name"];
				[levelObjectDict setObject:@"texture atlas" forKey:@"type"];
				[levelDict setObject:levelObjectDict forKey:[NSString stringWithFormat:@"01 %@ Atlas",[(BBEditorObject*)object objectName]]];
			}
			break;
		}
	}
	[levelObjectDict release];
	
	levelObjectDict = [[NSMutableDictionary alloc] init];
	[levelObjectDict setObject:@"MarbleAtlas" forKey:@"name"];
	[levelObjectDict setObject:@"texture atlas" forKey:@"type"];
	[levelDict setObject:levelObjectDict forKey:@"02 Marble Atlas"];
	[levelObjectDict release];
	
	levelObjectDict = [[NSMutableDictionary alloc] init];
	[levelObjectDict setObject:@"ButtonAtlas" forKey:@"name"];
	[levelObjectDict setObject:@"texture atlas" forKey:@"type"];
	[levelDict setObject:levelObjectDict forKey:@"03 Button Atlas"];
	[levelObjectDict release];
	
	levelObjectDict = [[NSMutableDictionary alloc] init];
	for (BBSceneObject *object in [[BBSceneController sharedSceneController] sceneObjects]) {
		if ([object isMemberOfClass:[BBEditorObject class]]) {
			if ([[(BBEditorObject*)object objectType] isEqualToString:@"background"]) {
				[levelObjectDict setObject:[NSString stringWithFormat:@"%@ screen",[(BBEditorObject*)object objectName]] forKey:@"name"];
				[levelObjectDict setObject:@"background" forKey:@"type"];
				[levelObjectDict setObject:@"dynamic" forKey:@"background type"];
				NSNumber* tempNumber = [NSNumber numberWithInt:[(BBEditorObject*)object scale].x];
				[levelObjectDict setObject:tempNumber forKey:@"xScale"];
				tempNumber = [NSNumber numberWithInt:[(BBEditorObject*)object scale].y];
				[levelObjectDict setObject:tempNumber forKey:@"yScale"];
				tempNumber = [NSNumber numberWithInt:[(BBEditorObject*)object scale].z];
				[levelObjectDict setObject:tempNumber forKey:@"zScale"];
				tempNumber = [NSNumber numberWithInt:[(BBEditorObject*)object translation].x];
				[levelObjectDict setObject:tempNumber forKey:@"xTranslation"];
				tempNumber = [NSNumber numberWithInt:[(BBEditorObject*)object translation].y];
				[levelObjectDict setObject:tempNumber forKey:@"yTranslation"];
				tempNumber = [NSNumber numberWithInt:[(BBEditorObject*)object translation].z];
				[levelObjectDict setObject:tempNumber forKey:@"zTranslation"];
				[levelDict setObject:levelObjectDict forKey:[NSString stringWithFormat:@"04 %@ Background",[(BBEditorObject*)object objectName]]];
			}
			break;
		}
	}
	[levelObjectDict release];
	
	//hero marble
	levelObjectDict = [[NSMutableDictionary alloc] init];
	[levelObjectDict setObject:@"marble" forKey:@"type"];
	NSNumber* tempNumber = [NSNumber numberWithInt:30];
	[levelObjectDict setObject:tempNumber forKey:@"xScale"];
	tempNumber = [NSNumber numberWithInt:30];
	[levelObjectDict setObject:tempNumber forKey:@"yScale"];
	tempNumber = [NSNumber numberWithInt:1];
	[levelObjectDict setObject:tempNumber forKey:@"zScale"];
	tempNumber = [NSNumber numberWithInt:-120];
	[levelObjectDict setObject:tempNumber forKey:@"xTranslation"];
	tempNumber = [NSNumber numberWithInt:-30];
	[levelObjectDict setObject:tempNumber forKey:@"yTranslation"];
	tempNumber = [NSNumber numberWithInt:0];
	[levelObjectDict setObject:tempNumber forKey:@"zTranslation"];
	[levelDict setObject:levelObjectDict forKey:@"05 Hero Marble"];
	[levelObjectDict release];
	
	//static marble
	for (int index = 1; index <6 ; index++) {
		levelObjectDict = [[NSMutableDictionary alloc] init];
		[levelObjectDict setObject:@"static marble" forKey:@"type"];
		NSNumber* tempNumber = [NSNumber numberWithInt:30];
		[levelObjectDict setObject:tempNumber forKey:@"xScale"];
		tempNumber = [NSNumber numberWithInt:30];
		[levelObjectDict setObject:tempNumber forKey:@"yScale"];
		tempNumber = [NSNumber numberWithInt:1];
		[levelObjectDict setObject:tempNumber forKey:@"zScale"];
		tempNumber = [NSNumber numberWithInt:(668+index*32)];
		[levelObjectDict setObject:tempNumber forKey:@"xTranslation"];
		tempNumber = [NSNumber numberWithInt:-140];
		[levelObjectDict setObject:tempNumber forKey:@"yTranslation"];
		tempNumber = [NSNumber numberWithInt:0];
		[levelObjectDict setObject:tempNumber forKey:@"zTranslation"];
		tempNumber = [NSNumber numberWithInt:index];
		[levelObjectDict setObject:tempNumber forKey:@"position"];

		[levelDict setObject:levelObjectDict forKey:[NSString stringWithFormat:@"0%d Static Marble %d",index+5,index]];
		[levelObjectDict release];
	}
	
	int index = 11;
	for (BBSceneObject *object in [[BBSceneController sharedSceneController] sceneObjects]) {
		if ([object isMemberOfClass:[BBEditorObject class]]) {
			if ([[(BBEditorObject*)object objectType] isEqualToString:@"background"]) continue;
			levelObjectDict = [[NSMutableDictionary alloc] init];
			if ([[(BBEditorObject*)object objectType] isEqualToString:@"wormhole"]) {
				if ([[(BBEditorObject*)object extraType] isEqualToString:@"in"]) {
					[levelObjectDict setObject:@"in" forKey:@"wormhole type"];
				}
				else {
					[levelObjectDict setObject:@"out" forKey:@"wormhole type"];
				}

			}
			[levelObjectDict setObject:[(BBEditorObject*)object objectType] forKey:@"type"];
			NSNumber* tempNumber = [NSNumber numberWithInt:[(BBEditorObject*)object scale].x];
			[levelObjectDict setObject:tempNumber forKey:@"xScale"];
			tempNumber = [NSNumber numberWithInt:[(BBEditorObject*)object scale].y];
			[levelObjectDict setObject:tempNumber forKey:@"yScale"];
			tempNumber = [NSNumber numberWithInt:[(BBEditorObject*)object scale].z];
			[levelObjectDict setObject:tempNumber forKey:@"zScale"];
			tempNumber = [NSNumber numberWithInt:[(BBEditorObject*)object translation].x];
			[levelObjectDict setObject:tempNumber forKey:@"xTranslation"];
			tempNumber = [NSNumber numberWithInt:[(BBEditorObject*)object translation].y];
			[levelObjectDict setObject:tempNumber forKey:@"yTranslation"];
			tempNumber = [NSNumber numberWithInt:[(BBEditorObject*)object translation].z];
			[levelDict setObject:levelObjectDict forKey:[NSString stringWithFormat:@"%d %@",index,[(BBEditorObject*)object objectType]]];
			[levelObjectDict release];
			index++;
		}
	}
	
	[root setObject:levelDict forKey:@"Custom Level"];
	
	//write to file path
	[root writeToFile:[self dataFilePath] atomically:YES];
	//[levelObjectDict release];
	[levelDict release];
	[root release];
}

- (void)commitButtonDown {
}

- (void)updateInterface
{
	[interfaceObjects makeObjectsPerformSelector:@selector(update)];
}

- (void)renderInterface
{
	// simply call 'render' on all our scene objects
	[interfaceObjects makeObjectsPerformSelector:@selector(render)];
}

- (void)addObjectToInterface:(BBSceneObject*)object {
	object.active = YES;
	[object awake];
	[interfaceObjects addObject:object];
}

- (void)removeObjectFromInterface:(BBSceneObject *)object {
	object.active = NO;
	[interfaceObjects removeObject:object];
}

- (void)removeAllInterfaceObject {
	interfaceObjects = [[NSMutableArray alloc] init];
}

- (void)dealloc {
    [super dealloc];
	[touchEvents release];
	[marbleText release];
	[interfaceObjects release];
	[levelName release];
	[keyName release];
	[resumeBoard release];
	[editorObject release];
	[resumeBoard release];
	[editorBoard release];
	[jarImage release];
}


@end
