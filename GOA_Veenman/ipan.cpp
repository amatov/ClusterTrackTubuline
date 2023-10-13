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

    Contents:

        Main module of the IPAN tracker, based on the following
        publication:

            D. Chetverikov and J. Veresto'y, 'Feature Point Tracking for
            Incomplete Trajectories'. Computing, Devoted Issue on Digital
            Image Processing', 62:321-338, 1999.

        and personal communication with Dr. D. Chetverikov.

        Remark: Instead of the interpolation scheme described in the
                paper a simpler scheme is implemented.

*****************************************************************************/


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <float.h>
#include <assert.h>

#include "tracking.h"
#include "criterion.h"

#define VERIFICATION_LEVELS (2)

static void swapInt(int &i1, int &i2)
{
   int i;

   i = i1; i1 = i2; i2 = i;
}

static inline int forwardLink(frm_Sequence &s, int k, int i)
{
   return(s.frame[k].point[i].forward);
}

static inline bool isForwardLinked(frm_Sequence &s, int k, int i)
{
   return(s.frame[k].point[i].forward >= 0);
}

static inline int backwardLink(frm_Sequence &s, int k, int i)
{
   return(s.frame[k].point[i].backward);
}

static inline bool isBackwardLinked(frm_Sequence &s, int k, int i)
{
   return(s.frame[k].point[i].backward >= 0);
}

static inline void consolidateBackwardLink(frm_Sequence &s, int k, int i)
{
   if (isBackwardLinked(s, k, i)) {
      s.frame[k - 1].point[s.frame[k].point[i].backward].forward = i;
   } /* if */
}

static inline void consolidateForwardLink(frm_Sequence &s, int k, int i)
{
   if (isForwardLinked(s, k, i)) {
      s.frame[k + 1].point[s.frame[k].point[i].forward].backward = i;
   } /* if */
}

static inline bool validForwardLink(frm_Sequence &s, int k, int i)
{
   assert(isForwardLinked(s, k, i));
   return(s.frame[k + 1].point[s.frame[k].point[i].forward].backward == i);
}

static inline bool validBackwardLink(frm_Sequence &s, int k, int i)
{
   assert(isBackwardLinked(s, k, i));
   return(s.frame[k - 1].point[s.frame[k].point[i].backward].forward == i);
}

static int findLink(frm_Sequence &s, int k, int pointLink)
{
   int i;

   assert(pointLink >= 0);
   for (i = 0; i < s.frame[k].len; i++) {
      assert(!isForwardLinked(s, k, i) || validForwardLink(s, k, i));
      if (i != pointLink && s.frame[k].point[i].forward == pointLink) {
         assert(validForwardLink(s, k, i));
         return(i);
      } /* if */
   } /* for */
   return(-1);
}

static void extendPointList(frm_Frame &pointList, int newLen)
{
   int i;
   pnt_Point *points = (pnt_Point *) malloc(newLen * sizeof(pnt_Point));

   memcpy(points, pointList.point, pointList.len * sizeof(pnt_Point));
   for (i = pointList.len; i < newLen; i++) {
      points[i].state = pnt_Empty;
      points[i].x = points[i].y = 0.0;
      points[i].backward = points[i].forward = -1;
   } /* endfor */
   if (pointList.point != NULL)
      free(pointList.point);
   pointList.point = points;
   pointList.len = newLen;
}

static void findPointsInRange(frm_Sequence &s, int k, int exceptTrack,
                              crt_Direction freeDirection,
                              pnt_Point &reference, double range,
                              int *&pointIndexes, int &numPoints)
{
   int i;
   int *list;
   double squareRange = range * range;

   list = (int *) malloc(s.frame[k].len * sizeof(int));

   numPoints = 0;

   for (i = 0; i < s.frame[k].len; i++) {
      if (i != exceptTrack && s.frame[k].point[i].state == pnt_Normal
       && (freeDirection != crt_Forward || !isForwardLinked(s, k, i))
       && (freeDirection != crt_Backward || !isBackwardLinked(s, k, i))) {
         if (squarePointDistance(reference, s.frame[k].point[i]) <= squareRange) {
            list[numPoints++] = i;
         } /* if */
      } /* if */
   } /* for */

   if (numPoints > 0) {
      pointIndexes = (int *) malloc(numPoints * sizeof(int));
      memcpy(pointIndexes, list, numPoints * sizeof(int));
   } else {
      pointIndexes = NULL;
   } /* endif */

   free(list);
}

