//
//  BBEditorBoard.h
//  MarPong
//
//  Created by Lunayo on 1/21/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBTexturedImage.h"
#import "BBTexturedButton.h"


@interface BBEditorBoard : NSObject {
	BBTexturedImage * bgImage;
}

- (void)awake;
- (void)removeScoreBoardComponent;

@end
