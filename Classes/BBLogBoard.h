//
//  BBLogBoard.h
//  MarPong
//
//  Created by Lunayo on 2/10/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBText.h"


@interface BBLogBoard : BBText {
	NSMutableArray * logList;
	NSInteger logCount;
	NSInteger time;
}

@property (assign) NSMutableArray * logList;

@end
