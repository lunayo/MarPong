//
//  BBMesh.h
//  SpaceRocks
//
//  Created by ben smith on 3/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#import "BBPoint.h"

@interface BBMesh : NSObject {
	// mesh data
	GLfloat * vertexes;
	GLfloat * colors;
	
	GLenum renderStyle;
	NSInteger vertexCount;
	NSInteger vertexSize;
	NSInteger colorSize;
	
	BBPoint centroid;
	CGFloat radius;
}

@property (assign) NSInteger vertexCount;
@property (assign) NSInteger vertexSize;
@property (assign) NSInteger colorSize;
@property (assign) GLenum renderStyle;

@property (assign) GLfloat * vertexes;
@property (assign) GLfloat * colors;
@property (assign) BBPoint centroid;
@property (assign) CGFloat radius;

+ (CGRect)meshBounds:(BBMesh*)mesh scale:(BBPoint)scale;
- (id)initWithVertexes:(CGFloat*)verts 
					 vertexCount:(NSInteger)vertCount 
					vertexSize:(NSInteger)vertSize
					 renderStyle:(GLenum)style;
- (BBPoint)calculateCentroid;
- (CGFloat)calculateRadius;
- (void)render;

@end
