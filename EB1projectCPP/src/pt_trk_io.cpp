#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <math.h>
#include <float.h>
#include <assert.h>
#include <malloc.h>

#include "main_const.h"
#include "point.h"
#include "frames.h"
#include "tracking.h"


static int fnextc(FILE *f)
{
   int c = fgetc(f);
   ungetc(c, f);
   return(c);
}

static void fskipline(FILE *f)
{
   int c;

   while (c = fgetc(f), c != '\n' && c != EOF);
}


static void fskipspaces(FILE *f)
{
   while (isspace(fnextc(f))) {
      fgetc(f);
   } /* endwhile */
}


extern bool readPoint(FILE *f, pnt_Point *point, int frameID, int pointReadMode)
{
   int i;

   fskipspaces(f);
   switch (fnextc(f)) {
   case '(':
      fgetc(f);
      fskipspaces(f);
      point->state = pnt_Normal;
	  point->frameID = frameID;
      fskipspaces(f);

	  if (pointReadMode == 3) {
		  assert(fscanf(f, "%f %f %f", &point->x, &point->y, &point->intensity) == 3);
	  }

      if (pointReadMode == 4) { /* look for area information */
		  assert(fscanf(f, "%f %f %f %f", &point->x, &point->y, &point->intensity, &point->area) == 4);
	  }

	  if (pointReadMode == 5) { /* look for area information */
		  assert(fscanf(f, "%f %f %f %f", &point->x, &point->y, &point->intensity, &point->area) == 4);
		  for (i= 0; i <= (MAX_POINT_FEATURE_DIM - 1); i++) {
			  assert(fscanf(f, "%f", &(point->otherFeatures[i]))== 1);
		  }
	  }
      fskipspaces(f);
      assert(fgetc(f) == ')');
      return(true);
   case '.':
      fskipline(f);
      return(false);
   case EOF:
      return(false);
   default:
      fprintf(stderr, "char: %c\n", fnextc(f));
      assert(0);
   } /* endswitch */
   return(false);
}

extern bool readPointList(FILE *f, frm_Frame *points, int frameID, int pointReadMode)
{
   int len_local = 0;
   pnt_Point *list;
   
   list = new pnt_Point[MAX_PTNUM_IN_FILEREADING];  /* list is the buffer that saves point coordinates temporarily. */

   fskipspaces(f);

   if (feof(f)) {
      return(false);
   } /* endif */

   while (len_local < MAX_PTNUM_IN_FILEREADING) { 
      if (readPoint(f, list + len_local, frameID, pointReadMode))
		  len_local++;
	  else
		  break;
   } /* endwhile */

   points->len = len_local;
   points->point = (pnt_Point *) malloc(len_local * sizeof(pnt_Point));
   memcpy(points->point, list, len_local * sizeof(pnt_Point));

   delete [] list;
   return(true);
}




extern bool readSequence(FILE *f, int pointReadMode, frm_Sequence *sequence)
{
   int len = 0;
   frm_Frame *list;/* array of frames */

   list = new frm_Frame[tkg_MaxFrameNum];

   while (len < tkg_MaxFrameNum) {
//      if (verbose)
#ifdef DEBUG
//         fprintf(stderr, "%d points in frame %d\n", list[len].len, len);
#endif

/* Remember, here each element in list only contains the head pointer to the array of points. Therefore, the
   size of each element is constant. 
   
   Since there is no need to copy coordinates of points, this is also efficient.
*/
      if  (readPointList(f, list + len, len, pointReadMode))
		  len++;  /* Keep on reading */
	  else
		  break;  /* no more points coming in. So done. */

   } /* endwhile */
   sequence->len = sequence->maxLen = len;
   sequence->frame = (frm_Frame *) malloc(len * sizeof(frm_Frame));
   memcpy(sequence->frame, list, len * sizeof(frm_Frame));
   delete [] list;
   return(true);
}


