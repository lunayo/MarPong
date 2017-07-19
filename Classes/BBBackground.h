//
//  BBBackground.h
//  MarPong
//
//  Created by Lunayo on 11/1/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBMobileObject.h"
#import "BBTexturedQuad.h"


@interface BBBackground : BBMobileObject {
	BBTexturedQuad * bgQuad;
	CGRect screenRect;
	BOOL pressed;
	CGPoint startPosition;
	CGPoint endPosition;
	CGPoint touchPoint;
	CGPoint pixelPerSwipe;
	NSInteger backgroundHeight;
	NSInteger backgroundWidth;
}

- (id)initWithBackgroundImage:(NSString *)imageName;
- (void)moveAllObjectBy:(CGPoint)pixel;
- (void)touchUp;
- (void)touchDown;
- (void)awake;
- (void)dealloc;

@end
