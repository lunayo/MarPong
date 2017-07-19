//
//  BBWormhole.h
//  MarPong
//
//  Created by Lunayo on 12/13/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBBlackhole.h"


@interface BBWormhole : BBBlackhole {
	BOOL isRun;
	NSString * groupName;
	NSString * type;
}

@property (assign) BOOL isRun;
@property (assign) NSString * groupName;
@property (assign) NSString * type;

@end