/* intensityProfile is a 1D array of size n X 2. The first element denotes intensity, the second
   element denotes intensity std. The total number of frames is n. 

   This implementation perhaps is not the most elegant one can do. But this makes it simple.

*/
extern bool readIntensityProfile(char *filename, double *intensityProfile, double *intensityMinMax, int frameNum) {

	int i;
	FILE *f1;

	if ((f1 = fopen(filename, "rt")) == NULL) {
		fprintf(stderr, "Intensity profile data file '%s' not found\n", filename);
		return(false);
	}   /* Otherwise continue */
   

	/* It is assumed that the intensity profile datafile has a very regular format, namely two elements
	   per line. The first is the intensity mean, while the second is the intensity std */

	i = 0;

	while (i < frameNum) {
//		    printf("frameNum = %d  i = %d\n", frameNum, i);
			fscanf(f1, "%lf %lf %lf %lf", &(intensityProfile[i * 2]), &(intensityProfile[i * 2 + 1]),
				                  &(intensityMinMax[i * 2]), &(intensityMinMax[i * 2 + 1]));
			if (feof(f1))
				break;
			else
				fskipspaces(f1);
			i++;
	}

	fclose(f1);
	// printf("Intensity profile reading completed successfully. File is now closed. \n");
	return(true);
}



/* intensityProfile is a 1D array of size n X 2. The first element denotes intensity, the second
   element denotes intensity std. The total number of frames is n. 

   This implementation perhaps is not the most elegant one can do. But this makes it simple.

*/
extern bool readAreaProfile(char *filename, double *areaProfile, double *areaMinMax, int frameNum) {

	int i;
	FILE *f1;

	if ((f1 = fopen(filename, "rt")) == NULL) {
		fprintf(stderr, "Area profile data file '%s' not found\n", filename);
		return(false);
	}   /* Otherwise continue */
   

	/* It is assumed that the intensity profile datafile has a very regular format, namely two elements
	   per line. The first is the intensity mean, while the second is the intensity std */

	i = 0;

	while (i < frameNum) {
//		    printf("frameNum = %d  i = %d\n", frameNum, i);
			fscanf(f1, "%lf %lf %lf %lf", &(areaProfile[i * 2]), &(areaProfile[i * 2 + 1]),
				                  &(areaMinMax[i * 2]), &(areaMinMax[i * 2 + 1]));
			if (feof(f1))
				break;
			else
				fskipspaces(f1);
			i++;
	}

	fclose(f1);
	printf("Area profile reading completed successfully. File is now closed. \n");
	return(true);
}











/* extern bool readIntensityProfile(char *fileName, double *data, int dataNum){

     FILE *f1;
	 char c;
	 int i;

	 double x1, x2;

	 
	
	 if ((f1 = fopen(fileName, "rt")) == NULL){ 
         fprintf(stderr, "File '%s' not found\n", fileName);
         return false;
	 }
	
	  //dataNum = 0;
		 
      //c = fnextc(f1);

	  //while (c != EOF) {

	 for (i =0; i < dataNum; i++) {
		fskipspaces(f1);
		fscanf(f1, " %lf %lf", &(data[2 * i]), &(data[2 * i + 1]));
		//fscanf(f1, " %lf %lf", &x1, &x2);
	    //printf(" ---%lf %lf\n", x1, x2);
		
		//	  if (feof(f1))
		//		  break;
		//	  fskipspaces(f1);
		//	  c = fnextc(f1);
		//	  dataNum = dataNum + 1;
		//	  printf("%d\n", dataNum);
		}

      fclose(f1);
	  printf("Completed ok.\n");
	  return true;
}

*/


/* flowMap is a 1D array of n X 3. The first two elements denotes vector direction. This vector is normalized.
   The third element denotes vector magnitude (or velocity). 
   This implementation perhaps is not the most elegant one can do. But this makes it simple.

*/
extern bool readFlowMap(char *filename, double *flowMap, int gridNum) {

	/* Here the gridnum is not really necessary since grid size is know. 
	   However, it can be used to verify data integrity. */

	FILE *f1;

	if ((f1 = fopen(filename, "rt")) == NULL) {
		fprintf(stderr, "Targeted file '%s' not found\n", filename);
		return(false);
	}   /* Otherwise continue */


	/* It is assumed that the intensity profile datafile has a very regular format, namely two elements
	   per line. The first is the intensity mean, while the second is the intensity std */

	int i = 0; 
	while (i < gridNum) {
		    fscanf(f1, "%lf %lf", &(flowMap[i * 2]), &(flowMap[i * 2 + 1]));
			if (feof(f1))
				break;
			else
				fskipspaces(f1);
			i++;
	}

	fclose(f1);
	// printf("Flow map reading completed successfully.\n");
	return(true);
	
	//while (!feof(f1)) {
	//		fscanf(f1, "%lf  %lf  %lf", &(flowMap[gridNum * 3]), &(flowMap[gridNum * 3 + 1]), &(flowMap[gridNum * 3 + 2]));
	//		gridNum++;
	//		fskipspaces(f1);
	//}
	//return(true);
}



       