static void sortPointTriplets(frm_Sequence &s, int k, int traject,
                              int *points_km, int numPoints_km,
                              int *points_kp, int numPoints_kp,
                              crt_IndividualModel criterion, double maxSpeed)
{
   PhiNormal phi = crt_CriterionNormal(criterion);

   int i, j;
   double phi1, phi2;

   assert(numPoints_km == numPoints_kp);

   /* Straight forward bubble sort */
   for (i = 0; i < numPoints_km - 1; i++) {
      for (j = i + 1; j < numPoints_km; j++) {
         phi(s.frame[k - 1].point[points_km[i]], 1,
             s.frame[k].point[traject], 1,
             s.frame[k + 1].point[points_kp[i]],
             maxSpeed, &phi1);
         phi(s.frame[k - 1].point[points_km[j]], 1,
             s.frame[k].point[traject], 1,
             s.frame[k + 1].point[points_kp[j]],
             maxSpeed, &phi2);

         if (phi1 > phi2) {
            swapInt(points_km[i], points_km[j]);
            swapInt(points_kp[i], points_kp[j]);
         } /* if */
      } /* for */
   } /* for */
}

static void removeInvalidPointTriplets(frm_Sequence &s, int k, int traject,
                                       int *points_km, int &numPoints_km,
                                       int *points_kp, int &numPoints_kp,
                                       crt_IndividualModel criterion,
                                       double maxSpeed, double maxPhi)
{
   PhiNormal phi = crt_CriterionNormal(criterion);

   int i;
   double phi1;

   assert(numPoints_km == numPoints_kp);

   for (i = 0; i < numPoints_km; i++) {
      if (!phi(s.frame[k - 1].point[points_km[i]], 1,
              s.frame[k].point[traject], 1,
              s.frame[k + 1].point[points_kp[i]],
              maxSpeed, &phi1) || phi1 > maxPhi) {
         /* remove it, cause it is invalid */
         memmove(points_km + i, points_km + i + 1,
                 (--numPoints_km - i) * sizeof(int));
         memmove(points_kp + i, points_kp + i + 1,
                (--numPoints_kp - i) * sizeof(int));

         i--;
      } /* if */
   } /* for */
}

static void extendCombinations(int *&list1, int &len1, int *&list2, int &len2)
{
   int i, j;
   int num = len1 * len2;

   int *new1 = NULL;
   int *new2 = NULL;

   if (num > 0) {
      new1 = (int *) malloc(num * sizeof(int));
      new2 = (int *) malloc(num * sizeof(int));

      for (i = 0; i < len1; i++) {
         for (j = 0; j < len2; j++) {
            new1[i * len2 + j] = list1[i];
            new2[i * len2 + j] = list2[j];
         } /* for */
      } /* for */

   } /* if */

   if (list1)
      free(list1);
   if (list2)
      free(list2);

   list1 = new1;
   list2 = new2;

   len1 = len2 = num;
}

static void singlePoint(int p, int *&pointIndexes, int &numPoints)
{
   pointIndexes = (int *) malloc(sizeof(int));
   *pointIndexes = p;
   numPoints = 1;
}

static bool forwardCompetitionLost(frm_Sequence &s, int k,
                                   int p_km, int p_k, int p_kp,
                                   int verificationLevels, double maxSpeed);

static bool backwardCompetitionLost(frm_Sequence &s, int k,
                                    int p_km, int p_k, int p_kp,
                                    int verificationLevels, double maxSpeed);

