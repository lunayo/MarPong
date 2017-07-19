//
//  BBTextBox.h
//  MarPong
//
//  Created by Lunayo on 1/30/11.
//  Copyright 2011 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBText.h"


@interface BBTextBox : BBText {
	NSString * playerName;
	NSInteger playerLife;
}

@property (assign)NSString * playerName;
@property (assign)NSInteger playerLife;

@end
