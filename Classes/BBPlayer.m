//
//  BBPlayer.m
//  MarPong
//
//  Created by Lunayo on 11/19/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "BBPlayer.h"
#import "BBSceneObject.h"
#import "BBStaticMarble.h"

@implementation BBPlayer
@synthesize name, marbleCollection, levelCollection, pongoPoint, marbleLife, marbleScore, marbleObject;
@synthesize isHighAngle, isFastSwitch, isJustRight;

- (id)init {
	self = [super init];
	if (self != nil) {
		name = @"";
		pongoPoint = 0;
		marbleLife = 3;
		marbleScore = 0;
		isHighAngle = NO;
		isJustRight = NO;
		isFastSwitch = NO;
		marbleCollection = [[NSMutableArray alloc] init];
		levelCollection = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)addMarbleToCollection:(NSString*)marbleName {
	//if marble collection already containt this marble
	if ([marbleCollection containsObject:marbleName]) return;
	[marbleCollection addObject:marbleName];
}

- (void)addLevelToCollection:(NSString*)levelName {
	//if level collection already containt this level
	if ([levelCollection containsObject:levelName]) return;
	[levelCollection addObject:levelName];
}

- (void)dealloc {
	[marbleCollection release];
	[levelCollection release];
	[super dealloc];
}

@end
