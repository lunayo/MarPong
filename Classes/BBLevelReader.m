//
//  BBLevelReader.m
//  MarPong
//
//  Created by Lunayo on 10/25/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "BBLevelReader.h"
#import "BBMarble.h"
#import "BBWall.h"
#import "BBButton.h"
#import "BBSceneController.h"
#import "BBTexturedButton.h"
#import "BBMaterialController.h"
#import	"BBBackground.h"
#import "BBWormhole.h"
#import "BBArrow.h"
#import "BBUfo.h"
#import "BBStar.h"
#import "BBMarbleBooster.h"

@implementation BBLevelReader
@synthesize kindOfMarble, marbleName;

+(BBLevelReader*)sharedLevelReader
{
	static BBLevelReader *sharedLevelReader;
	@synchronized(self)
	{
		if (!sharedLevelReader)
			sharedLevelReader = [[BBLevelReader alloc] init];
	}
	return sharedLevelReader;
}

- (void)removeAllSceneObjects {
	//remove all object in screen
	[[BBSceneController sharedSceneController] removeAllObjectOnScene];
	//remove all object in interface
	[[BBSceneController sharedSceneController].inputController removeAllInterfaceObject];
	//remove all texture
	[[BBMaterialController sharedMaterialController] setQuadLibrary:nil];
	[[BBMaterialController sharedMaterialController] setMaterialLibrary:nil];
}

- (void)getMarbleCollection {
	if (kindOfMarble == nil) kindOfMarble = [[NSMutableDictionary alloc] init];
	NSArray *root = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MarbleAtlas" ofType:@"plist"]];
	for (NSDictionary *record in root) {
		NSMutableDictionary * tempDict = [[NSMutableDictionary alloc] init];
		[tempDict setObject:[record objectForKey:@"mass"] forKey:@"mass"];
		[tempDict setObject:[record objectForKey:@"speed"] forKey:@"speed"];
		[tempDict setObject:[record objectForKey:@"type"] forKey:@"type"];
		[tempDict setObject:[record objectForKey:@"origin"] forKey:@"origin"];
		[tempDict setObject:[record objectForKey:@"description"] forKey:@"description"];
		[kindOfMarble setObject:tempDict forKey:[record objectForKey:@"name"]];
		[tempDict release];
	}
}

