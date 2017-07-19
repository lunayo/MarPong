//
//  BBEditorBoard.m
//  MarPong
//
//  Created by Lunayo on 1/21/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import "BBEditorBoard.h"
#import "BBMaterialController.h"


@implementation BBEditorBoard

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
	
}

- (void)removeScoreBoardComponent {
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:bgImage];
}

- (void)dealloc {
	[super dealloc];
	[bgImage release];
}

@end
