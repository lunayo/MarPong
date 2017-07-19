//
//  BBButton.h
//  MarPong
//
//  Created by Lunayo on 10/30/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBSceneObject.h"

@interface BBButton : BBSceneObject {
	BOOL pressed;
	BOOL enabled;
	id target;
	SEL buttonDownAction;
	SEL buttonUpAction;
	CGRect screenRect;
}

@property (assign) id target;
@property (assign) SEL buttonDownAction;
@property (assign) SEL buttonUpAction;
@property (assign) BOOL enabled;

- (void)awake;
- (void)handleTouches;
- (void)setNotPressedVertexes;
- (void)setPressedVertexes;
- (void)touchDown;
- (void)touchUp;
- (void)update;


@end

