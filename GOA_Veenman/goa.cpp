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

        Main module of the GOA tracker as described in the following
        publication:

            C.J. Veenman, M.J.T. Reinders, and E. Backer, 'Resolving
            Motion Correspondence for Densely Moving Points'. IEEE
            Transactions on Pattern Analysis and Machine Intelligence,
            vol. 23, no. 1, pp. 54-72, Januari 2001

        Remark: This implementation uses the algorithm for solving a
                linear assignment problem by Jonker and Volgenant instead
                of the hungarian algorithm.


*****************************************************************************/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <float.h>
#include <assert.h>

#include "tracking.h"
#include "criterion.h"
#include "lap_1_0.h"

#define DEBUG





static inline bool Greater(double a, double b)
{
   return(a - b > FLT_EPSILON);
}

static bool computeTrackStats(frm_Sequence &s, int objects,
                              crt_IndividualModel criterion,
                              double maxPhi,
                              double &phiMax, double &phiTot)
{
   PhiInterpol phi = crt_CriterionInterpol(criterion);
   int i, kk, k, delta = 1;
   double diik;

   phiMax = phiTot = 0.0;

   for (kk = 1; kk < s.len - 1; kk++) {

      k = kk;

      for (i = 0; i < objects; i++) {
         if (s.frame[k + delta].point[i].state == pnt_Normal
          && phi(s, k, i, crt_Forward, s.frame[k + delta].point[i],
                 DBL_MAX, &diik)) {
            if (Greater(diik, phiMax)) {
               phiMax = diik;
            } /* endif */
            phiTot += diik;
         } /* endif */
      } /* endfor */
   } /* endfor */
   return(true);
}

#define inf (1000000)


static void buildBipartiteGraph(frm_Sequence &s, int k, int objects,
                                int order, crt_IndividualModel criterion,
                                crt_Direction dir,
                                double maxSpeed, double maxPhi,
                                double cc[], int kk[], int first[])
{
   PhiInterpol phi = crt_CriterionInterpol(criterion);
   int delta = dir == crt_Forward ? 1 : -1;
   int i, j, p;
   double cost;
   int numLinks = 0;

   for (i = 0; i < objects; i++) {
      first[i + 1] = numLinks + 1;
      for (j = 0; j < s.frame[k + delta].len; j++) {
         if (s.frame[k + delta].point[j].state == pnt_Normal
          && phi(s, k, i, dir, s.frame[k + delta].point[j],
                 maxSpeed, &cost)
          && !Greater(cost, maxPhi)) {
            cc[++numLinks] = cost;
            kk[numLinks] = j + 1;
         } else {
            //fprintf(stderr, "*******\n");
         } /* if */

      } /* for */
      cc[++numLinks] = maxPhi;
      kk[numLinks] = s.frame[k + delta].len + i + 1;
   } /* for */

   first[i + 1] = numLinks + 1;

   for (i = 0; i < s.frame[k + delta].len; i++) {
      first[objects + i + 1] = numLinks + 1;
      cc[++numLinks] = maxPhi;
      kk[numLinks] = i + 1;
      for (j = 0; j < objects; j++) {
         for (p = first[j + 1]; p < first[j + 2] - 1; p++) {// skip slave node
            if (kk[p] == i + 1) {
               cc[++numLinks] = 0;
               kk[numLinks] = s.frame[k + delta].len + j + 1;
            } /* if */
         } /* for */
      } /* for */
   } /* for */

   first[objects + i + 1] = numLinks + 1;

}

/*
 * Algorithm for solving the linear assignment problem as
 * downloaded from http://www.magiclogic.com/assignment.html. The
 * algorithm is described in:
 *
 *    R. Jonker and A. Volgenant (University of Amsterdam) "A Shortest
 *    Augmenting Path Algorithm for Dense and Sparse Linear Assignment
 *    Problems", Computing 38, 325-340 (1987).
 */
