//
//  BBText.h
//  MarPong
//
//  Created by Lunayo on 10/25/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Texture2D.h"
#import "BBSceneObject.h"

@interface BBText : BBSceneObject {
	Texture2D * textObject;
	NSString * textString;
	NSString * fontName;
	NSInteger fontSize;
	BBPoint fontColor;
	CGPoint position;
	CGSize textDimension;
	UITextAlignment textAlignment;

}

@property (retain) NSString*  textString;
@property (assign) NSString* fontName;
@property (assign) NSInteger fontSize;
@property (assign) CGSize textDimension;
@property (assign) UITextAlignment textAlignment;
@property (assign) BBPoint color;

- (id)initWithString:(NSString *)string dimension:(CGSize)dimension alignment:(UITextAlignment)alignment fontName:(NSString *)name fontSize:(CGFloat)size color:(BBPoint)colors;

@end
