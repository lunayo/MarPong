//
//  BBInputViewController.h
//  BBOpenGLGameTemplate
//
//  Created by ben smith on 1/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSceneObject.h"

@class BBSceneObject;
@class BBMarbleText;
@class BBSelectButton;
@class BBResumeBoard;
@class BBEditorObject;
@class BBTexturedImage;
@class addObjectBoard;
@interface BBInputViewController : UIViewController {
	NSMutableSet* touchEvents;
	NSMutableArray * interfaceObjects;
	NSString * levelName;
	NSInteger level;
	BOOL isVSGame;
	BBMarbleText * marbleText;
	BBTexturedImage * jarImage;
	BBSelectButton * selectButton;
	BBResumeBoard * resumeBoard;
	NSString * keyName;
	BBPoint tempSpeed;
	BBEditorObject *editorObject;
	addObjectBoard *editorBoard;
}

@property (retain) NSMutableSet* touchEvents;
@property (retain) NSString* levelName;
@property (retain) BBMarbleText * marbleText;
@property (retain) BBSelectButton * selectButton;
@property (retain) BBEditorObject * editorObject;
@property (assign) NSInteger level;
@property (assign) BOOL isVSGame;
@property (retain) NSString * keyName;
@property (assign) BBTexturedImage * jarImage;

- (void)clearEvents;
- (void)dealloc ;
- (void)didReceiveMemoryWarning ;
- (void)loadView ;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)viewDidUnload ;
- (CGRect)screenRectFromMeshRect:(CGRect)rect atPoint:(CGPoint)meshCenter;
- (void)renderInterface;
- (void)updateInterface;
- (void)removeAllInterfaceObject;
- (void)addObjectToInterface:(BBSceneObject *) object;
- (void)removeObjectFromInterface:(BBSceneObject *)object;
- (NSString*)dataFilePath;

@end
