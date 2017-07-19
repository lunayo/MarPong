//
//  BBMarbleBooster.h
//  MarPong
//
//  Created by Lunayo on 11/5/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBMobileObject.h"


@interface BBMarbleBooster : BBMobileObject {
	CGFloat * verts;
	CGFloat * colors;
}

- (void)checkAreaBounds;

@end
