//
//  BBMarbleText.h
//  MarPong
//
//  Created by Lunayo on 1/14/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBText.h"


@interface BBMarbleText : BBText {
	NSString * name;
	NSString * origin;
	NSString * description;
}

@property (assign) NSString * name;
@property (assign) NSString * origin;
@property (assign) NSString * description;

@end
