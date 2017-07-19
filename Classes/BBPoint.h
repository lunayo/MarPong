//
//  BBPoint.h
//  MarPong
//
//  Created by Lunayo on 9/4/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

typedef struct {
	CGFloat x,y,z;
}BBPoint;

typedef BBPoint *BBPointPtr;

static inline BBPoint BBPointMake(CGFloat x,CGFloat y,CGFloat z) {
	return (BBPoint) {x,y,z};
}

static inline float BBPointDistance(BBPoint p1, BBPoint p2) {
	return sqrt(((p1.x - p2.x) * (p1.x - p2.x)) + ((p1.y - p2.y) * (p1.y - p2.y))
				+ ((p1.z - p2.z) * (p1.z - p2.z)));
}

static inline BBPoint BBPointMatrixMultiply(BBPoint p, CGFloat* m)
{
	CGFloat x = (p.x*m[0]) + (p.y*m[4]) + (p.z*m[8]) + m[12];
	CGFloat y = (p.x*m[1]) + (p.y*m[5]) + (p.z*m[9]) + m[13];
	CGFloat z = (p.x*m[2]) + (p.y*m[6]) + (p.z*m[10]) + m[14];
	
	return (BBPoint) {x, y, z};
}

typedef struct {
	CGFloat start,length;
}BBRange;

static inline BBRange BBRangeMake(CGFloat start, CGFloat len) 
{	
	return (BBRange) {start, len};
}

static inline CGFloat BBRandomFloat(BBRange range)
{
	//return a random float
	CGFloat randPercent = ((CGFloat)(random() % 10001)/10000.0);
	CGFloat offset = randPercent * range.length;
	return offset + range.start;
}


