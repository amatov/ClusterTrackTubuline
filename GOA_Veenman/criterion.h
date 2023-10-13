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

#ifndef CRITERION_HH
#define CRITERION_HH

#include <float.h>

#include "frames.h"

typedef enum {
   crt_Forward,
   crt_Backward
}  crt_Direction;

typedef enum {
   crt_SmoothMotionIndex,
   crt_ShortestPathIndex,
   crt_ProximalUniformIndex,
   crt_NumIndividualModels,
}  crt_IndividualModel;

typedef bool (*PhiInterpol)(const frm_Sequence &s, int k, int t, int dir,
                            const pnt_Point &p,
                            double maxSpeed,
                            double *result);

typedef bool (*PhiNormal)(const pnt_Point &p1, int d1,
                          const pnt_Point &p2, int d2,
                          const pnt_Point &p3,
                          double maxSpeed,
                          double *result);


int crt_CriterionOrder(crt_IndividualModel criterion);

PhiNormal crt_CriterionNormal(crt_IndividualModel criterion);

PhiInterpol crt_CriterionInterpol(crt_IndividualModel criterion);


double squarePointDistance(const pnt_Point &p1, const pnt_Point &p2);

double crt_PointDistance(const pnt_Point &p1, const pnt_Point &p2);


bool crt_SmoothMotion(const pnt_Point &p1, int d1,
                      const pnt_Point &p2, int d2,
                      const pnt_Point &p3,
                      double maxSpeed,
                      double *result);


bool crt_NearestNeighbor(const pnt_Point &p1, int d1,
                         const pnt_Point &p2, int d2,
                         const pnt_Point &p3,
                         double maxSpeed,
                         double *result);

bool crt_ProximalUniformInterpol(const frm_Sequence &s, int k, int t, int dir,
                                 const pnt_Point &p,
                                 double maxSpeed,
                                 double *result);

bool crt_SmoothMotionInterpol(const frm_Sequence &s, int k, int t, int dir,
                              const pnt_Point &p,
                              double maxSpeed,
                              double *result);

bool crt_NearestNeighborInterpol(const frm_Sequence &s, int k, int t, int dir,
                                 const pnt_Point &p,
                                 double maxSpeed,
                                 double *result);

void crt_SetMaxInterpol(int maxInterpol);

void crt_SetModelWeights(double w1, double w2);

#endif
