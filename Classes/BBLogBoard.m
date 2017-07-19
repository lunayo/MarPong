//
//  BBLogBoard.m
//  MarPong
//
//  Created by Lunayo on 2/10/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import "BBLogBoard.h"


@implementation BBLogBoard
@synthesize logList;

- (id)init {
	self = [super init];
	if (self != nil) {
		logList = [[NSMutableArray alloc] init];
		time = 200;
		logCount = 0;
	}
	return self;
}

- (void)awake {
	//init the properties of string
	textString = @"";
	textDimension = CGSizeMake(300, 100);
	textAlignment = UITextAlignmentLeft;
	fontName = @"Helvetica";
	fontSize = 13;
	translation = BBPointMake(-80.0, 105.0, 0.0);
	fontColor = BBPointMake(0.0, 0.0, 0.0);
	[super awake];
}

- (void)update {
	if ([logList count] > logCount) {
		for (NSString * object in logList) {
			textString = [textString stringByAppendingFormat:@"%@\n",object];
			[super update];
		}
		logCount = [logList count];
	}
	else if ([logList count] < 1) {
		textString = @"";
		[super update];
	}
	else {
		textString = @"";
	}
	
	if (time==0) {
		if ([logList count]>0) {
			[logList removeObjectAtIndex:0];
			logCount = 0 ;
		}
		time = 200;
	}
	time-=1;
}

- (void)dealloc {
	[super dealloc];
	[logList release];
}

@end
