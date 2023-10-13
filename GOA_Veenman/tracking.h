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

#ifndef TRACKING_HH
#define TRACKING_HH

#include "frames.h"
#include "tracks.h"
#include "criterion.h"

#define tkg_MaxObjects     (trk_MaxTracks)
#define tkg_MaxSequenceLen (1000)

#ifndef MIN
   #define MIN(a, b)       ((a) < (b) ? (a) : (b))
   #define MAX(a, b)       ((a) > (b) ? (a) : (b))
#endif

bool tkg_MakeTracks(frm_Sequence &s, int objects,
					crt_IndividualModel criterion,
                    double maxSpeed, double maxPhi,
                    int maxInterpol, int minPresent,
                    bool verbose,
                    int minTrackLen, trk_TrackList &trackList);

#endif

static bool GreedyAssign_BD(frm_Sequence &s, int frames, 
                         crt_IndividualModel criterion,
                         double maxSpeed, double maxPhi,
                         int maxInterpol, int minPresent,
                         crt_Direction dir);

static bool AssignBidir_BD(frm_Sequence &s, int frames, 
                         crt_IndividualModel criterion,
                         double maxSpeed, double maxPhi,
                         int maxInterpol, int minPresent);

static void collectTracks_BD(frm_Sequence &s, 
                          int minTrackLen, trk_TrackList &trackList);

bool tkg_MakeTracks_BD(frm_Sequence &s, 
	                crt_IndividualModel criterion,
                    double maxSpeed, double maxPhi,
                    int maxInterpol, int minPresent,
                    bool verbose,
                    int minTrackLen, trk_TrackList &trackList);
