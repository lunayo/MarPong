//
//  BBConfiguration.h
//  MarPong
//
//  Created by Lunayo on 9/7/10.
//  Copyright 2010 Bina Nusantara University. All rights reserved.
//

//random function
#define RANDOM_SEED() srandom(time(NULL))
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + random() % ((__MAX__+1) - (__MIN__)))

//iphone width and height
#define IPHONE_BACKING_WIDTH 480
#define IPHONE_BACKING_HEIGHT 320

#define THRUST_SPEED_FACTOR 1.6

//gravity vector
#define GRAVITY_FACTOR 0.3
#define GRAVITY_DIRECTION 270

#define DRAGGED_SPEED_FACTOR 0.7

#define COEFFICIENT_OF_RESTITUTION 0.6

#define COEFFICIENT_FRICTION 0.06

#define MARBLE_BOOSTER_FACTOR 3.0

#define MAX_DISTANCE 60

// a handy constant to keep around
#define BBRADIANS_TO_DEGREES 57.2958

// material import settings
#define BB_CONVERT_TO_4444 0

#define BB_MAX_PARTICLES 40