//
//  NSString.m
//  MarPong
//
//  Created by Lunayo on 11/13/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

#import "NSString.h"


@implementation NSString (Support) 

// "psuedo-numeric" comparison
//   -- if both strings begin with digits, numeric comparison on the digits
//   -- if numbers equal (or non-numeric), caseInsensitiveCompare on the remainder

- (NSComparisonResult) psuedoNumericCompare:(NSString *)otherString {
	
    NSString *left  = self;
    NSString *right = otherString;
    NSInteger leftNumber, rightNumber;
	
	
    NSScanner *leftScanner = [NSScanner scannerWithString:left];
    NSScanner *rightScanner = [NSScanner scannerWithString:right];
	
    // if both begin with numbers, numeric comparison takes precedence
    if ([leftScanner scanInteger:&leftNumber] && [rightScanner scanInteger:&rightNumber]) {
        if (leftNumber < rightNumber)
            return NSOrderedAscending;
        if (leftNumber > rightNumber)
            return NSOrderedDescending;
		
        // if numeric values tied, compare the rest 
        left = [left substringFromIndex:[leftScanner scanLocation]];
        right = [right substringFromIndex:[rightScanner scanLocation]];
    }
	
    return [left caseInsensitiveCompare:right];
}
@end
