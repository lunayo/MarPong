//
//  BBScoreBoard.h
//  MarPong
//
//  Created by Lunayo on 1/11/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBTexturedImage.h"
#import "BBPongoScore.h"
#import "BBTexturedQuad.h"
#import "BBTexturedButton.h"


@interface BBScoreBoard : NSObject {
	BBTexturedImage * bgImage;
	BBTexturedImage * highAngleImage;
	BBTexturedImage * fastSwitchImage;
	BBTexturedImage * justRightImage;
	BBPongoScore * pongoPoint;
	BBPongoScore * pongoBonus;
	BBTexturedButton * replayButton;
	BBTexturedButton * nextLevelButton;
	BBTexturedButton * mainMenuButton;
	BOOL isGameOver;
}

@property (assign) BOOL isGameOver;

- (void)awake;
- (void)removeScoreBoardComponent;
- (void)setScoreWithPongoPoint:(NSInteger)point andPongoBonus:(NSInteger)bonus withHighAngle:(BOOL)high justRight:(BOOL)justRight andFastSwitch:(BOOL)fast;

@end