- (void)readLevel:(NSString*)string {
	//remove scene object in scene
	[self removeAllSceneObjects];
	NSString *levelName = string;
	NSDictionary *level = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Object Data" ofType:@"plist"]];
	NSDictionary *levelData = [level objectForKey:levelName];
	NSArray* allKeys = [levelData allKeys];
	NSArray* sortedKeys = [allKeys sortedArrayUsingSelector:@selector(psuedoNumericCompare:)];
	
	for (id key in sortedKeys) {
		NSDictionary * record = [levelData objectForKey:key];
		//texture
		if ([[record valueForKey:@"type"] isEqualToString:@"texture atlas"]) {
			[[BBMaterialController sharedMaterialController] loadAtlasData:[record valueForKey:@"name"]];
			//if is marble atlas, load all marble to array
			if ([[record valueForKey:@"name"] isEqualToString:@"MarbleAtlas"])
				[self getMarbleCollection];
		}
		//object marble
		else if ([[record valueForKey:@"type"] isEqualToString:@"marble"]) {
			//default marble
			if (marbleName == nil) marbleName = @"red";
			//NSDictionary *tempDict = [kindOfMarble objectForKey:marbleName];
			BBMarble * marble = [[BBMarble alloc] init];
			marble.scale = BBPointMake([[record valueForKey:@"xScale"] floatValue],[[record valueForKey:@"yScale"] floatValue],[[record valueForKey:@"zScale"] floatValue]);
			marble.translation = BBPointMake([[record valueForKey:@"xTranslation"] floatValue], [[record valueForKey:@"yTranslation"] floatValue], [[record valueForKey:@"zTranslation"] floatValue]);
			marble.marbleName = marbleName;
			//marble.mass = [[tempDict objectForKey:@"mass"] floatValue];
			marble.startLocation = marble.translation;
			[[BBSceneController sharedSceneController] addObjectToScene:marble];
			[marble release];
		}
		//static Marble
		else if ([[record valueForKey:@"type"] isEqualToString:@"static marble"]) {
			//random
			NSArray *tempArray = [kindOfMarble allKeys];
			NSString *keyName = [tempArray objectAtIndex:RANDOM_INT(0,[tempArray count]-1)];
			BBStaticMarble * staticMarble = [[BBStaticMarble alloc] init];
			staticMarble.scale = BBPointMake([[record valueForKey:@"xScale"] floatValue],[[record valueForKey:@"yScale"] floatValue],[[record valueForKey:@"zScale"] floatValue]);
			staticMarble.translation = BBPointMake([[record valueForKey:@"xTranslation"] floatValue], [[record valueForKey:@"yTranslation"] floatValue], [[record valueForKey:@"zTranslation"] floatValue]);
			staticMarble.startLocation = staticMarble.translation;
			staticMarble.marbleName = keyName;
			staticMarble.marblePosition = [[record valueForKey:@"position"] floatValue];
			[[BBSceneController sharedSceneController] addObjectToScene:staticMarble];
			[staticMarble release];
		}
		//wall
		else if ([[record valueForKey:@"type"] isEqualToString:@"wall"]) {
			BBWall * wall = [[BBWall alloc] init];
			wall.scale = BBPointMake([[record valueForKey:@"xScale"] floatValue],[[record valueForKey:@"yScale"] floatValue],[[record valueForKey:@"zScale"] floatValue]);
			wall.translation = BBPointMake([[record valueForKey:@"xTranslation"] floatValue], [[record valueForKey:@"yTranslation"] floatValue], [[record valueForKey:@"zTranslation"] floatValue]);
			wall.startLocation = wall.translation;
			[[BBSceneController sharedSceneController] addObjectToScene:wall];
			[wall release];
		}
		//score
		else if ([[record valueForKey:@"type"] isEqualToString:@"score"]) {
			//reset score
			[[[BBScoreController sharedScoreController] scoreObject] setScore:0];
			[[[BBSceneController sharedSceneController] inputController] addObjectToInterface:[[BBScoreController sharedScoreController] scoreObject]];
		}
		//background
		else if ([[record valueForKey:@"type"] isEqualToString:@"background"]) {
			BBBackground *background = [[BBBackground alloc] initWithBackgroundImage:[record valueForKey:@"name"]];
			background.scale = BBPointMake([[record valueForKey:@"xScale"] floatValue],[[record valueForKey:@"yScale"] floatValue],[[record valueForKey:@"zScale"] floatValue]);
			background.translation = BBPointMake([[record valueForKey:@"xTranslation"] floatValue], [[record valueForKey:@"yTranslation"] floatValue], [[record valueForKey:@"zTranslation"] floatValue]);
			background.startLocation = background.translation;
			//static background
			if ([[record valueForKey:@"background type"] isEqualToString:@"static"])
				[[BBSceneController sharedSceneController].inputController addObjectToInterface:background];
			//dynamic background
			else 
				[[BBSceneController sharedSceneController] addObjectToScene:background];
			[background release];
		}
		//button
		else if ([[record valueForKey:@"type"] isEqualToString:@"button"]) {
			BBTexturedButton *button = [[BBTexturedButton alloc] initWithUpKey:[NSString stringWithFormat:@"%@ %@",[record valueForKey:@"name"],@"button up"] downKey:[NSString stringWithFormat:@"%@ %@",[record valueForKey:@"name"],@"button down"]];
			button.objectName = [record valueForKey:@"name"];
			button.scale = BBPointMake([[record valueForKey:@"xScale"] floatValue],[[record valueForKey:@"yScale"] floatValue],[[record valueForKey:@"zScale"] floatValue]);
			button.translation = BBPointMake([[record valueForKey:@"xTranslation"] floatValue], [[record valueForKey:@"yTranslation"] floatValue], [[record valueForKey:@"zTranslation"] floatValue]);
			button.enabled = YES;
			if ([[record valueForKey:@"button type"] isEqualToString:@"static"])
				button.enabled = NO;
			button.target = [BBSceneController sharedSceneController].inputController;
			NSString * tempString = [NSString stringWithFormat:@"%@ButtonUp",[record valueForKey:@"name"]];
			button.buttonUpAction = NSSelectorFromString(tempString);
			tempString = [NSString stringWithFormat:@"%@ButtonDown",[record valueForKey:@"name"]];
			button.buttonDownAction = NSSelectorFromString(tempString);
			[[BBSceneController sharedSceneController].inputController addObjectToInterface:button];
			[button release];
		}
		else if ([[record valueForKey:@"type"] isEqualToString:@"wormhole"]) {
			BBWormhole * wormhole = [[BBWormhole alloc] init];
			wormhole.scale = BBPointMake([[record valueForKey:@"xScale"] floatValue],[[record valueForKey:@"yScale"] floatValue],[[record valueForKey:@"zScale"] floatValue]);
			wormhole.translation = BBPointMake([[record valueForKey:@"xTranslation"] floatValue], [[record valueForKey:@"yTranslation"] floatValue], [[record valueForKey:@"zTranslation"] floatValue]);
			wormhole.startLocation = wormhole.translation;
			if ([[record valueForKey:@"wormhole type"] isEqualToString:@"in"]) {
				wormhole.type = @"in";
			}
			else {
				wormhole.type = @"out";
			}
			wormhole.groupName = @"worm1";
			wormhole.isRun = YES;
			[[BBSceneController sharedSceneController] addObjectToScene:wormhole];
			[wormhole release];
		}
		else if ([[record valueForKey:@"type"] isEqualToString:@"arrow"]) {
			BBArrow * arrow = [[BBArrow alloc] init];
			arrow.scale = BBPointMake([[record valueForKey:@"xScale"] floatValue],[[record valueForKey:@"yScale"] floatValue],[[record valueForKey:@"zScale"] floatValue]);
			arrow.translation = BBPointMake([[record valueForKey:@"xTranslation"] floatValue], [[record valueForKey:@"yTranslation"] floatValue], [[record valueForKey:@"zTranslation"] floatValue]);
			if ([[record valueForKey:@"arrow type"] isEqualToString:@"right"]) {
				arrow.type = @"right";
			}
			else if ([[record valueForKey:@"arrow type"] isEqualToString:@"down"]){
				arrow.type = @"down";
			}
			arrow.startLocation = arrow.translation;
			[[BBSceneController sharedSceneController] addObjectToScene:arrow];
			[arrow release];
		}
		else if ([[record valueForKey:@"type"] isEqualToString:@"ufo"]) {
			BBUfo *ufo = [[BBUfo alloc] init];
			ufo.translation = BBPointMake([[record valueForKey:@"xTranslation"] floatValue], [[record valueForKey:@"yTranslation"] floatValue], [[record valueForKey:@"zTranslation"] floatValue]);
			ufo.scale = BBPointMake([[record valueForKey:@"xScale"] floatValue],[[record valueForKey:@"yScale"] floatValue],[[record valueForKey:@"zScale"] floatValue]);
			ufo.startLocation = ufo.translation;
			[[BBSceneController sharedSceneController] addObjectToScene:ufo];
			[ufo release];
		}
		else if ([[record valueForKey:@"type"] isEqualToString:@"star"]) {
			BBStar *star = [[BBStar alloc] init];
			star.translation = BBPointMake([[record valueForKey:@"xTranslation"] floatValue], [[record valueForKey:@"yTranslation"] floatValue], [[record valueForKey:@"zTranslation"] floatValue]);
			star.scale = BBPointMake([[record valueForKey:@"xScale"] floatValue],[[record valueForKey:@"yScale"] floatValue],[[record valueForKey:@"zScale"] floatValue]);
			star.startLocation = star.translation;
			[[BBSceneController sharedSceneController] addObjectToScene:star];
			[star release];
		}
		else if ([[record valueForKey:@"type"] isEqualToString:@"marble booster"]) {
			BBMarbleBooster *booster = [[BBMarbleBooster alloc] init];
			booster.translation = BBPointMake([[record valueForKey:@"xTranslation"] floatValue], [[record valueForKey:@"yTranslation"] floatValue], [[record valueForKey:@"zTranslation"] floatValue]);
			booster.scale = BBPointMake([[record valueForKey:@"xScale"] floatValue],[[record valueForKey:@"yScale"] floatValue],[[record valueForKey:@"zScale"] floatValue]);
			booster.startLocation = booster.translation;
			[[BBSceneController sharedSceneController] addObjectToScene:booster];
			[booster release];
		}
	}
	
}

- (void)dealloc {
	[super dealloc];
	[kindOfMarble release];
}

@end
