//
//  BBScore.m
//  MarPong
//
//  Created by Lunayo on 10/21/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "BBScore.h"


@implementation BBScore
@synthesize score;

- (void)awake {
	//init the properties of score
	textString = [NSString stringWithFormat:@"Score : %d",score];
	textDimension = CGSizeMake(100, 30);
	textAlignment = UITextAlignmentCenter;
	fontName = @"Helvetica";
	fontSize = 14;
	translation = BBPointMake(140.0, 140.0, 0.0);
	fontColor = BBPointMake(0.0, 0.0, 0.0);
	[super awake];
}

- (void)update {
	textString = [NSString stringWithFormat:@"Score : %d",score];
	[super update];
}

@end
