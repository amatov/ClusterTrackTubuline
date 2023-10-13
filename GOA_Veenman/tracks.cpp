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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <float.h>

#include "tracks.h"
#include "criterion.h"

bool trk_Create(trk_TrackList &trackList, int numTracks)
{
   trackList.track = (trk_Track *) malloc(numTracks * sizeof(trk_Track));
   trackList.maxNum = numTracks;
   trackList.num = 0;
   return(true);
}

bool trk_Delete(trk_TrackList &trackList)
{
   int i;

   for (i = 0; i < trackList.num; i++) {
      free(trackList.track[i].point);
   } /* for */
   free(trackList.track);
   trackList.track = NULL;
   trackList.num = 0;
   trackList.maxNum = 0;
   return(true);
}


bool trk_CreateTrack(trk_Track &track, pnt_Point *list, int first, int len)
{
   track.point = (pnt_Point *) malloc(len * sizeof(pnt_Point));
   memcpy(track.point, list, len * sizeof(pnt_Point));
   track.first = first;
   track.len = len;
   return(true);
}

bool trk_DeleteTrack(trk_Track &track)
{
   assert(track.point != NULL);
   free(track.point);
   track.point = NULL;
   track.len = 0;
   return(true);
}

bool trk_AppendTrack(trk_TrackList &trackList, trk_Track &track)
{
   //(stderr, "num: %d max: %d\n", trackList.num, trackList.maxNum);
   assert(trackList.num < trackList.maxNum);

   if (trackList.num < trackList.maxNum) {
      trackList.track[trackList.num++] = track;
      return(true);
   } /* if */
   fprintf(stderr, "Could not add track (%d exceeded)\n", trackList.maxNum);
   return(false);
}

bool trk_UpdateTrack(trk_TrackList &trackList, int i, trk_Track &track)
{
   assert(0 <= i && i < trackList.num);
   trk_DeleteTrack(trackList.track[i]);
   trackList.track[i] = track;
   return(true);
}

bool trk_GetTrack(trk_TrackList &trackList, int i, trk_Track &track)
{
   assert(0 <= i && i < trackList.num);

   track = trackList.track[i];
   return(true);
}

bool trk_RemoveTrack(trk_TrackList &trackList, int i)
{
   if (0 <= i && i < trackList.num) {
      free(trackList.track[i].point);
      memmove(trackList.track + i, trackList.track + i + 1,
              (trackList.num-- - i) * sizeof(trk_Track));
      return(true);
   } /* if */
   return(false);
}

typedef int (*QSCMP)(const void *, const void*);

static int cmpTrack(const trk_Track *t1, const trk_Track *t2)
{
   double x;

   if (t1->first == t2->first) {
      if (t1->len == t2->len) {
         if (t1->point->x == t2->point->x) {
            x = t1->point->y - t2->point->y;
            return(x == 0.0 ? 0 : (x < 0 ? -1 : 1));
         } else {
            x = t1->point->x - t2->point->x;
            return(x == 0.0 ? 0 : (x < 0 ? -1 : 1));
         } /* if */
      } else {
         return(t2->len - t1->len);
      } /* if */
   } else {
      return(t1->first - t2->first);
   } /* if */
}

void trk_Sort(trk_TrackList &trackList)
{
   qsort(trackList.track, trackList.num, sizeof(trk_Track), (QSCMP) cmpTrack);
}

void trk_PrintTrack(FILE *f, trk_Track &track)
{
   int i;

   for (i = 0; i < track.first; i++) {
      fprintf(f, "        ");
   } /* for */

   for (i = 0; i < track.len; i++) {
      fprintf(f, "(%2d %2d) ",
              (int) track.point[i].x, (int) track.point[i].y);
   } /* for */
   fprintf(f, "\n");
}

void trk_Print(FILE *f, trk_TrackList &trackList)
{
   int i;

   fprintf(f, "----------------\n");
   for (i = 0; i < trackList.num; i++) {
      trk_PrintTrack(f, trackList.track[i]);
   } /* for */
   fprintf(f, "----------------\n");
}


double trk_SmoothnessTrack(trk_Track &track, double maxPhi)
{
   int i = 0;
   int d1, d2, k = 0;
   double crit, s = 0.0;
   pnt_Point p1, p2, p3;

   while (k < track.len) {
      i = k;
      d1 = d2 = 1;
      while (i < track.len && track.point[i].state == pnt_Empty) {
         d1++; i++;
      } /* while */
      if (i < track.len && track.point[i].state != pnt_Empty) {
         p1 = track.point[i];
      } else {
         break;
      } /* if */
      k = ++i;
      while (i < track.len && track.point[i].state == pnt_Empty) {
         d2++; i++;
      } /* while */
      if (i < track.len && track.point[i].state != pnt_Empty) {
         p2 = track.point[i];
      } else {
         break;
      } /* if */
      i++;
      while (i < track.len && track.point[i].state == pnt_Empty) {
         i++;
      } /* while */
      if (i < track.len && track.point[i].state != pnt_Empty) {
         p3 = track.point[i];
      } else {
         break;
      } /* if */

      crt_SmoothMotion(p1, d1, p2, d2, p3, FLT_MAX, &crit);
      s += crit + (d1 + d2 - 2) * maxPhi;

   } /* for */
   return(s);
}

double trk_Smoothness(trk_TrackList &trackList, double maxPhi)
{
   int i;
   double s = 0.0;

   for (i = 0; i < trackList.num; i++) {
      s += trk_SmoothnessTrack(trackList.track[i], maxPhi);
   } /* for */
   return(s);
}
