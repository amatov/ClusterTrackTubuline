// System dependent definitions and functions
// File: system.h

#include <iostream>
#include <iomanip>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>     // for seconds()

/*************** FUNCTIONS  *******************/

extern void seedRandom(unsigned int seed);
	      
extern double random(void);

extern double seconds();

