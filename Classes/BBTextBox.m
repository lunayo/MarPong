//
//  BBTextBox.m
//  MarPong
//
//  Created by Lunayo on 1/30/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import "BBTextBox.h"


@implementation BBTextBox
@synthesize playerName, playerLife;

- (void)awake {
	//init the properties of string
	textString = [NSString stringWithFormat:@"Information :\n%@ Turn\n%d Life Left",playerName,playerLife];
	textDimension = CGSizeMake(150, 100);
	textAlignment = UITextAlignmentLeft;
	fontName = @"Helvetica";
	fontSize = 14;
	translation = BBPointMake(-150.0, 105.0, 0.0);
	fontColor = BBPointMake(0.0, 0.0, 0.0);
	[super awake];
}

- (void)update {
	textString = [NSString stringWithFormat:@"Information :\n%@ Turn\n%d Life Left",playerName,playerLife];
	[super update];
}


@end
