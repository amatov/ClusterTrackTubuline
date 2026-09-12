#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <math.h>
#include <float.h>
#include <assert.h>
#include <malloc.h>

#include "main_const.h"

#include "tracks.h"
#include "criterion.h"
#include "frames.h"

extern int minTrackLen;

extern bool drawText;
extern bool drawLine;
extern bool drawCross;
extern bool drawBox;
extern double drawMulX;
extern double drawMulY;
extern int widthImage;
extern int heightImage;

extern int maxInterpol;
extern int minPresent;
extern int criterion;
extern double modelW1;
extern double modelW2;
extern bool verbose;
extern char writeFile[256];
extern double maxSpeed;
extern double maxPhi;

extern int customized_option1;
extern int customized_option2;


extern const char *optionStrings[NUM_PROGRAM_OPTIONS]; 
extern const char *criterionStrings[3];
extern const char *optionArgStrings[NUM_PROGRAM_OPTIONS];


void setPixel(unsigned char *image, int width, int height,
                       int x, int y, int value)
{
   if (0 <= x && x < width && 0 <= y && y < height) {
#if DRAW_MODE == MODE_PUT
      image[y * width + x] = value;
#elif DRAW_MODE == MODE_OR
      image[y * width + x] |= value;
#elif DRAW_MODE == MODE_AND
      image[y * width + x] &= value;
#elif DRAW_MODE == MODE_XOR
      image[y * width + x] ^= value;
#elif DRAW_MODE == MODE_CONTRAST

      if (image[y * width + x] == value
       || image[y * width + x] == 255 - value)
         return;

      if ((image[y * width + x] < 128) ^ (value < 128))
         image[y * width + x] = value;
      else
         image[y * width + x] = 255 - value;
#else
      #error Uknown drawmode
#endif
   } /* if */
}