static bool backwardCompetitionLost(frm_Sequence &s, int k,
                                    int p_km, int p_k, int p_kp,
                                    int verificationLevels, double maxSpeed)
{
   int i, j;
   int *points = NULL;
   int numPoints = 0;
   int *competitorPoints = NULL;
   int numCompetitorPoints = 0;
   double refPhi, phi;

   assert(verificationLevels >= 0);

   if (verificationLevels == 0) {
      return(false);
   } /* if */

   crt_SmoothMotion(s.frame[k - 1].point[p_km], 1,
                    s.frame[k].point[p_k], 1,
                    s.frame[k + 1].point[p_kp],
                    maxSpeed, &refPhi);

   if (isForwardLinked(s, k - 1, p_km)) {
      singlePoint(s.frame[k - 1].point[p_km].forward,
                  competitorPoints, numCompetitorPoints);
   } else {
      findPointsInRange(s, k, p_k, crt_Backward,
                        s.frame[k - 1].point[p_km], maxSpeed,
                        competitorPoints, numCompetitorPoints);
   } /* if */

   for (i = 0; i < numCompetitorPoints; i++) {
      if (s.frame[k].point[competitorPoints[i]].forward >= 0) {
         singlePoint(s.frame[k].point[competitorPoints[i]].forward,
                     points, numPoints);
      } else {
         findPointsInRange(s, k + 1, -1, crt_Backward,
                           s.frame[k].point[competitorPoints[i]],
                           maxSpeed, points, numPoints);
      } /* if */

      for (j = 0; j < numPoints; j++) {

         if (crt_SmoothMotion(s.frame[k - 1].point[p_km], 1,
                          s.frame[k].point[competitorPoints[i]], 1,
                          s.frame[k + 1].point[points[j]],
                          maxSpeed, &phi) && phi < refPhi) {
            if (!forwardCompetitionLost(s, k,
                                        p_km, competitorPoints[i], points[j],
                                        verificationLevels - 1,
                                        maxSpeed)
             && !backwardCompetitionLost(s, k,
                                         p_km, competitorPoints[i], points[j],
                                         verificationLevels - 1,
                                         maxSpeed)) {

               if (points)
                  free(points);
               if (competitorPoints)
                  free(competitorPoints);
               return(true);
            } /* if */
         } /* if */
      } /* for */
      if (points)
         free(points);
   } /* for */

   if (competitorPoints)
      free(competitorPoints);

   return(false);
}

static bool forwardCompetitionLost(frm_Sequence &s, int k,
                                   int p_km, int p_k, int p_kp,
                                   int verificationLevels, double maxSpeed)
{
   int i, j;
   int *points = NULL;
   int numPoints = 0;
   int *competitorPoints = NULL;
   int numCompetitorPoints = 0;
   double refPhi, phi;

   assert(verificationLevels >= 0);

   if (verificationLevels == 0) {
      return(false);
   } /* if */

   crt_SmoothMotion(s.frame[k - 1].point[p_km], 1,
                s.frame[k].point[p_k], 1,
                s.frame[k + 1].point[p_kp],
                maxSpeed, &refPhi);

   if (isBackwardLinked(s, k + 1, p_kp)) {
      singlePoint(backwardLink(s, k + 1, p_kp),
                  competitorPoints, numCompetitorPoints);
   } else {
      findPointsInRange(s, k, p_k, crt_Forward,
                        s.frame[k + 1].point[p_kp], maxSpeed,
                        competitorPoints, numCompetitorPoints);
   } /* if */

   for (i = 0; i < numCompetitorPoints; i++) {
      if (s.frame[k].point[competitorPoints[i]].backward >= 0) {
         singlePoint(s.frame[k].point[competitorPoints[i]].backward,
                     points, numPoints);
      } else {
         findPointsInRange(s, k - 1, -1, crt_Forward,
                           s.frame[k].point[competitorPoints[i]],
                           maxSpeed, points, numPoints);
      } /* if */

      for (j = 0; j < numPoints; j++) {
         if (crt_SmoothMotion(s.frame[k - 1].point[points[j]], 1,
                          s.frame[k].point[competitorPoints[i]], 1,
                          s.frame[k + 1].point[p_kp],
                          maxSpeed, &phi) && phi < refPhi) {

            if (!backwardCompetitionLost(s, k,
                                         points[j], competitorPoints[i], p_kp,
                                         verificationLevels - 1, maxSpeed)
             && !forwardCompetitionLost(s, k,
                                        points[j], competitorPoints[i], p_kp,
                                        verificationLevels - 1, maxSpeed)) {

               if (points)
                  free(points);
               if (competitorPoints)
                  free(competitorPoints);
               return(true);
            } /* if */
         } /* if */
      } /* for */
      if (points)
         free(points);
   } /* for */

   if (competitorPoints)
      free(competitorPoints);

   return(false);
}

