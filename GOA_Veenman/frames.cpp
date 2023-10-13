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


#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "frames.h"

bool frm_Create(frm_Sequence &s, int numFrames)
{
   assert((s.maxLen == 0) == (s.frame == NULL));

   s.frame = (frm_Frame *) malloc(numFrames * sizeof(frm_Frame));
   s.maxLen = numFrames;
   s.len = 0;
   return(true);
}

bool frm_Delete(frm_Sequence &s)
{
   int k;

   assert((s.maxLen == 0) == (s.frame == NULL));

   for (k = 0; k < s.len; k++) {
      free(s.frame[k].point);
   } /* for */
   free(s.frame);
   s.frame = NULL;
   s.len = 0;
   s.maxLen = 0;
   return(true);
}

void frm_Copy(frm_Sequence &src, frm_Sequence &dst)
{
   int k;
   frm_Frame frame = frm_EmptyFrame;

   assert((src.maxLen == 0) == (src.frame == NULL));
   assert(src.frame != NULL);

   frm_Delete(dst);
   frm_Create(dst, src.len);

   for (k = 0; k < src.len; k++) {
      frm_CreateFrame(frame, src.frame[k].point, src.frame[k].len);
      frm_AppendFrame(dst, frame);
      frame.point = NULL;
   } /* for */
}

void frm_CopyRaw(frm_Sequence &src, frm_Sequence &dst)
{
   int k;
   frm_Frame frame = {0, NULL};

   assert((src.maxLen == 0) == (src.frame == NULL));
   assert(src.frame != NULL);

   frm_Delete(dst);
   frm_Create(dst, src.len);

   for (k = 0; k < src.len; k++) {
      frm_CreateFrame(frame, src.frame[k].point,
                      src.frame[k].len, src.frame[k].maxLen);
      frm_AppendFrame(dst, frame);
      frame.point = NULL;
   } /* for */
}

bool frm_CreateFrame(frm_Frame &frame, pnt_Point *list, int len, int maxLen)
{
   int i;

   assert(frame.point == NULL);
   assert(maxLen >= len);
   if (maxLen > 0) {
      frame.point = (pnt_Point *) malloc(maxLen * sizeof(pnt_Point));
      assert(frame.point != NULL);
      memcpy(frame.point, list, len * sizeof(pnt_Point));
      for (i = len; i < maxLen; i++) {
         frame.point[i] = EmptyPoint;
      } /* for */
   } /* if */
   frame.len = len;
   frame.maxLen = maxLen;
   return(true);

}

bool frm_CreateFrame(frm_Frame &frame, pnt_Point *list, int len)
{
   return(frm_CreateFrame(frame, list, len, len));
}

bool frm_AppendFrame(frm_Sequence &s, frm_Frame &frame)
{
   if (s.len < s.maxLen) {
      s.frame[s.len++] = frame;
      return(true);
   } /* if */
   assert(false);
   return(false);
}

bool frm_GetFrame(frm_Sequence &s, int i, frm_Frame &frame)
{
   assert(0 <= i && i < s.len);

   frame = s.frame[i];
   return(true);
}