int writeChar(unsigned char *image, int width, int height,
                     int x, int y, int ch)
{
   int xp, w;
   char *fdat = NULL;

   switch (ch) {
   case 'a':
   case 'A':   fdat = "1322132022222322202222022";
      break;
   case 'b':
   case 'B':   fdat = "3222122022222312202222231";
      break;
   case 'c':
   case 'C':   fdat = "1322132022220002202212231";
      break;
   case 'd':
   case 'D':   fdat = "3222122022220222202222231";
      break;
   case 'e':
   case 'E':   fdat = "3222222000222002200022222";
      break;
   case 'f':
   case 'F':   fdat = "3222222000222002200022";
      break;
   case 'g':
   case 'G':   fdat = "1322232000220322202212232";
      break;
   case 'h':
   case 'H':   fdat = "3202222022222322202222022";
      break;
   case 'i':
   case 'I':   fdat = "32220220022002202222";
      break;
   case 'j':
   case 'J':   fdat = "032220022000220002202231";
      break;
   case 'k':
   case 'K':   fdat = "3202222022222312202222022";
      break;
   case 'l':
   case 'L':   fdat = "3200022000220002200022222";
      break;
   case 'm':
   case 'M':   fdat = "3000322022222222202222022";
      break;
   case 'n':
   case 'N':   fdat = "3222122022220222202222022";
      break;
   case 'o':
   case 'O':   fdat = "1322132022220222202212231";
      break;
   case 'p':
   case 'P':   fdat = "3222122022220222223122";
      break;
   case 'q':
   case 'Q':   fdat = "1322132022220222232212232";
      break;
   case 'r':
   case 'R':   fdat = "3222122022220222223122022";
      break;
   case 's':
   case 'S':   fdat = "1322232000122210002222231";
      break;
   case 't':
   case 'T':   fdat = "2222022002200220022";
      break;
   case 'u':
   case 'U':   fdat = "3203222022220222202212231";
      break;
   case 'v':
   case 'V':   fdat = "320322202222022120210121";
      break;
   case 'w':
   case 'W':   fdat = "3203222022222222202230003";
      break;
   case 'x':
   case 'X':   fdat = "3202222022122312202222022";
      break;
   case 'y':
   case 'Y':   fdat = "3203222022122220002222231";
      break;
   case 'z':
   case 'Z':   fdat = "2322200121012101210022221";
      break;
   case '0':   fdat = "1322132022220222202212231";
      break;
   case '1':   fdat = "0322000220002200022002222";
      break;
   case '2':   fdat = "2222100022122212200022222";
      break;
   case '3':   fdat = "2222100032002210002222231";
      break;
   case '4':   fdat = "3202122022122220002200021";
      break;
   case '5':   fdat = "3222222000122210002222221";
      break;
   case '6':   fdat = "1322132000222212202212231";
      break;
   case '7':   fdat = "322230002200022002210221";
      break;
   case '8':   fdat = "1322132022122312202212231";
      break;
   case '9':   fdat = "1322122022122220002222231";
      break;
   case '.':   fdat = "0000000012";
      break;
   case ',':   fdat = "00000000122";
      break;
   case '?':   fdat = "22221000220221000000012";
      break;
   case '!':   fdat = "0003200220022000000022";
      break;
   case '=':   fdat = "000221000221";
      break;
   case '+':   fdat = "00200003002322100200001";
      break;
   case '-':   fdat = "000000221";
      break;
   case '(':   fdat = "132320220220122";
      break;
   case ')':   fdat = "321022022022231";
      break;
   case '$':   fdat = "002201322232000122210002222231022";
      break;
   case '&':   fdat = "1322132022122122202212212";
      break;
   case '*':   fdat = "2101202120232220212021012";
      break;
   case '%':   fdat = "2102200120012100210022021";
      break;
   case ':':   fdat = "0022000022";
      break;
   case ';':   fdat = "00220000122";
      break;
   case '"':   fdat = "120122002";
      break;
   case '/':   fdat = "0002200120012100210022";
      break;
   case '\\':   fdat = "2200002100012100012000022";
      break;
   case '^':   fdat = "0232022022";
      break;
   case '@':   fdat = "1322132022220312200012231";
      break;
   //case '?:   fdat = "122212202222231220222213122";
   //   break;
   //case '?:   fdat = "000001320000120200012000003222000120000012222223";
   //   break;
   case '\'':  fdat = "122";
      break;
   case '~':   fdat = "1320330231";
      break;
   //case '?:   fdat = "220212020212022";
   //   break;
   default:
      fprintf(stderr, "Unknown character! (%c)\n", ch);
   } /* switch */


   switch (ch) {
   case 't':
   case 'T':
   case 'i':
   case 'I':
      w = 4;
      break;
   case ',':
   case '.':
   case ':':
   case ';':
   case '\'':
      w = 2;
      break;
   case '?':
      w = 8;
      break;
   case '(':
   case ')':
   case '=':
   case '-':
      w = 3;
      break;
   default:
      w = 5;
   } /* switch */

   xp = 0;

   while (*fdat != '\0') {
      if (*fdat != '0') {
         if (BKGND_COLOR == 0) {
            setPixel(image, width, height, x + xp, y,
                       255 * (*fdat - '0') / 3);
         } else {
            setPixel(image, width, height, x + xp, y, 0);
         } /* if */
      } /* if */
      if (++xp == w) {
         xp = 0;
         y++;
      } /* if */
      fdat++;
   } /* while */

   return(w);
}

/*
 * Function setLine (image, gc, x1, y1, x2, y2)
 *
 *  Returns
 *    ig_OK on success, error code otherwise
 *
 *  Parameters
 *    image:       pointer to ig_image
 *    gc:          pointer to graphics context
 *    x1:          x position from start point
 *    y1:          y position from start point
 *    x2:          x position from end point
 *    y2:          y position from end point
 *
 *  Description
 *    Draws line from (x1,y1) to (x2,y2) using the given graphics context
 *
 */
extern void setLine(unsigned char *image, const int width, const int height,
	            int X1, int Y1, int X2, int Y2, const int value)
{
  int w, h, d, dxd, dyd, dxn, dyn, dinc, ndinc, p;
  int x, y;
  unsigned char color;

  //Y1 = height - Y1;
  //Y2 = height - Y2;

  /* get color */
  color = value;

  /* Set up */
  x = X1; y = Y1; /* start of line */
  w = X2 - X1;    /* width domain of line */
  h = Y2 - Y1;    /* height domain of line */

  /* Determine drawing direction */
  if(w < 0)
    {
      /* drawing right to left */
      w = -w;   /* absolute width */
      dxd = -1; /* x increment is negative */
    }
  else
    {
      /* drawing left to right */
      dxd = 1; /* so x incr is positive */
    }

  if (h < 0)
    {
      /* drawing bottom to top */
      h = -h;   /* so get absolute height */
      dyd = -1; /* y incr is negative */
    }
  else
    {
      /* drawing top to bottom */
      dyd = 1; /* so y incr is positive */
    }

  /* Determine major axis of motion */
  if (w < h)
    { /* major axis is Y */
      p = h, h = w, w = p; /* exchange height and width */
      dxn = 0;
      dyn = dyd;
    }
  else
    {
      /* major axis is X */
      dxn = dxd;
      dyn = 0;
    }

  /* Set control variables */
  ndinc = h * 2; /* Non-diagonal increment */
  d = ndinc - w; /* pixel selection variable */
  dinc = d - w;  /* Diagonal increment */

  /* Loop to draw the line */
  for (p = 0; p <= w; p++)
    {
      setPixel(image, width, height, x, y, color);

      if (d < 0)
	{
	  /* step non-diagonally */
	  x += dxn;
	  y += dyn;
	  d += ndinc;
	}
      else
	{
	  /* step diagonally */
	  x += dxd;
	  y += dyd;
	  d += dinc;
	}
    }
}


