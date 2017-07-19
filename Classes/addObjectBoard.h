//
//  addObjectBoard.h
//  MarPong
//
//  Created by Lunayo on 2/10/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBTexturedImage.h"
#import "BBTexturedQuad.h"
#import "BBTexturedButton.h"


@interface addObjectBoard : NSObject {
	BBTexturedImage * bgImage;
	BBTexturedButton * ufo;
	BBTexturedButton * wall;
	BBTexturedButton * star;
	BBTexturedButton * blackholeIn;
	BBTexturedButton * blackholeOut;
}

- (void)awake;
- (void)removeScoreBoardComponent;

@end
