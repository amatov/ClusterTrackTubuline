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


#ifndef TRACKS_HH
#define TRACKS_HH

#include "point.h"


typedef struct track_t {
   int first, len;
   pnt_Point *point;
}  trk_Track;

typedef struct tracklist_t {
   int num, maxNum;
   trk_Track *track;
}  trk_TrackList;


static const trk_TrackList trk_EmptyTrackList = {0, 0, NULL};

static const trk_Track trk_EmptyTrack = {0, 0, NULL};

/*--------------------------------------------------------------------------*/

bool trk_Create(trk_TrackList &trackList, int numTracks);

bool trk_Delete(trk_TrackList &trackList);

void trk_Sort(trk_TrackList &trackList);

void trk_Print(FILE *f, trk_TrackList &trackList);

double trk_Smoothness(trk_TrackList &trackList, double maxPhi);

int cmpTrack(const trk_Track *t1, const trk_Track *t2);

/*--------------------------------------------------------------------------*/

bool trk_CreateTrack(trk_Track &track, pnt_Point *list, int first, int len);

bool trk_AppendTrack(trk_TrackList &trackList, trk_Track &track);

bool trk_GetTrack(trk_TrackList &trackList, int i, trk_Track &track);

bool trk_UpdateTrack(trk_TrackList &trackList, int i, trk_Track &track);

bool trk_DeleteTrack(trk_TrackList &trackList, int i);

void trk_PrintTrack(FILE *f, trk_Track &track);

void trk_Print(FILE *f, trk_TrackList &trackList);

double trk_SmoothnessTrack(trk_Track &track, double maxPhi);


/*--------------------------------------------------------------------------*/


#endif
