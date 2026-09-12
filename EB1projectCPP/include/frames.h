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


#ifndef FRAMES_HH
#define FRAMES_HH

#define frm_MaxFrames   (1000)

#include "point.h"

typedef struct frame_t {
   int len, maxLen;
   pnt_Point *point;
}  frm_Frame;

typedef struct sequence_t {
   int len, maxLen;
   frm_Frame *frame;
}  frm_Sequence;

static const frm_Sequence frm_EmptySequence = {0, 0, NULL};
static const frm_Frame frm_EmptyFrame = {0, 0, NULL};

/*--------------------------------------------------------------------------*/

bool frm_Create(frm_Sequence &s, int numFrames);

bool frm_Delete(frm_Sequence &s);

void frm_Clear(frm_Sequence &s);

void frm_Copy(frm_Sequence &src, frm_Sequence &dst);

void frm_CopyRaw(frm_Sequence &src, frm_Sequence &dst);


/*--------------------------------------------------------------------------*/

bool frm_CreateFrame(frm_Frame &frame, pnt_Point *list, int len, int maxLen);

bool frm_CreateFrame(frm_Frame &frame, pnt_Point *list, int len);

bool frm_AppendFrame(frm_Sequence &s, frm_Frame &frame);

bool frm_GetFrame(frm_Sequence &s, int i, frm_Frame &frame);

/*--------------------------------------------------------------------------*/

#endif
