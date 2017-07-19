//
//  BBSelectButton.h
//  MarPong
//
//  Created by Lunayo on 1/17/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBSceneObject.h"

@interface BBSelectButton : BBSceneObject {
	NSString * keyName;
	BOOL pressed;
	CGRect screenRect;
	CGFloat * verts;
	CGFloat * colors;
}

@property (assign) NSString * keyName;

- (void)touchUp;
- (void)touchDown;

@end
