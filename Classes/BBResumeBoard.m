//
//  BBResumeBoard.m
//  MarPong
//
//  Created by Lunayo on 1/17/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import "BBResumeBoard.h"
#import "BBMaterialController.h"


@implementation BBResumeBoard


- (void)awake {
	//load texture atlas data
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"ResumeAtlas"];
	//set the behind component
	bgImage = [[BBTexturedImage alloc] initWithImageName:@"resume screen"];
	bgImage.translation = BBPointMake(0, 0, 0);
	bgImage.scale = BBPointMake(480, 320, 1);
	bgImage.startLocation = bgImage.translation;
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:bgImage];
	[bgImage release];
	
	//set the button
	mainMenuButton = [[BBTexturedButton alloc] initWithUpKey:@"mainmenu button up" downKey:@"mainmenu button down"];
	mainMenuButton.translation = BBPointMake(105, -125, 0);
	mainMenuButton.scale = BBPointMake(57, 57, 1);
	mainMenuButton.startLocation = mainMenuButton.translation;
	mainMenuButton.enabled = YES;
	mainMenuButton.target = [BBSceneController sharedSceneController].inputController;
	mainMenuButton.buttonUpAction = @selector(mainMenuButtonUp);
	mainMenuButton.buttonDownAction = @selector(mainMenuButtonDown);
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:mainMenuButton];
	//[mainMenuButton release];
	
	resumeButton = [[BBTexturedButton alloc] initWithUpKey:@"resume button up" downKey:@"resume button down"];
	resumeButton.translation = BBPointMake(175, -125, 0);
	resumeButton.scale = BBPointMake(57,57,1);
	resumeButton.startLocation = resumeButton.translation;
	resumeButton.enabled = YES;
	resumeButton.target = [BBSceneController sharedSceneController].inputController;
	resumeButton.buttonUpAction = @selector(resumeButtonUp);
	resumeButton.buttonDownAction = @selector(resumeButtonDown);
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:resumeButton];
	//[resumeButton release];
	
}

- (void)removeScoreBoardComponent {
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:bgImage];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:resumeButton];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:mainMenuButton];
}

- (void)dealloc {
	[super dealloc];
	[bgImage release];
	[resumeButton release];
	[mainMenuButton release];
}

@end
