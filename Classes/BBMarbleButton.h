//
//  BBMarbleButton.h
//  MarPong
//
//  Created by Lunayo on 1/14/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBSceneObject.h"


@interface BBMarbleButton : BBSceneObject {
	
	BOOL pressed;
	NSString * marbleName;
	CGRect screenRect;
	CGFloat * verts;
	CGFloat * colors;
	NSString* origin;
	NSString* description;
}

@property (assign) NSString	* marbleName;
@property (assign) NSString * origin;
@property (assign) NSString * description;
@property (assign) BOOL pressed;

- (void)touchUp;
- (void)touchDown;

@end