static int checkBackwardHypotheses(frm_Sequence &s, int k, int traject,
                                   int *points_km, int *points_kp, bool *valid,
                                   int num, int verificationLevels,
                                   double maxSpeed)
{
   int i, j;

   for (i = 0; i < num; i++) {
      if (valid[i]) {
         if (backwardCompetitionLost(s, k, points_km[i], traject, points_kp[i],
                                     verificationLevels, maxSpeed)) {
            valid[i] = false;
            for (j = i + 1; j < num; j++) {
               if (points_km[j] == points_km[i]) {
                  valid[j] = false;
               } /* if */
            } /* for */
         } else {
            return(i);
         } /* if */
      } /* if */
   } /* for */

   return(-1);
}

static int checkForwardHypotheses(frm_Sequence &s, int k, int traject,
                                  int *points_km, int *points_kp, bool *valid,
                                  int num, int verificationLevels,
                                  double maxSpeed)
{
   int i, j;

   for (i = 0; i < num; i++) {
      if (valid[i]) {
         if (forwardCompetitionLost(s, k,
                                    points_km[i], traject, points_kp[i],
                                    verificationLevels, maxSpeed)) {
            valid[i] = false;
            for (j = i + 1; j < num; j++) {
               if (points_kp[j] == points_kp[i]) {
                  valid[j] = false;
               } /* if */
            } /* for */
         } else {
            return(i);
         } /* if */
      } /* if */
   } /* for */

   return(-1);
}

