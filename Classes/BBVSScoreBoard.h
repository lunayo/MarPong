//
//  BBVSScoreBoard.h
//  MarPong
//
//  Created by Lunayo on 1/16/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBTexturedImage.h"
#import "BBPongoScore.h"
#import "BBTexturedQuad.h"
#import "BBTexturedButton.h"


@interface BBVSScoreBoard : NSObject {
	BBTexturedImage * bgImage;
	BBTexturedImage * highAngleImage1;
	BBTexturedImage * fastSwitchImage1;
	BBTexturedImage * justRightImage1;
	BBTexturedImage * highAngleImage2;
	BBTexturedImage * fastSwitchImage2;
	BBTexturedImage * justRightImage2;
	BBPongoScore * pongoPoint;
	BBPongoScore * pongoPoint2;
	BBTexturedButton * replayButton;
	BBTexturedButton * quitButton;
}

- (void)awake;
- (void)removeScoreBoardComponent;
- (void)setScoreWithPongoPoint:(NSInteger)point andPongoPoint2:(NSInteger)point2 withHighAngle1:(BOOL)high justRight1:(BOOL)justRight andFastSwitch1:(BOOL)fast
andHighAngle2:(BOOL)high2 justRight2:(BOOL)justRight2 andFastSwitch2:(BOOL)fast2;

@end
