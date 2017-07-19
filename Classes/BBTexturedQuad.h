//
//  BBTexturedQuad.h
//  MarPong
//
//  Created by Lunayo on 10/29/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBMesh.h"

@interface BBTexturedQuad : BBMesh {

	GLfloat * uvCoordinates;
	NSString * materialKey;
}

@property (assign) GLfloat * uvCoordinates;
@property (retain) NSString * materialKey;


@end