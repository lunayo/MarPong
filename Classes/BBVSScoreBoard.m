//
//  BBVSScoreBoard.m
//  MarPong
//
//  Created by Lunayo on 1/16/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import "BBVSScoreBoard.h"
#import "BBMaterialController.h"


@implementation BBVSScoreBoard

- (id)init {
	self = [super init];
	if (self != nil) {
		//load texture atlas data
		[[BBMaterialController sharedMaterialController] loadAtlasData:@"VSScoreBoardAtlas"];
	}
	return self;
}

- (void)awake {
	
	//set the behind component
	bgImage = [[BBTexturedImage alloc] initWithImageName:@"vs screen"];
	bgImage.translation = BBPointMake(0, 0, 0);
	bgImage.scale = BBPointMake(480, 320, 1);
	bgImage.startLocation = bgImage.translation;
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:bgImage];
	[bgImage release];
	
	pongoPoint = [[BBPongoScore alloc] init];
	pongoPoint.translation = BBPointMake(100, 35, 0);
	[pongoPoint awake];
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:pongoPoint];
	//[pongoPoint release];
	
	pongoPoint2 = [[BBPongoScore alloc] init];
	pongoPoint2.translation = BBPointMake(100, -75, 0);
	[pongoPoint2 awake];
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:pongoPoint2];
	//[pongoPoint release];
	
	//set the button
	replayButton = [[BBTexturedButton alloc] initWithUpKey:@"replay button up" downKey:@"replay button down"];
	replayButton.translation = BBPointMake(70, -115, 0);
	replayButton.scale = BBPointMake(55, 55, 1);
	replayButton.startLocation = replayButton.translation;
	replayButton.enabled = YES;
	replayButton.target = [BBSceneController sharedSceneController].inputController;
	replayButton.buttonUpAction = @selector(vsReplayButtonUp);
	replayButton.buttonDownAction = @selector(vsReplayButtonDown);
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:replayButton];
	//[replayButton release];
	
	quitButton = [[BBTexturedButton alloc] initWithUpKey:@"quit button up" downKey:@"quit button down"];
	quitButton.translation = BBPointMake(150, -115, 0);
	quitButton.scale = BBPointMake(55,55,1);
	quitButton.startLocation = quitButton.translation;
	quitButton.enabled = YES;
	quitButton.target = [BBSceneController sharedSceneController].inputController;
	quitButton.buttonUpAction = @selector(quitButtonUp);
	quitButton.buttonDownAction = @selector(quitButtonDown);
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:quitButton];
	//[quitButton release];
	
	//set the award image
	highAngleImage1 = [[BBTexturedImage alloc] initWithImageName:@"highangle lock"];
	highAngleImage1.translation = BBPointMake(-140, 35, 0);
	highAngleImage1.scale = BBPointMake(31, 31, 1);
	highAngleImage1.startLocation = highAngleImage1.translation;
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:highAngleImage1];
	//[highAngleImage release];
	
	justRightImage1 = [[BBTexturedImage alloc] initWithImageName:@"justright lock"];
	justRightImage1.translation = BBPointMake(-100, 35, 0);
	justRightImage1.scale = BBPointMake(31, 31, 1);
	justRightImage1.startLocation = justRightImage1.translation;
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:justRightImage1];
	//[justRightImage release];
	
	fastSwitchImage1 = [[BBTexturedImage alloc] initWithImageName:@"fastswitch lock"];
	fastSwitchImage1.translation = BBPointMake(-60, 35, 0);
	fastSwitchImage1.scale = BBPointMake(31, 31, 1);
	fastSwitchImage1.startLocation = fastSwitchImage1.translation;
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:fastSwitchImage1];
	//[fastSwitchImage release];
	
	//set the award image
	highAngleImage2 = [[BBTexturedImage alloc] initWithImageName:@"highangle lock"];
	highAngleImage2.translation = BBPointMake(-140, -75, 0);
	highAngleImage2.scale = BBPointMake(31, 31, 1);
	highAngleImage2.startLocation = highAngleImage2.translation;
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:highAngleImage2];
	//[highAngleImage release];
	
	justRightImage2 = [[BBTexturedImage alloc] initWithImageName:@"justright lock"];
	justRightImage2.translation = BBPointMake(-100, -75, 0);
	justRightImage2.scale = BBPointMake(31, 31, 1);
	justRightImage2.startLocation = justRightImage2.translation;
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:justRightImage2];
	//[justRightImage release];
	
	fastSwitchImage2 = [[BBTexturedImage alloc] initWithImageName:@"fastswitch lock"];
	fastSwitchImage2.translation = BBPointMake(-60, -75, 0);
	fastSwitchImage2.scale = BBPointMake(31, 31, 1);
	fastSwitchImage2.startLocation = fastSwitchImage2.translation;
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:fastSwitchImage2];
	//[fastSwitchImage release];
}

- (void)setScoreWithPongoPoint:(NSInteger)point andPongoPoint2:(NSInteger)point2 withHighAngle1:(BOOL)high justRight1:(BOOL)justRight andFastSwitch1:(BOOL)fast
		andHighAngle2:(BOOL)high2 justRight2:(BOOL)justRight2 andFastSwitch2:(BOOL)fast2 {
	//update point
	pongoPoint.point = point;
	pongoPoint2.point = point2;
	//check award
	if (high) {
		highAngleImage1.imageName = @"highangle";
	}
	if (justRight) {
		justRightImage1.imageName = @"justright";
	}
	if (fast) {
		fastSwitchImage1.imageName = @"fastswitch";
	}
	if (high2) {
		highAngleImage2.imageName = @"highangle";
	}
	if (justRight2) {
		justRightImage2.imageName = @"justright";
	}
	if (fast2) {
		fastSwitchImage2.imageName = @"fastswitch";
	}
}

- (void)removeScoreBoardComponent {
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:bgImage];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:pongoPoint];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:replayButton];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:quitButton];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:highAngleImage1];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:fastSwitchImage1];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:justRightImage1];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:highAngleImage2];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:fastSwitchImage2];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:justRightImage2];
	
}

- (void)dealloc {
	[super dealloc];
	[bgImage release];
	[pongoPoint release];
	[replayButton release];
	[quitButton release];
	[highAngleImage1 release];
	[fastSwitchImage1 release];
	[justRightImage1 release];
	[highAngleImage2 release];
	[fastSwitchImage2 release];
	[justRightImage2 release];
}

@end
