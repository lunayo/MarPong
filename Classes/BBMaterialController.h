//
//  BBMaterialController.h
//  MarPong
//
//  Created by Lunayo on 10/29/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#import "BBPoint.h";
#import "BBConfiguration.h";
#import "BBAnimatedQuad.h"

@class BBTexturedQuad;
@class BBAnimatedQuad;

@interface BBMaterialController : NSObject {
	NSMutableDictionary * materialLibrary;
	NSMutableDictionary * quadLibrary;
}

@property (assign) NSMutableDictionary * materialLibrary;
@property (assign) NSMutableDictionary * quadLibrary;

+ (BBMaterialController*)sharedMaterialController;
- (BBTexturedQuad*)quadFromAtlasKey:(NSString*)atlasKey;
- (BBTexturedQuad*)texturedQuadFromAtlasRecord:(NSDictionary*)record 
									 atlasSize:(CGSize)atlasSize
								   materialKey:(NSString*)key;
- (BBTexturedQuad*)texturedQuadFromImage:(NSString *)imageName;
- (CGSize)loadTextureImage:(NSString*)imageName materialKey:(NSString*)materialKey;
- (id) init;
- (void) dealloc;
- (void)bindMaterial:(NSString*)materialKey;
- (void)loadAtlasData:(NSString*)atlasName;
- (BBAnimatedQuad*)animationFromAtlasKeys:(NSArray *)atlasKeys;

@end
