//
//  BBPlayer.h
//  MarPong
//
//  Created by Lunayo on 11/19/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBStaticMarble;
@interface BBPlayer : NSObject {
	NSString* name;
	NSMutableArray* marbleCollection;
	NSMutableArray* levelCollection;
	NSInteger pongoPoint;
	//vs game
	NSInteger marbleLife;
	NSInteger marbleScore;
	BBStaticMarble * marbleObject;
	//achivement
	BOOL isHighAngle;
	BOOL isFastSwitch;
	BOOL isJustRight;
}

@property (assign) NSString* name;
@property (retain) NSMutableArray* marbleCollection;
@property (retain) NSMutableArray* levelCollection;
@property (assign) BBStaticMarble * marbleObject;
@property (assign) NSInteger pongoPoint;
@property (assign) NSInteger marbleLife;
@property (assign) NSInteger marbleScore;
@property (assign) BOOL isHighAngle;
@property (assign) BOOL isFastSwitch;
@property (assign) BOOL isJustRight;

- (void)addLevelToCollection:(NSString *)levelName;
- (void)addMarbleToCollection:(NSString *)marbleName;

@end
