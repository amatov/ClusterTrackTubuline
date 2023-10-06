#include <stdlib.h>
#include <malloc.h>
#include <string.h>

#include "point.h"
#include "frames.h"

extern void extendPointList(frm_Frame &pointList, int newLen)
{
    int i;
    pnt_Point *points;

    if (newLen > pointList.len) {
        points = (pnt_Point *) malloc(newLen * sizeof(pnt_Point));
        memcpy(points, pointList.point, pointList.len * sizeof(pnt_Point));
        for (i = pointList.len; i < newLen; i++) {
            points[i].state = pnt_Empty;
            points[i].x = points[i].y = 0.0;
			points[i].intensity = -1;
			points[i].area = -1;
		    points[i].frameID = -1;
        } /* endfor */
        free(pointList.point);
        pointList.point = points;  /* Now point to the new memory module */
        pointList.len = newLen;    /* Change the length record */
    } /* endif */
}

extern void cleanSequence(frm_Sequence &s)
{

/* This function removes EMPTY points from the entire sequence s */
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