static bool linkPoints(frm_Sequence &s, int k,
                       crt_IndividualModel criterion, int verificationLevels,
                       double maxSpeed, double maxPhi)
{
   int i, j;
   int p = 0, q = 0;
   int *points_km;
   int *points_kp;
   int numPoints_km = 0;
   int numPoints_kp = 0;
   bool *valid;

   for (i = 0; i < s.frame[k].len; i++) {
      if (s.frame[k].point[i].state != pnt_Normal) {
         assert(s.frame[k].point[i].backward == -1);
         assert(s.frame[k].point[i].forward == -1);
         continue;
      } /* if */

      if (isBackwardLinked(s, k, i)) {
         singlePoint(s.frame[k].point[i].backward,
                     points_km, numPoints_km);
      } else {
         findPointsInRange(s, k - 1, -1, crt_Forward,
                           s.frame[k].point[i], maxSpeed,
                           points_km, numPoints_km);
      } /* endif */

      if (isForwardLinked(s, k, i)) {
         singlePoint(s.frame[k].point[i].forward,
                     points_kp, numPoints_kp);
      } else {
         findPointsInRange(s, k + 1, -1, crt_Backward,
                           s.frame[k].point[i], maxSpeed,
                        points_kp, numPoints_kp);
      } /* if */

      extendCombinations(points_km, numPoints_km,
                         points_kp, numPoints_kp);

      removeInvalidPointTriplets(s, k, i,
                                 points_km, numPoints_km,
                                 points_kp, numPoints_kp,
                                 criterion, maxSpeed, maxPhi);

      sortPointTriplets(s, k, i,
                        points_km, numPoints_km,
                        points_kp, numPoints_kp,
                        criterion, maxSpeed);

      if (numPoints_km > 0) {
         valid = (bool *) malloc(numPoints_km * sizeof(bool));
         for (j = 0; j < numPoints_km; j++) {
            valid[j] = true;
         } /* for */
      } else {
         valid = NULL;
      } /* if */

      p = q = 0;
      if ((p = checkForwardHypotheses(s, k, i,
                                      points_km, points_kp,
                                      valid, numPoints_km,
                                      verificationLevels, maxSpeed)) >= 0
       && (q = checkBackwardHypotheses(s, k, i,
                                       points_km + p, points_kp + p,
                                       valid + p, numPoints_km - p,
                                       verificationLevels, maxSpeed)) >= 0) {

         /* Fix both directions */

         if (isBackwardLinked(s, k, i)) {
            assert(validBackwardLink(s, k, i));
            assert(backwardLink(s, k, i) == points_km[p + q]);
         } else {
            s.frame[k].point[i].backward = points_km[p + q];
            consolidateBackwardLink(s, k, i);

            // Mark as start-of-track
            assert(s.frame[k - 1].point[points_km[p + q]].state == pnt_Normal);
            s.frame[k - 1].point[points_km[p + q]].state = pnt_Head;
         } /* if */

         if (isForwardLinked(s, k, i)) {
            assert(validForwardLink(s, k, i));
            assert(forwardLink(s, k, i) == points_kp[p + q]);
         } else {
            s.frame[k].point[i].forward = points_kp[p + q];
            consolidateForwardLink(s, k, i);
         } /* if */

      } else if (isBackwardLinked(s, k, i)) {

         assert(validBackwardLink(s, k, i));

         // Mark as end-of-track
         assert(s.frame[k].point[i].state == pnt_Normal);
         s.frame[k].point[i].state = pnt_Tail;

      // else: point not linked
      } /* if */

      if (points_km)
         free(points_km);
      if (points_kp)
         free(points_kp);
      if (valid)
         free(valid);
   } /* for */

   return(true);
}

static void swapPoint(pnt_Point &p1, pnt_Point &p2)
{
   pnt_Point p;

   p = p1; p1 = p2; p2 = p;
}

static void cleanSequence(frm_Sequence &s)
{
   int i, k;

   for (k = 0; k < s.len; k++) {
      for (i = 0; i < s.frame[k].len; i++) {
         if (s.frame[k].point[i].state != pnt_Normal) {
            if (i < s.frame[k].len - 1) {
               memmove(s.frame[k].point + i, s.frame[k].point + i + 1,
                       (s.frame[k].len - i - 1) * sizeof(pnt_Point));
            } /* if */
            s.frame[k].len--;
            i--;
         } /* if */
      } /* for */
   } /* for */
}

static bool findTrackHead(frm_Sequence &s, int k, int i, int maxD,
                          double maxSpeed, double maxPhi,
                          int &d, int &pointLink)
{
   int j;
   double phi, minPhi = maxPhi;

   pointLink = -1;
   for (d = 1; d < maxD && k + d < s.len; d++) {

      for (j = 0; j < s.frame[k + d].len; j++) {

         if ((s.frame[k + d].point[j].state == pnt_Head ||
              s.frame[k + d].point[j].state == pnt_Normal)
          && s.frame[k + d].point[j].backward < 0
          && crt_PointDistance(s.frame[k].point[i], s.frame[k + d].point[j]) < d * maxSpeed) {
            if (s.frame[k].point[i].backward >= 0) {

               crt_SmoothMotion(s.frame[k - 1].point[s.frame[k].point[i].backward], 1,
                            s.frame[k].point[i], d,
                            s.frame[k + d].point[j],
                            maxSpeed, &phi);
               if (phi < minPhi) {
                  minPhi = phi;
                  pointLink = j;
               } /* if */
            } /* if */

            if (s.frame[k + d].point[j].forward >= 0) {
               crt_SmoothMotion(s.frame[k].point[i], d,
                            s.frame[k + d].point[j], 1,
                            s.frame[k + d + 1].point[s.frame[k + d].point[j].forward],
                            maxSpeed, &phi);

               if (phi < minPhi) {
                  minPhi = phi;
                  pointLink = j;
               } /* if */
            } /* if */
         } /* if */
      } /* for */

      if (pointLink >= 0) {
         return(true);
      } /* if */
   } /* for */

   return(false);
}

