//
//  BBScoreBoard.m
//  MarPong
//
//  Created by Lunayo on 1/11/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import "BBScoreBoard.h"
#import "BBMaterialController.h"


@implementation BBScoreBoard
@synthesize isGameOver;

- (id)init {
	self = [super init];
	if (self != nil) {
		//load texture atlas data
		[[BBMaterialController sharedMaterialController] loadAtlasData:@"ScoreBoardAtlas"];
		[[BBMaterialController sharedMaterialController] loadAtlasData:@"VSScoreBoardAtlas"];
		isGameOver = NO;
	}
	return self;
}

- (void)awake {
	
	//set the behind component
	bgImage = [[BBTexturedImage alloc] initWithImageName:@"score screen"];
	bgImage.translation = BBPointMake(0, 0, 0);
	bgImage.scale = BBPointMake(480, 320, 1);
	bgImage.startLocation = bgImage.translation;
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:bgImage];
	//[bgImage release];
	
	pongoPoint = [[BBPongoScore alloc] init];
	pongoPoint.translation = BBPointMake(110, 70, 0);
	[pongoPoint awake];
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:pongoPoint];
	//[pongoPoint release];
	
	//set the pongo bonus text
	pongoBonus = [[BBPongoScore alloc] init];
	pongoBonus.translation = BBPointMake(110, 25, 0);
	[pongoBonus awake];
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:pongoBonus];
	//[pongoBonus release];
	
	//set the button
	replayButton = [[BBTexturedButton alloc] initWithUpKey:@"replay button up" downKey:@"replay button down"];
	replayButton.translation = BBPointMake(75, -115, 0);
	replayButton.scale = BBPointMake(57, 57, 1);
	replayButton.startLocation = replayButton.translation;
	replayButton.enabled = YES;
	replayButton.target = [BBSceneController sharedSceneController].inputController;
	replayButton.buttonUpAction = @selector(replayButtonUp);
	replayButton.buttonDownAction = @selector(replayButtonDown);
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:replayButton];
	//[replayButton release];
	
	//if game is over
	if (isGameOver) {
		mainMenuButton = [[BBTexturedButton alloc] initWithUpKey:@"quit button up" downKey:@"quit button down"];
		mainMenuButton.translation = BBPointMake(145, -115, 0);
		mainMenuButton.scale = BBPointMake(57,57,1);
		mainMenuButton.startLocation = mainMenuButton.translation;
		mainMenuButton.enabled = YES;
		mainMenuButton.target = [BBSceneController sharedSceneController].inputController;
		mainMenuButton.buttonUpAction = @selector(mainMenuButtonUp);
		mainMenuButton.buttonDownAction = @selector(mainMenuButtonDown);
		[[BBSceneController sharedSceneController].inputController addObjectToInterface:mainMenuButton];
		//[mainMenuButton release];
	}
	else {
		nextLevelButton = [[BBTexturedButton alloc] initWithUpKey:@"nextlevel button up" downKey:@"nextlevel button down"];
		nextLevelButton.translation = BBPointMake(145, -115, 0);
		nextLevelButton.scale = BBPointMake(57,57,1);
		nextLevelButton.startLocation = nextLevelButton.translation;
		nextLevelButton.enabled = YES;
		nextLevelButton.target = [BBSceneController sharedSceneController].inputController;
		nextLevelButton.buttonUpAction = @selector(nextLevelButtonUp);
		nextLevelButton.buttonDownAction = @selector(nextLevelButtonDown);
		[[BBSceneController sharedSceneController].inputController addObjectToInterface:nextLevelButton];
		//[nextLevelButton release];
		
	}

	
	//set the award image
	highAngleImage = [[BBTexturedImage alloc] initWithImageName:@"highangle lock"];
	highAngleImage.translation = BBPointMake(-125, -65, 0);
	highAngleImage.scale = BBPointMake(43, 43, 1);
	highAngleImage.startLocation = highAngleImage.translation;
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:highAngleImage];
	//[highAngleImage release];
	
	justRightImage = [[BBTexturedImage alloc] initWithImageName:@"justright lock"];
	justRightImage.translation = BBPointMake(-75, -65, 0);
	justRightImage.scale = BBPointMake(43, 43, 1);
	justRightImage.startLocation = justRightImage.translation;
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:justRightImage];
	//[justRightImage release];
	
	fastSwitchImage = [[BBTexturedImage alloc] initWithImageName:@"fastswitch lock"];
	fastSwitchImage.translation = BBPointMake(-25, -65, 0);
	fastSwitchImage.scale = BBPointMake(43, 43, 1);
	fastSwitchImage.startLocation = fastSwitchImage.translation;
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:fastSwitchImage];
	//[fastSwitchImage release];
}

- (void)setScoreWithPongoPoint:(NSInteger)point andPongoBonus:(NSInteger)bonus
				 withHighAngle:(BOOL)high justRight:(BOOL)justRight andFastSwitch:(BOOL)fast {
	//update point
	pongoPoint.point = point;
	pongoBonus.point = bonus;
	//check award
	if (high) {
		highAngleImage.imageName = @"high angle";
	}
	if (justRight) {
		justRightImage.imageName = @"just right";
	}
	if (fast) {
		fastSwitchImage.imageName = @"fast switch";
	}
}

- (void)removeScoreBoardComponent {
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:bgImage];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:pongoPoint];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:pongoBonus];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:replayButton];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:nextLevelButton];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:highAngleImage];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:fastSwitchImage];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:justRightImage];
	if (isGameOver) {
		[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:mainMenuButton];
	}
}

- (void)dealloc {
	[super dealloc];
	[bgImage release];
	[pongoPoint release];
	[pongoBonus release];
	[replayButton release];
	[nextLevelButton release];
	[highAngleImage release];
	[fastSwitchImage release];
	[justRightImage release];
	[mainMenuButton release];
}

@end