static double lap(int n, const double cc[], const int kk[], const int first[],
                  int x[], int y[], double u[], double v[])
{
   int h, i,j,k,l,t,last,tel,td1=0,td2,i0,j0=0,j1=0,l0;
/* int lab[n + 2], freeRow[n + 2], todo[n + 2];
   bool ok[n + 1];
   double min, v0, vj, dj, tmp, d[n + 2];  commented out by GY*/

   int *lab, *freeRow, *todo;
   bool *ok;
   double min, v0, vj, dj, tmp;
   double *d;


   ok = (bool *) malloc((n+1) * sizeof(bool));
   lab = (int *)malloc((n+2)*sizeof(int));
   freeRow = (int *)malloc((n+2)*sizeof(int));
   todo = (int *)malloc((n+2)*sizeof(int));

   d = (double *)malloc((n+2)*sizeof(double));
     
   /* Initialize */
   for (j = 1; j <= n; j++) {
      v[j] = inf;
   } /* for */

   for (i = 1; i <= n; i++) {
      x[i] = 0; u[i] = 0;
      for (t = first[i]; t < first[i+1]; t++) {
         j = kk[t];
         if (cc[t] < v[j]) {
            v[j] = cc[t];
            y[j] = i;
         } /* if */
      } /* for */
   } /* for */

   for (j = n; j >= 1; j--) {
      i = y[j];
      if (x[i] == 0) {
         x[i] = j;
      } else {
         y[j] = 0;
         x[i] = -abs(x[i]);
      } /* if */
   } /* for */

   l = 0;
   for (i = 1; i <= n; i++) {
      if (x[i] < 0) {
         x[i] = -x[i];
      } else if (x[i] > 0) {
         min = inf;
         j1 = x[i];
         for (t = first[i]; t < first[i+1]; t++) {
            j = kk[t];
            if (j != j1 && cc[t] - v[j] < min) {
               min = cc[t] - v[j];
            } /* if */
         } /* for */
         u[i] = min;
         t = first[i];
         while (kk[t] != j1) {
            t++;
         } /* while */
         v[j1] = cc[t] - min;
      } else {
         freeRow[++l] = i;
      } /* if */
   } /* for */

   /* Improve initial solution */
   for (tel = 0; tel < 2; tel++) {
      h = 1;
      l0 = l;
      l = 0;
      while (h <= l0) {
         i = freeRow[h++];
         v0 = vj = inf;

         for (t = first[i]; t < first[i+1]; t++) {

            j = kk[t];
            dj = cc[t] - v[j];
            if (dj < vj) {
               if (dj >= v0) {
                  vj = dj;
                  j1 = j;
               } else {
                  vj = v0;
                  v0 = dj;
                  j1 = j0;
                  j0 = j;
               } /* if */
            } /* if */
         } /* for */

         i0 = y[j0];
         u[i] = vj;
         if (vj - v0 > FLT_EPSILON) {
            v[j0] = v[j0] - vj + v0;
         } else if (i0 > 0) {
            j0 = j1;
            i0 = y[j0];
         } /* if */

         x[i] = j0;
         y[j0] = i;

         if (i0 > 0) {
            if (vj - v0 > FLT_EPSILON) {
               freeRow[--h] = i0;
            } else {
               freeRow[++l] = i0;
            } /* if */
         } /* if */
      } /* while */
   } /* for */

   tmp = 0;
   for (i = 1; i <= n; i++) {
      tmp += u[i] + v[i];
   } /* for */

   /* Augmentation part */
   l0 = l;
   for (l = 1; l <= l0; l++) {

      for (j = 1; j <= n; j++) {
         d[j] = inf;
         ok[j] = false;
      } /* for */

      min = inf; i0 = freeRow[l];

      for (t = first[i0]; t < first[i0+1]; t++) {
         j = kk[t];
         dj = cc[t] - v[j];
         d[j] = dj;
         lab[j] = i0;

         if (dj <= min) {
            if (dj < min) {
               td1 = 0;
               min = dj;
            } /* if */
            todo[++td1] = j;
         } /* if */
      } /* for */

      for (h = 1; h <= td1; h++) {
         j = todo[h];
         if (y[j] == 0) {
            goto label2;
         } /*if */
         ok[j] = true;
      } /* for */

      td2 = n;
      last = n + 1;

      /* Repeat until a freeRow row found */
      while (true) {
         j0 = todo[td1--];
         i = y[j0];
         todo[td2--] = j0;
         t = first[i];

         for (t = first[i]; kk[t] != j0; t++) {
            /* nothing */
         } /* for */

         tmp = cc[t] - v[j0] - min;

         for (t = first[i]; t < first[i+1]; t++) {
            j = kk[t];
            if (!ok[j]) {
               vj = cc[t] - v[j] - tmp;
               if (vj < d[j]) {
                  d[j] = vj;
                  lab[j] = i;
                  if (vj == min) {
                     if (y[j] == 0) {
                        goto label1;
                     } /* if */
                     td1++;
                     todo[td1] = j;
                     ok[j] = true;
                  } /* if */
               } /* if */
            } /* if */
         } /* for */
         if (td1 == 0) {
            min = inf - 1;
            last = td2 + 1;
            for (j = 1; j <= n; j++) {
               if (d[j] <= min) {
                  if (!ok[j]) {
                     if (d[j] < min) {
                        td1 = 0;
                        min = d[j];
                     } /* if */
                     todo[++td1] = j;
                  } /* if */
               } /* if */
            } /* for */
            for (h = 1; h <= td1; h++) {
               j = todo[h];
               if (y[j] == 0) {
                  goto label1;
               } /* if */
               ok[j] = true;
            } /* for */
         } /* if */
      } /* while */
label1:
      for (k = last; k <= n; k++) {
         j0 = todo[k];
         v[j0] += d[j0] - min;
      } /* for */

label2:
      do {
         i = lab[j];
         y[j] = i;
         k = j;
         j = x[i];
         x[i] = k;
      } while (i != i0);
   } /* for */

   tmp = 0;
   for (i = 1; i <= n; i++) {
      j  = x[i];
      t = first[i];
      while (kk[t] != j) {
         t++;
      } /* while */

      u[i] = cc[t] - v[j];
      tmp += cc[t];
   } /* for */
   return(tmp);
}