static void connectTailToHead(frm_Sequence &s, int k, int i, int d, int j)
{
   int di;
   int prev, next;

   prev = i;
   for (di = 1; di < d; di++) {
      next = s.frame[k + di].len++;
      s.frame[k + di].point[next] = EmptyPoint;

// begin-interpolating
      s.frame[k + di].point[next].x =
         s.frame[k].point[i].x +
          di * (s.frame[k + d].point[j].x - s.frame[k].point[i].x) / d;
      s.frame[k + di].point[next].y =
         s.frame[k].point[i].y +
          di * (s.frame[k + d].point[j].y - s.frame[k].point[i].y) / d;
// end-interpolating
      s.frame[k + di].point[next].backward = prev;
      s.frame[k + di - 1].point[prev].forward = next;
      s.frame[k + di].point[next].state = pnt_Estimated;
      prev = next;
   } /* for */

   assert(s.frame[k + d].point[j].backward < 0);
   assert(s.frame[k + d - 1].point[prev].forward < 0);

   s.frame[k + d].point[j].backward = prev;
   s.frame[k + d - 1].point[prev].forward = j;

}

static void connectLooseEnds(frm_Sequence &s, double maxSpeed, double maxPhi)
{
   int d;
   int i, j, k;
   int maxD = 3;

   for (k = 1; k < s.len - 2; k++) { // -2 ?????
      for (i = 0; i < s.frame[k].len; i++) {

         if (s.frame[k].point[i].state == pnt_Normal
          || s.frame[k].point[i].state == pnt_Tail) {

            if (s.frame[k].point[i].forward < 0) {

               if (findTrackHead(s, k, i, maxD, maxSpeed, maxPhi, d, j)) {
                  connectTailToHead(s, k, i, d, j);
               } else {
                  if (s.frame[k].point[i].backward >= 0) {
                     s.frame[k].point[i].state = pnt_Tail;
                  } /* if */
               } /* if */
            } /* if */

            if (s.frame[k].point[i].backward < 0) {
               if (s.frame[k].point[i].forward < 0) {
                  s.frame[k].point[i].state = pnt_Single;
               } else {
                  s.frame[k].point[i].state = pnt_Head;
               } /* if */
            } /* if */
         } /* if */
      } /* for */
   } /* for */

}

static bool reorderAsLinked(frm_Sequence &s, int k)
{
   int i, j;

   for (i = 0; i < s.frame[k].len; i++) {
      if (s.frame[k].point[i].forward >= 0) {
         assert(s.frame[k].point[i].state != pnt_Empty);

         for (j = findLink(s, k, i); j >= 0 && j != i; j = findLink(s, k, i)) {

            assert(s.frame[k + 1].point[i].backward == j);
            swapPoint(s.frame[k + 1].point[i], s.frame[k + 1].point[j]);

            if (MAX(i, j) >= s.frame[k + 1].len) {
               s.frame[k + 1].len = MAX(i, j) + 1;
            } /* if */

            //s.frame[k].point[j].forward = j;
            consolidateBackwardLink(s, k + 1, i);
            consolidateForwardLink(s, k + 1, i);

            consolidateBackwardLink(s, k + 1, j);
            consolidateForwardLink(s, k + 1, j);

            assert(!isForwardLinked(s, k, i) || validForwardLink(s, k, i));
            assert(!isForwardLinked(s, k, j) || validForwardLink(s, k, j));

         } /* for */

         if (j < 0) {
            j = s.frame[k].point[i].forward;
            assert(s.frame[k].point[i].forward >= 0);
            assert(s.frame[k + 1].point[j].backward == i);
            swapPoint(s.frame[k + 1].point[i], s.frame[k + 1].point[j]);
            if (MAX(i, s.frame[k].point[i].forward) >= s.frame[k + 1].len) {
               s.frame[k + 1].len = MAX(i, s.frame[k].point[i].forward) + 1;
            } /* if */

            consolidateBackwardLink(s, k + 1, i);
            consolidateForwardLink(s, k + 1, i);

            consolidateBackwardLink(s, k + 1, j);
            consolidateForwardLink(s, k + 1, j);
         } /* if */

         s.frame[k].point[i].forward = i;
         s.frame[k + 1].point[i].backward = i;

         consolidateBackwardLink(s, k + 1, i);
         consolidateForwardLink(s, k + 1, i);

         assert(!isForwardLinked(s, k, i) || validForwardLink(s, k, i));
         assert(!isForwardLinked(s, k, j) || validForwardLink(s, k, j));
      } /* if */
   } /* for */
   return(true);
}

