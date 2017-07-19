//
//  BBMarbleText.m
//  MarPong
//
//  Created by Lunayo on 1/14/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import "BBMarbleText.h"


@implementation BBMarbleText
@synthesize name,origin,description;

- (void)awake {
	//init the properties of score
	textString = [NSString stringWithFormat:@"                       Name: %@\n                       Origin: %@\n\n\n%@",name,origin,description];
	textDimension = CGSizeMake(170, 250);
	textAlignment = UITextAlignmentLeft;
	fontName = @"Helvetica";
	fontSize = 12;
	fontColor = BBPointMake(1.0, 1.0, 1.0);
	[super awake];
}

- (void)update {
	textString = [NSString stringWithFormat:@"                       Name: %@\n                       Origin: %@\n\n\n%@",name,origin,description];
	[super update];
}

@end
