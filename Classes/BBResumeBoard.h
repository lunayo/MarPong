//
//  BBResumeBoard.h
//  MarPong
//
//  Created by Lunayo on 1/17/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBTexturedImage.h"
#import "BBTexturedButton.h"


@interface BBResumeBoard : NSObject {
	BBTexturedImage * bgImage;
	BBTexturedButton * mainMenuButton;
	BBTexturedButton * resumeButton;
}

- (void)awake;
- (void)removeScoreBoardComponent;

@end