static bool GreedyAssign(frm_Sequence &s, int frames, int objects,
                         crt_IndividualModel criterion,
                         double maxSpeed, double maxPhi,
                         int maxInterpol, int minPresent,
                         crt_Direction dir)
{
   int i, k, kk;
   int order = crt_CriterionOrder(criterion);
   bool changed = false;
   int delta;

   assert(order > 0);

   delta = dir == crt_Forward ? 1 : -1;

   for (kk = order - 1; kk < frames - 1; kk++) {
      k = dir == crt_Forward ? kk : frames - kk - 1;

	  //fprintf(stdout, "k = % d  objects = %d  frame length = %d \n", k, objects, s.frame[k].len);
      
	  
	  if (objects > s.frame[k].len)
         s.frame[k].len = objects;      /* This will keep the number of points constant */

      int size = objects + s.frame[k + delta].len;

	  fprintf(stdout, "\nsize = %d\n\n", size);

      double  *cc = new double[size * size + 1];

      int *col = new int[size * size + 1];
      int *first = new int[size + 2];
      int *x = new int[size + 1];
      int *y = new int[size + 1];
      double *u = new double[size + 1];
      double *v = new double[size + 1];

	  /* pnt_Point points[s.frame[k + delta].len]; */
	  //points = (pnt_Point *) malloc(s.frame[k + delta].len * sizeof(pnt_Point));

	  pnt_Point *points = new pnt_Point[s.frame[k + delta].len];;
	  

	  




      buildBipartiteGraph(s, k, objects, order, criterion, dir,
                          maxSpeed, maxPhi, cc, col, first);

      lap(size, cc, col, first, x, y, u, v); 
	  //lap_1_0(size, cc, x, y, u, v); 

     

      memcpy(points, s.frame[k + delta].point, s.frame[k + delta].len * sizeof(pnt_Point));

      for (i = 0; i < objects; i++) {
	  //for (i = 0; i < s.frame[k].len; i++) {
		 if (x[i + 1] <= s.frame[k + delta].len) {
            s.frame[k + delta].point[i] = points[x[i + 1] - 1];
         } else {
            s.frame[k + delta].point[i] = EmptyPoint;
         } /* if */
      } /* for */

      int len = objects;
	  //int len = s.frame[k].len;

      for (i = 0; i < s.frame[k + delta].len; i++) {
          if (y[i + 1] > objects) {
          //if (y[i + 1] > s.frame[k].len) {
            s.frame[k + delta].point[len++] = points[i];
         } /* if */
      } /* for */

      s.frame[k + delta].len = len;

      delete[] cc;
      delete[] col;
      delete[] first;
      delete[] x;
      delete[] y;
      delete[] u;
      delete[] v;

   } /* endfor */

   return(changed);
}


