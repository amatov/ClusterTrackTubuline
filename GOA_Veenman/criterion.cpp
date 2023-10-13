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

#include <assert.h>
#include <math.h>
#include <float.h>
#include <stdio.h>
#include <stdlib.h>

#include "criterion.h"

#define PROTECT_ZERO_DIV   (1.0E-03)

static int crt_MaxInterpol = -1;

static double crt_SmoothMotion_W1 = 0.1;
static double crt_SmoothMotion_W2 = 0.9;

void polint(float xa[], float ya[], int n, float x, float *y, float *dy);

static PhiInterpol phiInterpol[crt_NumIndividualModels] = {
   crt_SmoothMotionInterpol,
   crt_NearestNeighborInterpol,
   crt_ProximalUniformInterpol
};

static PhiNormal phiNormal[crt_NumIndividualModels] = {
   crt_SmoothMotion,
   crt_NearestNeighbor,
   NULL
};

static const int crt_CriterionOrderLookup[crt_NumIndividualModels] = {
   2, 1, 2,
};

int crt_CriterionOrder(crt_IndividualModel criterion)
{
   return(crt_CriterionOrderLookup[criterion]);
}

inline bool Greater(double a, double b)
{
   return(a - b > FLT_EPSILON);
}

inline bool Less(double a, double b)
{
   return(b - a > FLT_EPSILON);
}

PhiNormal crt_CriterionNormal(crt_IndividualModel criterion)
{
   assert(crt_SmoothMotionIndex <= criterion && criterion <= crt_ProximalUniformIndex);
   return(phiNormal[criterion - crt_SmoothMotionIndex]);
}

PhiInterpol crt_CriterionInterpol(crt_IndividualModel criterion)
{
   assert(crt_SmoothMotionIndex <= criterion && criterion <= crt_ProximalUniformIndex);
   return(phiInterpol[criterion - crt_SmoothMotionIndex]);
}


static int getLast(const frm_Sequence &s, int k, int trj, int points,
                   int dir, pnt_Point *list, int *first_valid)
{
   int frame = k;
   int count = 0;

   if (dir == crt_Forward) {
      for (count = 0; count < points && k >= 0; k--) {

         if (s.frame[k].point[trj].state == pnt_Normal) {
            /* First valid point starts trajectory */
            if (count == 0) {
               *first_valid = frame = k;
            } /* if */
            list[count++] = s.frame[k].point[trj];
         } /* if */
      } /* for */

      if (count == points) {
         return(frame - k);
      } /* if */

   } else {
      for (count = 0; count < points && k < s.len; k++) {
         if (s.frame[k].point[trj].state == pnt_Normal) {
            /* First valid point starts trajectory */
            if (count == 0) {
               *first_valid = frame = k;
            } /* if */
            list[count++] = s.frame[k].point[trj];
         } /* if */
      } /* for */

      if (count == points) {
         return(k - frame);
      } /* endif */

   } /* endif */

   return(0);
}

static double computeC1(const frm_Sequence &s, int k)
{
   double c1 = 0.0;
   double xx0, yy0;
   double xx1, yy1;
   double dx, dy;
   int x, z;

   for (x = 0; x < s.frame[k].len; x++) {

      assert(s.frame[k - 1].point[x].state == pnt_Normal);

      assert(s.frame[k].point[x].state == pnt_Normal);

      xx0 = s.frame[k].point[x].x - s.frame[k - 1].point[x].x;
      yy0 = s.frame[k].point[x].y - s.frame[k - 1].point[x].y;

      for (z = 0; z < s.frame[k].len; z++) {

         xx1 = s.frame[k + 1].point[z].x - s.frame[k].point[x].x;
         yy1 = s.frame[k + 1].point[z].y - s.frame[k].point[x].y;

         dx = xx1 - xx0;
         dy = yy1 - yy0;

         c1 += sqrt(dx * dx + dy * dy);

      } /* for */
   } /* for */
   return(c1);
}

static double computeC2(const frm_Sequence &s, int k)
{
   double c2 = 0.0;
   double dx, dy;
   int x, z;

   for (x = 0; x < s.frame[k].len; x++) {
      for (z = 0; z < s.frame[k].len; z++) {
         dx = s.frame[k + 1].point[z].x - s.frame[k].point[x].x;
         dy = s.frame[k + 1].point[z].y - s.frame[k].point[x].y;

         c2 += sqrt(dx * dx + dy * dy);

      } /* for */
   } /* for */
   return(c2);
}

bool crt_ProximalUniformInterpol(const frm_Sequence &s, int k, int t, int dir,
                                 const pnt_Point &p,
                                 double maxSpeed,
                                 double *result)
{
   double c1 = computeC1(s, k);
   double c2 = computeC2(s, k);
   double xx0, yy0;
   double xx1, yy1;
   double dx, dy;

   assert(c1 > DBL_EPSILON);
   assert(c2 > DBL_EPSILON);

   xx0 = s.frame[k].point[t].x - s.frame[k - 1].point[t].x;
   yy0 = s.frame[k].point[t].y - s.frame[k - 1].point[t].y;

   xx1 = p.x - s.frame[k].point[t].x;
   yy1 = p.y - s.frame[k].point[t].y;

   dx = xx1 - xx0;
   dy = yy1 - yy0;

   *result = sqrt(dx * dx + dy * dy) / c1 + sqrt(xx1 * xx1 + yy1 * yy1) / c2;

   return(true);
}