static void addFrameTracks(frm_Sequence &s, int k,
                           int minTrackLen, trk_TrackList &trackList)
{
   /* pnt_Point list[s.len]; */

   int i, j, len;
   trk_Track track;
   pnt_Point *list;

   list = (pnt_Point *) malloc(s.len * sizeof(pnt_Point));


   for (i = 0; i < s.frame[k].len; i++) {
      if (s.frame[k].point[i].state != pnt_Empty) {
         j = i;
         for (len = 0; k + len < s.len; /* update in body */) {
            if (s.frame[k + len].point[j].state == pnt_Empty) {
               break;
            } /* if */
            list[len] = s.frame[k + len].point[j];
            s.frame[k + len].point[j] = EmptyPoint;

            switch (list[len].state) {
            case pnt_Estimated:
               list[len].state = pnt_Empty;
               break;
            case pnt_Head:
            case pnt_Tail:
               list[len].state = pnt_Normal;
               break;
            default:
               ;
            } /* switch */

            j = list[len++].forward;
            if (j < 0) {
               break;
            } /* if */
         } /* for */
         if (len >= minTrackLen) {
            trk_CreateTrack(track, list, k, len);
            trk_AppendTrack(trackList, track);
         } /* if */
      } /* if */
   } /* for */
}

static void collectTracks(frm_Sequence &s, int objects,
                          int minTrackLen, trk_TrackList &trackList)
{
   int k;
   assert(trackList.track == NULL);

   trk_Create(trackList, trk_MaxTracks);
   for (k = 0; k < s.len - 3; k++) {
      addFrameTracks(s, k, minTrackLen, trackList);
   } /* for */
}

bool tkg_MakeTracks(frm_Sequence &s, int objects,
                    crt_IndividualModel criterion,
                    double maxSpeed, double maxPhi,
                    int maxInterpol, int minPresent,
                    bool verbose,
                    int minTrackLen, trk_TrackList &trackList)
{
   int i, k, len;

   assert(objects > 0);

   cleanSequence(s);

   // Make space for interpolated points
   for (k = 0; k < s.len; k++) {
      len = s.frame[k].len;
      extendPointList(s.frame[k], trk_MaxTracks);

      /* Set all points as nether forward linked nor backward linked */
      for (i = 0; i < s.frame[k].len; i++) {
         s.frame[k].point[i].backward = s.frame[k].point[i].forward = -1;
      } /* for */

      s.frame[k].len = len;
   } /* for */

   for (k = 1; k < s.len - 1; k++) {
      linkPoints(s, k, criterion, VERIFICATION_LEVELS, maxSpeed, maxPhi);

      reorderAsLinked(s, k - 1); /* For track-initiation modifications */
      reorderAsLinked(s, k);
   } /* for */

   connectLooseEnds(s, maxSpeed, maxPhi);

   collectTracks(s, objects, minTrackLen, trackList);
   return(true);
}