extern void setCross(unsigned char *image, int width, int height,
                     int x, int y, int csize, int color)
{
   setLine(image, width, height,
            x - csize, y, x + csize, y,
            DRAW_POINT_COLOR);
   setLine(image, width, height,
            x, y - csize, x, y + csize,
            DRAW_POINT_COLOR);
}

extern void setBox(unsigned char *image, int width, int height,
                   int x, int y, int bsize, int color)
{
   setLine(image, width, height,
            x - bsize, y - bsize, x + bsize, y - bsize,
            DRAW_POINT_COLOR);
   setLine(image, width, height,
            x - bsize, y + bsize, x + bsize, y + bsize,
            DRAW_POINT_COLOR);

   setLine(image, width, height,
            x - bsize, y - bsize, x - bsize, y + bsize,
            DRAW_POINT_COLOR);
   setLine(image, width, height,
            x + bsize, y - bsize, x + bsize, y + bsize,
            DRAW_POINT_COLOR);
}


extern void removeExtremeColors(unsigned char *image, int width, int height)
{
   width *= height;
   while (width-- > 0) {
      if (*image == 0) {
         (*image)++;
      } else if (*image == 255) {
         (*image)--;
      } /* if */
      image++;
   } /* while */
}



extern int writeString(unsigned char *image, int width, int height,
                       int x, int y, char *s)
{
   while (*s) {
      x += writeChar(image, width, height, x, y, *s++);
   } /* while */
   return(x);
}

extern bool savePgm(FILE *f, unsigned char *image, int width, int height,
                    const char *comment)
{
    char strHeader[256];

    sprintf(strHeader,
            "P5\n"
            "# **************** Survive ******************\n"
            "# * intermediate segmentation result        *\n"
            "# * number in filename indicates life cycle *\n"
            "# *******************************************\n"
            "# %s\n"
            "%d %d\n255\n", comment, width, height);

    fwrite(strHeader, strlen(strHeader), 1, f);
    fwrite(image, width * height * sizeof(char), 1, f);
    return(true);
}


