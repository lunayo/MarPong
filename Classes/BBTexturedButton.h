//
//  BBTexturedButton.h
//  MarPong
//
//  Created by Lunayo on 11/1/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBButton.h"
#import "BBTexturedQuad.h"

@interface BBTexturedButton : BBButton {
	BBTexturedQuad * upQuad;
	BBTexturedQuad * downQuad;
	NSString * objectName;
}

@property (retain) NSString * objectName;

- (id)initWithUpKey:(NSString*)upKey downKey:(NSString*)downKey;
- (void)dealloc;
- (void)awake;
- (void)setNotPressedVertexes;
- (void)setPressedVertexes;

@end