static bool AssignBidir(frm_Sequence &s, int frames, int objects,
                         crt_IndividualModel criterion,
                         double maxSpeed, double maxPhi,
                         int maxInterpol, int minPresent)
{
   /* Optimize in UP direction */

   fprintf(stdout, "In AssignBidir frames = %d   objects = %d\n", frames, objects);

   GreedyAssign(s, frames, objects, criterion,
                maxSpeed, maxPhi, maxInterpol, minPresent,
                crt_Forward);

   /* Optimize in DOWN direction */
   GreedyAssign(s, frames, objects, criterion,
                maxSpeed, maxPhi, maxInterpol, minPresent,
                crt_Backward);

   return(true);
}


static void extendPointList(frm_Frame &pointList, int newLen)
{
   int i;
   pnt_Point *points;

   if (newLen > pointList.len) {
      points = (pnt_Point *) malloc(newLen * sizeof(pnt_Point));
      memcpy(points, pointList.point, pointList.len * sizeof(pnt_Point));
      for (i = pointList.len; i < newLen; i++) {
         points[i].state = pnt_Empty;
         points[i].x = points[i].y = 0.0;
      } /* endfor */
      free(pointList.point);
      pointList.point = points;
      pointList.len = newLen;
   } /* endif */
}

static void cleanSequence(frm_Sequence &s)
{
   int i, k;

   for (k = 0; k < s.len; k++) {
      for (i = 0; i < s.frame[k].len; i++) {
         if (s.frame[k].point[i].state == pnt_Empty) {
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



static void addRowTracks(frm_Sequence &s, int row,
                         int minTrackLen, trk_TrackList &trackList)
{
   int k;
   /* pnt_Point list[s.len]; */
   trk_Track track;

   pnt_Point *list;

#ifdef DEBUG
   fprintf(stdout, "---------s.len = %d-----------\n", s.len);
#endif


   list = (pnt_Point *) malloc (s.len * sizeof(pnt_Point));

   if (s.frame[0].point[row].state == pnt_Normal
    && s.frame[s.len - 1].point[row].state == pnt_Normal) {
      for (k = 0; k < s.len; k++) {
         list[k] = s.frame[k].point[row];
      } /* for */
      trk_CreateTrack(track, list, 0, s.len);
      trk_AppendTrack(trackList, track);
   } /* if */
}









/************************ addRowTracks_BD ******************************/

static void addRowTracks_BD(frm_Sequence &s, int row,
                         int minTrackLen, trk_TrackList &trackList)
{
   int k;
   /* pnt_Point list[s.len]; */
   trk_Track track;

   pnt_Point *list;

#ifdef DEBUG
//   fprintf(stdout, "---------s.len = %d-----------\n", s.len);
#endif


   list = (pnt_Point *) malloc (s.len * sizeof(pnt_Point));

   if (s.frame[0].point[row].state == pnt_Normal
    && s.frame[s.len - 1].point[row].state == pnt_Normal) {
      for (k = 0; k < s.len; k++) {
         list[k] = s.frame[k].point[row];
      } /* for */
      trk_CreateTrack(track, list, 0, s.len);
      trk_AppendTrack(trackList, track);
   } /* if */
}


/******************* End of addRowTracks_BD ****************************/


static void collectTracks(frm_Sequence &s, int objects,
                          int minTrackLen, trk_TrackList &trackList)
{
   int i;
   assert(trackList.track == NULL);

   trk_Create(trackList, trk_MaxTracks);
   for (i = 0; i < trk_MaxTracks; i++) {
      addRowTracks_BD(s, i, minTrackLen, trackList);
   } /* for */
}


bool tkg_MakeTracks(frm_Sequence &s, int objects,
	            crt_IndividualModel criterion,
                    double maxSpeed, double maxPhi,
                    int maxInterpol, int minPresent,
                    bool verbose,
                    int minTrackLen, trk_TrackList &trackList)
{
   int k, len;

   /* int i; */

   assert(objects > 0);

   cleanSequence(s);

   // Make space for interpolated points
   for (k = 0; k < s.len; k++) {
      len = s.frame[k].len;
      extendPointList(s.frame[k], trk_MaxTracks);
      s.frame[k].len = len;

#ifdef DEBUG
	  fprintf(stdout, "# of points in frame %d is %d\n", k, len);
#endif 
   } /* for */   

   /* It should be OK to leave this extension as it is. This is because eventually we need to add certain 
      virtual points. Even if not, it is still OK to have some extra space just in case. 


   /* Initialise first frames */
   GreedyAssign(s, 2, objects,
                crt_ShortestPathIndex,
                maxSpeed, maxSpeed, maxInterpol, minPresent, crt_Forward);

   AssignBidir(s, s.len, objects,
               criterion,
               maxSpeed, maxPhi, maxInterpol, minPresent);

   collectTracks(s, objects, minTrackLen, trackList);

   return(true);
}



/* ****************************** tkg_MakeTracks_BD  ********************************** */  

/* Here we will NOT give the number of objects. */


bool tkg_MakeTracks_BD(frm_Sequence &s, 
	                crt_IndividualModel criterion,
                    double maxSpeed, double maxPhi,
                    int maxInterpol, int minPresent,
                    bool verbose,
                    int minTrackLen, trk_TrackList &trackList)

					
{
   int k, len;

   /* int i; */

   //assert(objects > 0);

   cleanSequence(s);

   // Make space for interpolated points  /* GY: this is fine and can be kept. */
   for (k = 0; k < s.len; k++) {
      len = s.frame[k].len;
      extendPointList(s.frame[k], trk_MaxTracks);
      s.frame[k].len = len;
	  fprintf(stdout, "# of points in frame %d is %d\n", k, len);
   } /* for */   

   /* It should be OK to leave this extension as it is. This is because eventually we need to add certain 
      virtual points. Even if not, it is still OK to have some extra space just in case. 


   /* Initialise first frames */

   return(true);

   GreedyAssign_BD(s, 2, 
                crt_ShortestPathIndex,
                maxSpeed, maxSpeed, maxInterpol, minPresent, crt_Forward);

   AssignBidir_BD(s, s.len, 
               criterion,
               maxSpeed, maxPhi, maxInterpol, minPresent);

   collectTracks_BD(s, minTrackLen, trackList);

   return(true);
}

/* **************************  end of  tkg_MakeTracks_BD  ***************************** */







/* ****************************** AssignBidir_BD  ********************************** */  


static bool AssignBidir_BD(frm_Sequence &s, int frames, 
                         crt_IndividualModel criterion,
                         double maxSpeed, double maxPhi,
                         int maxInterpol, int minPresent)
{
   /* Optimize in UP direction */

   int objects;

   fprintf(stdout, "In AssignBidir frames = %d   objects = %d\n", frames, objects);

   GreedyAssign_BD(s, frames, criterion,
                maxSpeed, maxPhi, maxInterpol, minPresent,
                crt_Forward);

   /* Optimize in DOWN direction */
   GreedyAssign_BD(s, frames, criterion,
                maxSpeed, maxPhi, maxInterpol, minPresent,
                crt_Backward);

   return(true);
}

/* **************************  end of AssignBidir_BD  ***************************** */

/* **************************  GreedyAssign_BD  ***************************** */

static bool GreedyAssign_BD(frm_Sequence &s, int frames, 
                         crt_IndividualModel criterion,
                         double maxSpeed, double maxPhi,
                         int maxInterpol, int minPresent,
                         crt_Direction dir)
{
   int i, k, kk;
   int order = crt_CriterionOrder(criterion);
   bool changed = false;
   int delta;


   int objects;

   assert(order > 0);

   delta = dir == crt_Forward ? 1 : -1;

   for (kk = order - 1; kk < frames - 1; kk++) {
      k = dir == crt_Forward ? kk : frames - kk - 1;

	  //fprintf(stdout, "k = % d  objects = %d  frame length = %d \n", k, objects, s.frame[k].len);
      
	  
	  if (objects > s.frame[k].len)
         s.frame[k].len = objects;      /* This will keep the number of points constant */

      int size = objects + s.frame[k + delta].len;

	  fprintf(stdout, "\nsize = %d\n\n", size);

      double  *cc = new double[size * size + 1];

      int *col = new int[size * size + 1];
      int *first = new int[size + 2];
      int *x = new int[size + 1];
      int *y = new int[size + 1];
      double *u = new double[size + 1];
      double *v = new double[size + 1];

	  /* pnt_Point points[s.frame[k + delta].len]; */

	  pnt_Point *points;


      buildBipartiteGraph(s, k, objects, order, criterion, dir,
                          maxSpeed, maxPhi, cc, col, first);

      lap(size, cc, col, first, x, y, u, v); 
	  //lap_1_0(size, cc, x, y, u, v); 

      points = (pnt_Point *) malloc(s.frame[k + delta].len * sizeof(pnt_Point));

      memcpy(points, s.frame[k + delta].point, s.frame[k + delta].len * sizeof(pnt_Point));

      for (i = 0; i < objects; i++) {
         if (x[i + 1] <= s.frame[k + delta].len) {
            s.frame[k + delta].point[i] = points[x[i + 1] - 1];
         } else {
            s.frame[k + delta].point[i] = EmptyPoint;
         } /* if */
      } /* for */

      int len = objects;

      for (i = 0; i < s.frame[k + delta].len; i++) {
         if (y[i + 1] > objects) {
            s.frame[k + delta].point[len++] = points[i];
         } /* if */
      } /* for */

      s.frame[k + delta].len = len;

      delete[] cc;
      delete[] col;
      delete[] first;
      delete[] x;
      delete[] y;
      delete[] u;
      delete[] v;

   } /* endfor */

   return(changed);
}


/* **************************  end of GreedyAssign_BD  ***************************** */


/* **************************  collectTracks_BD  ***************************** */


static void collectTracks_BD(frm_Sequence &s, 
                          int minTrackLen, trk_TrackList &trackList)
{
   int i;

   int objects; 

   assert(trackList.track == NULL);

   trk_Create(trackList, trk_MaxTracks);
   for (i = 0; i < objects; i++) {
      addRowTracks(s, i, minTrackLen, trackList);
   } /* for */
}
/* **********************  end of collectTracks_BD  ************************** */