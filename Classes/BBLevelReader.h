//
//  BBLevelReader.h
//  MarPong
//
//  Created by Lunayo on 10/25/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BBLevelReader : NSObject {
	NSMutableDictionary * kindOfMarble;
	NSString * marbleName;
}

@property (assign)NSMutableDictionary * kindOfMarble;
@property (assign)NSString * marbleName;

+ (BBLevelReader*)sharedLevelReader;
- (void)readLevel:(NSString *)string;
- (void)removeAllSceneObjects;
- (void)getMarbleCollection;

@end