extern bool saveTrackImage(FILE *f, int width, int height,
                           trk_TrackList &t, const frm_Sequence &s)
{
   int i, k;
   int prev;
   int x, y;
   int X1, Y1, X2, Y2;
   unsigned char *image;
   char buf[20];

//   width *= (int) (drawMulX + 0.5);
//   height *= (int) (drawMulY + 0.5);

   image = (unsigned char *) malloc(width * height * sizeof(char));
   memset(image, BKGND_COLOR, width * height * sizeof(char));

   assert(image);

   for (i = 0; i < t.num; i++) {
      prev = -1;
      fprintf(stderr, "track[%d]: first %d len %d\n",
              i, t.track[i].first, t.track[i].len);
      for (k = 0; k < t.track[i].len; k++) {
         if (t.track[i].point[k].state != pnt_Empty) {
            if (prev >= 0) {
               X1 = (int) (drawMulX * t.track[i].point[prev].x + 0.5);
               Y1 = (int) (drawMulY * t.track[i].point[prev].y + 0.5);
               X2 = (int) (drawMulX * t.track[i].point[k].x + 0.5);
               Y2 = (int) (drawMulY * t.track[i].point[k].y + 0.5);

               if (drawLine) {
                  setLine(image, width, height, X1, Y1, X2, Y2, DRAW_LINE_COLOR);
               } /* if */

               if (drawText) {
                 //sprintf(buf, "%d", t.track[i].first + k);
                 sprintf(buf, "%d", i + 1);
                 writeString(image, width, height, X2 + 2, Y2 + 4, buf);
               } /* if */

               if (k == 1) {
                  if (drawBox) {
                     setBox(image, width, height, X1, Y1, BOX_SIZE, DRAW_LINE_COLOR);
                  } /* if */
               } /* if */
               if (k == t.track[i].len - 1) {
               //   setBox(image, width, height, X2, Y2, 2 * BOX_SIZE, DRAW_LINE_COLOR);
               } /* if */

            } else {
               assert(k == 0);
               X1 = (int) (drawMulX * t.track[i].point[k].x + 0.5);
               Y1 = (int) (drawMulY * t.track[i].point[k].y + 0.5);

               if (drawText) {
#ifdef TEXT_TIME_LABEL
                  sprintf(buf, "%d", t.track[i].first + k);
#else // TEXT_TRACK_LABEL
                  sprintf(buf, "%d", i + 1);
#endif
                  writeString(image, width, height, X1 + 2, Y1 + 2, buf);
               } /* if */
            } /* if */
            prev = k;
         } else {
            fprintf(stderr, "track[%d]: position %d is empty point\n",
                    i, k);
         } /* if */
      } /* endfor */

   } /* endfor */


   /* Plotting measurements if drawCross == true */

   for (k = 0; k < s.len; k++) {
      for (i = 0; i < s.frame[k].len; i++) {
         if (s.frame[k].point[i].state == pnt_Normal) {
            x = (int) (drawMulX * s.frame[k].point[i].x + 0.5);
            y = (int) (drawMulY * s.frame[k].point[i].y + 0.5);

            if (drawCross) {
               setCross(image, width, height, x, y, CROSS_SIZE, DRAW_POINT_COLOR);
            } /* if */

         } else {
            fprintf(stderr, "track[%d]: position %d is empty point\n",
                    i, k);
         } /* if */
      } /* for */
   } /* for */

   return(savePgm(f, image, width, height, ""));
}

/* *****************************   saveTrackImage_BD ************************************* */
/* Revised saveTrackImage function that can now address birth and death of feature points. 

   I have decided to leave the original implementation largely intact. The reasons are

   (1) It can handle tracks of different length and the cases of birth and death. 

   (2) Different ways can be developed to mark the birth and death of points. Here, I only
       want to draw trajectories, no matter when each trajectory starts. 

   The only change made is the handling of isolating points (that is, a track has a length of 1).

   The program already can handle the case when a track has a length of 0. 

   *************************************************************************************** */


