/*****************************************************************************

    Copyright (c) 2002 C.J. Veenman

    Permission is hereby granted, free of charge, to any person
    obtaining a copy of this software and associated documentation files
    (the "Software"), to deal in the Software without restriction,
    including without limitation the rights to use, copy, modify, merge,
    publish, distribute, sublicense, and/or sell copies of the Software,
    and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:

    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
    BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
    ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.


    Correspondence should be directed to:

            Cor J. Veenman

            Department of Mediamatics
            Faculty of Information Technology and Systems
            Delft University of Technology
            Delft
            The Netherlands

            email:  C.J.Veenman@its.tudelft.nl

*****************************************************************************/


/* Comment on point structure 

   The primary consideration is about how to incorporate 

   (1) Track statistics: 
   
   Undoubtedly, this will be a critical requirement for the final completion of
   this software. Currently, my understanding is that this would naturally require 
   a separate structure. It is obviously not apropriate to incorporate such infor-
   mation into the point structure.

   (2) Feature intensity:

   This can be naturally incorporated into the point structure with reasonable increase
   in memory cost. 

   (3) Flux field:

   This is a somewhat difficult issue. Currently, my understanding is to maintain a
   global map of the flux field and then look it up for every point. It is possible
   that the flow pattern may change over time. My plan then is to introduce a sequence
   of pattern look-up tables.

*/




#ifndef POINT_HH
#define POINT_HH

/* Goa tracker only uses 'empty' and 'normal'. IPAN tracker uses more point
 * states as defined below.
 */





typedef enum {
   pnt_Normal,
   pnt_Empty,
   pnt_Estimated,
   pnt_Head,
   pnt_Tail,
   pnt_Single,
   pnt_PointStates
}  pnt_PointState;

#ifndef MAX_POINT_FEATURE_DIM
#define MAX_POINT_FEATURE_DIM 3
#endif

typedef struct point_t {
   float x, y;
   float intensity;      /* Grey-level of the feature. */
   float area;           /* Area of the feature. For vesicle tracking */  
   unsigned char state;  /* '0' for normal, '1' for empty, others to be defined */
   short frameID;        /* The frame in which this point resides */
   float otherFeatures[MAX_POINT_FEATURE_DIM];
}  pnt_Point;

/* Empty point definition to be used for interpolation or unused tracks. */
static const pnt_Point EmptyPoint = {0.0, 0.0, -1, -1, pnt_Empty, -1, {0, 0, 0}};  
/* Set intensity to -1 for empty points. Set area to -1 for empty points */


#endif
