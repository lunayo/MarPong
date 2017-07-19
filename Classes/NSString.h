//
//  NSString.h
//  MarPong
//
//  Created by Lunayo on 11/13/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Support) 
- (NSComparisonResult) psuedoNumericCompare:(NSString *)otherString;
@end
