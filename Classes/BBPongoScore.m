//
//  BBPongoScore.m
//  MarPong
//
//  Created by Lunayo on 1/12/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import "BBPongoScore.h"


@implementation BBPongoScore
@synthesize point;

- (void)awake {
	//init the properties of score
	textString = [NSString stringWithFormat:@"%d",point];
	textDimension = CGSizeMake(100, 30);
	textAlignment = UITextAlignmentRight;
	fontName = @"Helvetica";
	fontSize = 20;
	fontColor = BBPointMake(0.0, 0.0, 0.0);
	[super awake];
}

- (void)update {
	textString = [NSString stringWithFormat:@"%d",point];
	[super update];
}

@end
