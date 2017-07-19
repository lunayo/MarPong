//
//  BBText.m
//  MarPong
//
//  Created by Lunayo on 10/25/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "BBText.h"


@implementation BBText
@synthesize textString, fontName, fontSize, textDimension,textAlignment, color;

- (id)initWithString:(NSString*)string dimension:(CGSize)dimension alignment:(UITextAlignment)alignment fontName:(NSString*)name fontSize:(CGFloat)size color:(BBPoint)colors{
	self = [super init];
	if (self != nil) {
		textString = string;
		textDimension = dimension;
		textAlignment = alignment;
		fontName = name;
		fontSize = size;
		color = colors;
	}
	return self;
}

- (void)awake {
	textObject = [[Texture2D alloc] initWithString:textString dimensions:textDimension alignment:textAlignment fontName:fontName fontSize:fontSize color:fontColor];
	position.x = self.translation.x;
	position.y = self.translation.y; 
}

- (void)render {
	// Clears the view with black
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	// texturing will need these
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnable(GL_TEXTURE_2D);
	
	// text will need blending
	glEnable(GL_BLEND);
	glEnable(GL_COLOR_MATERIAL);
	// text from Texture2D uses A8 tex format, so needs GL_SRC_ALPHA
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	[textObject drawAtPoint:position];
	
	// switch it back to GL_ONE for other types of images, rather than text because Texture2D uses CG to load, which premultiplies alpha
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);

}

- (void)update {
	textObject = [[Texture2D alloc] initWithString:textString dimensions:textDimension alignment:textAlignment fontName:fontName fontSize:fontSize color:fontColor];
}

- (void)dealloc {
	[super dealloc];
	[textString release];
	[textObject release];
}

@end
