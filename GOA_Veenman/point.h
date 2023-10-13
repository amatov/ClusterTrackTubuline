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

typedef struct point_t {
   float x, y;
   pnt_PointState state;
   int backward, forward;       /* Needed for IPAN tracker */
}  pnt_Point;

/* Empty point definition to be used for interpolation or unused tracks. */
static const pnt_Point EmptyPoint = {0.0, 0.0, pnt_Empty, -1, -1};

#endif
