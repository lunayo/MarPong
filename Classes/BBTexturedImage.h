//
//  BBTexturedImage.h
//  MarPong
//
//  Created by Lunayo on 1/12/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBSceneObject.h"
#import "BBTexturedQuad.h"


@interface BBTexturedImage : BBSceneObject {
	BBTexturedQuad * bgQuad;
	NSString* imageName;
}

@property (assign) NSString* imageName;

- (id)initWithImageName:(NSString *)imageName;

@end
