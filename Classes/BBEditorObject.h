//
//  BBEditorObject.h
//  MarPong
//
//  Created by Lunayo on 1/20/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBMobileObject.h"
#import "BBTexturedQuad.h"


@interface BBEditorObject : BBMobileObject {
	BOOL pressed;
	BOOL bgActive;
	NSString * objectName;
	NSString * objectType;
	NSString * extraType;
	CGRect screenRect;
	CGPoint touchPoint;
	BBTexturedQuad * bgQuad;
	NSString* imageName;
	CGPoint startPosition;
	CGPoint endPosition;
	CGPoint pixelPerSwipe;
	NSInteger backgroundHeight;
	NSInteger backgroundWidth;
}

@property (assign) NSString *objectName;
@property (assign) NSString *objectType;
@property (assign) NSString *extraType;
@property (assign) NSString* imageName;
@property (assign) BOOL bgActive;
@property (assign) CGRect screenRect;

- (id)initWithImageName:(NSString *)imageName;
- (void)moveAllObjectBy:(CGPoint)pixel;
- (void)handleTouches;
- (void)touchUp;
- (void)touchDown;

@end