bool crt_SmoothMotion(const pnt_Point &p1, int d1,
                      const pnt_Point &p2, int d2,
                      const pnt_Point &p3,
                      double maxSpeed,
                      double *result)
{
   double len0, len1, xx0, xx1, yy0, yy1;

   assert(p1.state != pnt_Empty);
   assert(p2.state != pnt_Empty);
   assert(p3.state != pnt_Empty);

   xx0 = (p1.x - p2.x) / d1;
   yy0 = (p1.y - p2.y) / d1;

   len0 = sqrt(xx0 * xx0 + yy0 * yy0);

   if (Greater(len0, maxSpeed))
      return(false);

#ifdef PROTECT_ZERO_DIV

   if (xx0 >= 0)
      xx0 += PROTECT_ZERO_DIV;
   else
      xx0 -= PROTECT_ZERO_DIV;

   if (yy0 >= 0)
      yy0 += PROTECT_ZERO_DIV;
   else
      yy0 -= PROTECT_ZERO_DIV;

   len0 = sqrt(xx0 * xx0 + yy0 * yy0);

#endif

   assert(len0 > DBL_EPSILON);

   xx1 = (p2.x - p3.x) / d2;
   yy1 = (p2.y - p3.y) / d2;

   len1 = sqrt(xx1 * xx1 + yy1 * yy1);

   if (Greater(len1, maxSpeed))
      return(false);

#ifdef PROTECT_ZERO_DIV

   if (xx1 >= 0)
      xx1 += PROTECT_ZERO_DIV;
   else
      xx1 -= PROTECT_ZERO_DIV;

   if (yy1 >= 0)
      yy1 += PROTECT_ZERO_DIV;
   else
      yy1 -= PROTECT_ZERO_DIV;

   len1 = sqrt(xx1 * xx1 + yy1 * yy1);
#endif

   if (!(len1 > DBL_EPSILON))
      fprintf(stderr, "p1: (%f %f) p2: (%f %f) p3: (%f %f)\n",
              p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);

   assert(len1 > DBL_EPSILON);

   *result = crt_SmoothMotion_W1 * (1.0 - (xx0 * xx1 + yy0 * yy1) / (len0 * len1)) +
             crt_SmoothMotion_W2 * (1.0 - 2.0 * sqrt(len0 * len1) / (len0 + len1));

   return(true);
}

double squarePointDistance(const pnt_Point &p1, const pnt_Point &p2)
{
   return((double) (p1.x - p2.x) * (p1.x - p2.x) +
          (double) (p1.y - p2.y) * (p1.y - p2.y));
}

double crt_PointDistance(const pnt_Point &p1, const pnt_Point &p2)
{
   return(sqrt(squarePointDistance(p1, p2)));

}

bool crt_NearestNeighbor(const pnt_Point &p1, int d1,
                         const pnt_Point &p2, int d2,
                         const pnt_Point &p3,
                         double maxSpeed,
                         double *result)
{
   *result = crt_PointDistance(p2, p3) / d2;

   return(!Greater(*result, maxSpeed));
}

bool crt_SmoothMotionInterpol(const frm_Sequence &s, int k, int t, int dir,
                              const pnt_Point &p,
                              double maxSpeed,
                              double *result)
{
   int len, first;
   int order = crt_CriterionOrder(crt_SmoothMotionIndex);
   /* pnt_Point list[order]; */

   pnt_Point *list;

   list = (pnt_Point *) malloc (order * sizeof(pnt_Point));


   if (p.state == pnt_Normal) {

      *result = 0.0;

      if ((len = getLast(s, k, t, order, dir, list, &first)) > 0) {
         return(crt_SmoothMotion(list[1], len - 1,
                                 list[0], abs(k - first) + 1, p,
                                 maxSpeed, result));
      } /* endif */
   } /* endif */
   return(false);
}

static inline double sqr(double x)
{
   return(x * x);
}

static inline double rotX(double x, double y, double a)
{
   return(x * cos(a) - y * sin(a));
}

static inline double rotY(double x, double y, double a)
{
   return(x * sin(a) + y * cos(a));
}

static inline int min(const int i, const int j)
{
   return(i < j ? i : j);
}

bool crt_NearestNeighborInterpol(const frm_Sequence &s, int k, int t, int dir,
                                 const pnt_Point &p,
                                 double maxSpeed,
                                 double *result)
{
   int len, first;
   int order = crt_CriterionOrder(crt_ShortestPathIndex);
   
   
   /* pnt_Point list[order]; */

   pnt_Point *list;

   list = (pnt_Point *) malloc (order * sizeof(pnt_Point));

   assert(p.state == pnt_Normal);

   if (dir == crt_Forward) {
      order = min(order, k + 1);
   } else {
      order = min(order, s.len - 1 - k + 1);
   } /* endif */

   *result = 0.0;
   if ((len = getLast(s, k, t, order, dir, list, &first)) > 0) {
      return(crt_NearestNeighbor(list[0], len - 1, // ignored
                                 list[0], abs(k - first) + 1, p,
                                 maxSpeed, result));
   } /* if */
   return(false);
}

void crt_SetMaxInterpol(int maxInterpol)
{
   crt_MaxInterpol = maxInterpol;
}

void crt_SetModelWeights(double w1, double w2)
{
   crt_SmoothMotion_W1 = w1;
   crt_SmoothMotion_W2 = w2;
}