extern bool saveTrackImage_BD(FILE *f, int width, int height,
                              trk_TrackList &t, const frm_Sequence &s,
							  int* numPlottedPoints)
{
   int i, k;
   int prev;
   int x, y;
   int X1, Y1, X2, Y2;
   unsigned char *image;
   char buf[20];

   int startFrameID = 0, endFrameID = 30, pointFrameID; 

//   width *= (int) (drawMulX + 0.5);
//   height *= (int) (drawMulY + 0.5);

#ifdef DEBUG
   fprintf(stdout, "image width = %d  image height = %d\n", width, height);
#endif

   image = (unsigned char *) malloc(width * height * sizeof(char));
   memset(image, BKGND_COLOR, width * height * sizeof(char));

   assert(image);

   *numPlottedPoints = 0;

   
   for (i = 0; i < t.num; i++) {   /* Go through the entire list of tracks */

	  if (t.track[i].len == 1) {

		   x = (int) (drawMulX * t.track[i].point[0].x + 0.5);
		   y = (int) (drawMulY * t.track[i].point[0].y + 0.5);
		   pointFrameID = t.track[i].point[0].frameID;
		   
		   //if (( pointFrameID>= startFrameID) && (pointFrameID <= endFrameID))
			//   setBox(image, width, height, x, y, 3 * BOX_SIZE, DRAW_LINE_COLOR);  

		   /* In this case, we do not draw any cross or other markers. */
		   /* use a different size to indicate isolated point */

		   if (drawText) {
						 //sprintf(buf, "%d", t.track[i].first + k);
			   sprintf(buf, "%d", t.track[i].point[0].frameID);  /* Here you may add the starting frame number */
			   printf("isolated = %d\n", t.track[i].point[0].frameID);
			   //fflush(stdin);
			   //scanf(".");
			   if ((pointFrameID >= startFrameID) && (pointFrameID <= endFrameID))
			       writeString(image, width, height, x + 2, y + 4, buf);
		   } /* if */

		   (*numPlottedPoints)++;
		   
	  }
      else {  /* else for non-isolated points */


			prev = -1;
			fprintf(stderr, "track[%d]: first %d len %d\n",
					  i, t.track[i].first, t.track[i].len);
			for (k = 0; k < t.track[i].len; k++) {
				 if (t.track[i].point[k].state != pnt_Empty) {
					
					(*numPlottedPoints)++;
					
					if (prev >= 0) {
					   X1 = (int) (drawMulX * t.track[i].point[prev].x + 0.5);
					   Y1 = (int) (drawMulY * t.track[i].point[prev].y + 0.5);
					   pointFrameID = t.track[i].point[prev].frameID;

					   X2 = (int) (drawMulX * t.track[i].point[k].x + 0.5);
					   Y2 = (int) (drawMulY * t.track[i].point[k].y + 0.5);
					  
					   if (drawCross) {
						   if ((pointFrameID >= startFrameID) && (pointFrameID <= endFrameID))
						       setCross(image, width, height, X1, Y1, CROSS_SIZE, DRAW_POINT_COLOR);
					
					   } /* if */

					   if (drawLine) {
						   if ((pointFrameID >= startFrameID) && (pointFrameID <= endFrameID))
						       setLine(image, width, height, X1, Y1, X2, Y2, DRAW_LINE_COLOR);
					   } /* if */

					   if (drawText) {
						 //sprintf(buf, "%d", t.track[i].first + k);
					//	 sprintf(buf, "%d", t.track[i].point[k].frameID);  /* Here you may add the starting frame number */
					//	 writeString(image, width, height, X2 + 2, Y2 + 4, buf);
					   } /* if */

					   if (k == 1) {
						  if (drawBox) {
                             if ((pointFrameID >= startFrameID) && (pointFrameID <= endFrameID))
							     setBox(image, width, height, X1, Y1, BOX_SIZE, DRAW_LINE_COLOR);
						  } /* if */
					   } /* if */

					   if (k == t.track[i].len - 1) {
						   //if ((pointFrameID >= startFrameID) && (pointFrameID <= endFrameID))
						       //setBox(image, width, height, X2, Y2, 2 * BOX_SIZE, DRAW_LINE_COLOR);  
						  /* larger box size indicates termination */
					   } /* if */

					} else {
					   assert(k == 0);
					   X1 = (int) (drawMulX * t.track[i].point[k].x + 0.5);
					   Y1 = (int) (drawMulY * t.track[i].point[k].y + 0.5);
					   pointFrameID = t.track[i].point[k].frameID;

					   if (drawText) {
		//#ifdef TEXT_TIME_LABEL
						   //if ((pointFrameID >= startFrameID) && (pointFrameID <= endFrameID))
						   //    sprintf(buf, "%d", t.track[i].first + k);
		//#else // TEXT_TRACK_LABEL
		//				   if ((pointFrameID >= startFrameID) && (pointFrameID <= endFrameID))
						       sprintf(buf, "%d", i + 1);
		//#endif
		//				   if ((pointFrameID >= startFrameID) && (pointFrameID <= endFrameID))
						       writeString(image, width, height, X1 + 2, Y1 + 2, buf);
					   } /* if */
					} /* if */
					prev = k;
				 } else {
					fprintf(stderr, "track[%d]: position %d is empty point\n",
							i, k);
				 } /* if */
			  } /* endfor */

	  } /* end of else for non-isolated points */

   } /* endfor */


   /* Plotting measurements if drawCross == true.
      However, the logic is that every point will be printed as a cross. 
      This may not be desirable. */

   //for (k = 0; k < s.len; k++) {
   //   for (i = 0; i < s.frame[k].len; i++) {
   //      if (s.frame[k].point[i].state == pnt_Normal) {
   //         x = (int) (drawMulX * s.frame[k].point[i].x + 0.5);
   //         y = (int) (drawMulY * s.frame[k].point[i].y + 0.5);

   //         if (drawCross) {
   //            setCross(image, width, height, x, y, CROSS_SIZE, DRAW_POINT_COLOR);
   //		   (*numPlottedPoints)++;
   //         } /* if */

   //      } else {
   //         fprintf(stderr, "track[%d]: position %d is empty point\n",
   //                 i, k);
   //      } /* if */
   //   } /* for */
   //} /* for */

   return(savePgm(f, image, width, height, ""));
}

/* **************************   end of saveTrackImage_BD ********************************* */
