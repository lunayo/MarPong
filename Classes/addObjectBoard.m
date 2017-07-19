//
//  addObjectBoard.m
//  MarPong
//
//  Created by Lunayo on 2/10/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import "addObjectBoard.h"
#import "BBMaterialController.h"


@implementation addObjectBoard

- (void)awake {
	//load texture atlas data
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"ResumeAtlas"];
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"anUfo"];
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"anBlackhole"];
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"WallAtlas"];
	[[BBMaterialController sharedMaterialController] loadAtlasData:@"anStar"];
	
	//set the behind component
	bgImage = [[BBTexturedImage alloc] initWithImageName:@"resume screen"];
	bgImage.translation = BBPointMake(0, 0, 0);
	bgImage.scale = BBPointMake(480, 320, 1);
	bgImage.startLocation = bgImage.translation;
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:bgImage];
		
	ufo = [[BBTexturedButton alloc] initWithUpKey:@"ufo 1" downKey:@"ufo 2"];
	ufo.translation = BBPointMake(-160, 80, 0);
	ufo.scale = BBPointMake(80, 50, 1);
	ufo.startLocation = ufo.translation;
	ufo.enabled = YES;
	ufo.target = [BBSceneController sharedSceneController].inputController;
	ufo.buttonUpAction = @selector(ufoButtonUp);
	ufo.buttonDownAction = @selector(ufoButtonDown);
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:ufo];
	
	wall = [[BBTexturedButton alloc] initWithUpKey:@"wall" downKey:@"wall"];
	wall.translation = BBPointMake(-40, 80, 0);
	wall.scale = BBPointMake(90, 30, 1);
	wall.startLocation = wall.translation;
	wall.enabled = YES;
	wall.target = [BBSceneController sharedSceneController].inputController;
	wall.buttonUpAction = @selector(wallButtonUp);
	wall.buttonDownAction = @selector(wallButtonDown);
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:wall];
	
	star = [[BBTexturedButton alloc] initWithUpKey:@"star 3" downKey:@"star 2"];
	star.translation = BBPointMake(50, 80, 0);
	star.scale = BBPointMake(50, 50, 1);
	star.startLocation = star.translation;
	star.enabled = YES;
	star.target = [BBSceneController sharedSceneController].inputController;
	star.buttonUpAction = @selector(starButtonUp);
	star.buttonDownAction = @selector(starButtonDown);
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:star];
	
	blackholeIn = [[BBTexturedButton alloc] initWithUpKey:@"blackhole 3" downKey:@"blackhole 2"];
	blackholeIn.translation = BBPointMake(120, 80, 0);
	blackholeIn.scale = BBPointMake(50, 50, 1);
	blackholeIn.startLocation = blackholeIn.translation;
	blackholeIn.enabled = YES;
	blackholeIn.target = [BBSceneController sharedSceneController].inputController;
	blackholeIn.buttonUpAction = @selector(blackholeInButtonUp);
	blackholeIn.buttonDownAction = @selector(blackholeInButtonDown);
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:blackholeIn];
	
	blackholeOut = [[BBTexturedButton alloc] initWithUpKey:@"blackhole 5" downKey:@"blackhole 6"];
	blackholeOut.translation = BBPointMake(190, 80, 0);
	blackholeOut.scale = BBPointMake(50, 50, 1);
	blackholeOut.startLocation = blackholeOut.translation;
	blackholeOut.enabled = YES;
	blackholeOut.target = [BBSceneController sharedSceneController].inputController;
	blackholeOut.buttonUpAction = @selector(blackholeOutButtonUp);
	blackholeOut.buttonDownAction = @selector(blackholeOutButtonDown);
	[[BBSceneController sharedSceneController].inputController addObjectToInterface:blackholeOut];
	
}

- (void)removeScoreBoardComponent {
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:bgImage];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:ufo];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:star];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:blackholeIn];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:blackholeOut];
	[[BBSceneController sharedSceneController].inputController removeObjectFromInterface:wall];
}

- (void)dealloc {
	[super dealloc];
	[bgImage release];
	[wall release];
	[ufo release];
	[star release];
	[blackholeIn release];
	[blackholeOut release];
}


@end
