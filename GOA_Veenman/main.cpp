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
#include <ctype.h>
#include <string.h>
#include <math.h>
#include <float.h>
#include <assert.h>
#include <malloc.h>

#include "tracking.h"
#include "profile.h"
#include "strio.h"

#define BKGND_COLOR             (255)
#define DRAW_LINE_COLOR         (0)
#define DRAW_POINT_COLOR        (0)

#define MODE_PUT                (0)
#define MODE_OR                 (1)
#define MODE_AND                (2)
#define MODE_XOR                (3)
#define MODE_CONTRAST           (4)

#define DRAW_MODE               MODE_PUT

#define CROSS_SIZE              (4)
#define BOX_SIZE                (2)

#define NUMELTS(a)              (sizeof(a) / sizeof(*a))

#define DRAW_TAG                "draw"
#define OPTION_TAG              "options"

#define NO_TEXT_TIME_LABEL

#define DEBUG


typedef enum {
   CRITERION,
   DRAW_BOX,
   DRAW_CROSS,
   DRAW_LINE,
   DRAW_MUL_X,
   DRAW_MUL_Y,
   DRAW_TEXT,
   HEIGHT_IMAGE,
   HELP,
   MAX_INTERPOL,
   MAX_PHI,
   MAX_SPEED,
   MIN_PRESENT,
   MIN_TRACK_LEN,
   MODEL_W1,
   MODEL_W2,
   VERBOSE,
   WIDTH_IMAGE,
   CUSTOMIZED_OPTION1,
   CUSTOMIZED_OPTION2,
   NUM_PROGRAM_OPTIONS,
}  PROGRAM_OPTION;

static char *optionStrings[NUM_PROGRAM_OPTIONS] = {
   "criterion",
   "draw-box",
   "draw-cross",
   "draw-line",
   "draw-mul-x",
   "draw-mul-y",
   "draw-text",
   "height-image",
   "help",
   "max-interpol",
   "max-phi",
   "max-speed",
   "min-present",
   "min-track-len",
   "model-w1",
   "model-w2",
   "verbose",
   "width-image",
   "customized-option1",
   "customized-option2"
};

static const char *criterionStrings[] = {
   "smooth-motion",
   "shortest-path",
   "proximal-uniform",
};

static char *optionArgStrings[NUM_PROGRAM_OPTIONS] = {
   "string('smooth-motion', 'shortest-path', 'proximal-uniform')",
   "boolean",
   "boolean",
   "boolean",
   "float",
   "float",
   "boolean",
   "integer",
   "",
   "integer",
   "float[0..1]",
   "float",
   "integer",
   "integer",
   "float[0..1]",
   "float[0..1]",
   "boolean",
   "integer"
};

static int minTrackLen = 2;

static bool drawText = false;
static bool drawLine = false;
static bool drawCross = false;
static bool drawBox = false;
static double drawMulX = 2.0;
static double drawMulY = 2.0;
static int widthImage = 1000;
static int heightImage = 1000;

static int maxInterpol = 100;
static int minPresent = 2;
static int criterion = crt_SmoothMotionIndex;
static double modelW1 = 0.1;
static double modelW2 = 0.9;
static bool verbose = false;
static char readFile[256] = "";
static char writeFile[256] = "";
static char profileName[256] = "track_backup.txt";
static double maxSpeed = 30;
static double maxPhi = 0.4;

static int customized_option1 = 0;
static int customized_option2 = 0;


static void syntaxError(char *progname, char *args)
{
   fprintf(stderr, "%s: syntax error (%s)\n\n", progname, args);
}

static int checkOption(char **string)
{
   int i, len;

   for (i = 0; i < NUM_PROGRAM_OPTIONS; i++) {
      len = strlen(optionStrings[i]);
      if (strncmp(*string, optionStrings[i], len) == 0 && (*string)[len] == '=') {
         *string += strlen(optionStrings[i]) + 1;
         return(i);
      } /* endif */
   } /* endfor */
   return(-1);
}

static void usage(char *programName)
{
   int i;

   fprintf(stderr, "\nusage: %s [options] <input-file> <output-file>\n",
           programName);

   fprintf(stderr, "\noptions:\n\n");
   for (i = 0; i < NUM_PROGRAM_OPTIONS; i++) {
      fprintf(stderr, "    -%s%c%s\n",
              optionStrings[i], *optionArgStrings[i] ? '=' : ' ',
              optionArgStrings[i]);
   } /* endfor */

   fprintf(stderr, "\nThe feature positions are read from the <input-file>, where "
                   "each line must contain the positions of all detected features in the "
                   "respective frame.\n");

   fprintf(stderr, "\nThe results are written to the <output-file> in "
                   "PGM image format.\n\n");

}

bool readOption(PROGRAM_OPTION option, char *p)
{
   char string[256];

   switch (option) {
   case CRITERION:
      if (sgetstr(&p, string, si_Seps) && sgeteoln(&p)
       && sindex(criterionStrings, NUMELTS(criterionStrings),
                 optionStrings[option], string, &criterion)) {
         return(true);
      } /* endif */
      break;
    case HEIGHT_IMAGE:
      if (sgetint(&p, &heightImage) && sgeteoln(&p)) {
         return(true);
      } /* endif */
      break;
    case HELP:
       return(false);
    case MAX_INTERPOL:
      if (sgetint(&p, &maxInterpol) && sgeteoln(&p)) {
         return(true);
      } /* endif */
       break;
    case MAX_PHI:
      if (sgetdbl(&p, &maxPhi) && sgeteoln(&p)
       && 0 <= maxPhi /* && maxPhi <= 1.0 */) {
         return(true);
      } /* endif */
      break;
    case MAX_SPEED:
      if (sgetdbl(&p, &maxSpeed) && sgeteoln(&p)) {
         return(true);
      } /* endif */
      break;
   case MODEL_W1:
      if (sgetdbl(&p, &modelW1) && sgeteoln(&p)) {
         return(true);
      } /* endif */
      break;
   case MODEL_W2:
      if (sgetdbl(&p, &modelW2) && sgeteoln(&p)) {
         return(true);
      } /* endif */
      break;
   case VERBOSE:
      if (sgetbool(&p, &verbose) && sgeteoln(&p)) {
         return(true);
      } /* if */
      break;
   case WIDTH_IMAGE:
      if (sgetint(&p, &widthImage) && sgeteoln(&p)) {
         return(true);
      } /* endif */
      break;
   default:
      return(false);
   } /* endswitch */
   return(false);

}

static int parseArgs(int argc, char *argv[])
{
   int i;
   char *p;
   int option;

   for (i = 1; i < argc; i++) {
      p = argv[i];
      if (*p++ == '-') {
         option = checkOption(&p);

         if (option < 0 || readOption((PROGRAM_OPTION) option, p) == false) {
            syntaxError(argv[0], argv[i]);
            usage(argv[0]);
            return(0);
         } /* endif */
      } else {
         break;
         syntaxError(argv[0], argv[i]);
         usage(argv[0]);
         return(i);
      } /* endif */
   } /* endfor */
   return(i);
}

bool readProfile(const char *fname)
{
   char string[256];

   if (!prf_GetProfileBool(fname, DRAW_TAG, optionStrings[DRAW_BOX], &drawBox)
    || !prf_GetProfileBool(fname, DRAW_TAG, optionStrings[DRAW_CROSS], &drawCross)
    || !prf_GetProfileBool(fname, DRAW_TAG, optionStrings[DRAW_LINE], &drawLine)
    || !prf_GetProfileBool(fname, DRAW_TAG, optionStrings[DRAW_TEXT], &drawText)
    || !prf_GetProfileFlt(fname, DRAW_TAG, optionStrings[DRAW_MUL_X], false, 0.0, &drawMulX)
    || !prf_GetProfileFlt(fname, DRAW_TAG, optionStrings[DRAW_MUL_Y], false, 0.0, &drawMulY)
    || !prf_GetProfileInt(fname, DRAW_TAG, optionStrings[HEIGHT_IMAGE], false, 0, &heightImage)
    || !prf_GetProfileInt(fname, DRAW_TAG, optionStrings[WIDTH_IMAGE], false, 0, &widthImage)) {
      fprintf(stderr, "Error in draw options '%s'\n", fname);
      return(false);
   } /* if */

   if (
       !prf_GetProfileString(fname, OPTION_TAG, optionStrings[CRITERION], string)
    || !sindex(criterionStrings, NUMELTS(criterionStrings),
               optionStrings[CRITERION], string, &criterion)
    || !prf_GetProfileFlt(fname, OPTION_TAG, optionStrings[MODEL_W1], false, 0.0, &modelW1)
    || !prf_GetProfileFlt(fname, OPTION_TAG, optionStrings[MODEL_W2], false, 0.0, &modelW2)
    || !prf_GetProfileInt(fname, OPTION_TAG, optionStrings[MAX_INTERPOL], false, 0, &maxInterpol)
    || !prf_GetProfileFlt(fname, OPTION_TAG, optionStrings[MAX_PHI], false, 0.0, &maxPhi)
    || !prf_GetProfileInt(fname, OPTION_TAG, optionStrings[MIN_PRESENT], false, 0, &minPresent)
    || !prf_GetProfileInt(fname, OPTION_TAG, optionStrings[MIN_TRACK_LEN], false, 0, &minTrackLen)
    || !prf_GetProfileBool(fname, OPTION_TAG, optionStrings[VERBOSE], &verbose) 
    || !prf_GetProfileInt(fname, OPTION_TAG, optionStrings[CUSTOMIZED_OPTION1], false, 0, &customized_option1) 
	|| !prf_GetProfileInt(fname, OPTION_TAG, optionStrings[CUSTOMIZED_OPTION2], false, 0, &customized_option2)) {
      fprintf(stderr, "Error in profile '%s'\n", fname);
      return(false);
   } /* if */

   return(true);
}

static bool savePgm(FILE *f, unsigned char *image, int width, int height,
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

static void removeExtremeColors(unsigned char *image, int width, int height)
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

static void setPixel(unsigned char *image, int width, int height,
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

static int writeChar(unsigned char *image, int width, int height,
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
   case 'á':   fdat = "122212202222231220222213122";
      break;
   case 'œ':   fdat = "000001320000120200012000003222000120000012222223";
      break;
   case '\'':  fdat = "122";
      break;
   case '~':   fdat = "1320330231";
      break;
   case 'ø':   fdat = "220212020212022";
      break;
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
   case 'œ':
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

static int writeString(unsigned char *image, int width, int height,
                       int x, int y, char *s)
{
   while (*s) {
      x += writeChar(image, width, height, x, y, *s++);
   } /* while */
   return(x);
}

static inline void swapFloat(double &x, double &y)
{
   double tmp = x;

   x = y; y = tmp;
}

static inline void swapInt(int &x, int &y)
{
   int tmp = x;

   x = y; y = tmp;
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
static void setLine(unsigned char *image, const int width, const int height,
	            int X1, int Y1,
		    int X2, int Y2,
                    const int value)
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

static void setCross(unsigned char *image, int width, int height,
                     int x, int y, int csize, int color)
{
   setLine(image, width, height,
            x - csize, y, x + csize, y,
            DRAW_POINT_COLOR);
   setLine(image, width, height,
            x, y - csize, x, y + csize,
            DRAW_POINT_COLOR);
}

static void setBox(unsigned char *image, int width, int height,
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

static bool saveTrackImage(FILE *f, int width, int height,
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


static bool saveTrackImage_BD(FILE *f, int width, int height,
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

#ifdef DEBUG
   fprintf(stdout, "image width = %d  image height = %d\n", width, height);
#endif

   image = (unsigned char *) malloc(width * height * sizeof(char));
   memset(image, BKGND_COLOR, width * height * sizeof(char));

   assert(image);

   for (i = 0; i < t.num; i++) {   /* Go through the entire list of tracks */

	  if (t.track[i].len == 1) {

		   x = (int) (drawMulX * t.track[i].point[0].x + 0.5);
		   y = (int) (drawMulY * t.track[i].point[0].y + 0.5);
		   setBox(image, width, height, x, y, 2 * BOX_SIZE, DRAW_LINE_COLOR);
	  }
      else {  /* else for non-isolated points */


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
						 sprintf(buf, "%d", i + 1);  /* Here you may add the starting frame number */
						 writeString(image, width, height, X2 + 2, Y2 + 4, buf);
					   } /* if */

					   if (k == 1) {
						  if (drawBox) {
							 setBox(image, width, height, X1, Y1, BOX_SIZE, DRAW_LINE_COLOR);
						  } /* if */
					   } /* if */
					   if (k == t.track[i].len - 1) {
						  setBox(image, width, height, X2, Y2, 2 * BOX_SIZE, DRAW_LINE_COLOR);  
						  /* larger box size indicates termination */
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

	  } /* end of else for non-isolated points */

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

/* **************************   end of saveTrackImage_BD ********************************* */

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

static bool readPoint(FILE *f, pnt_Point *point)
{
   fskipspaces(f);
   switch (fnextc(f)) {
   case '(':
      fgetc(f);
      fskipspaces(f);
      point->state = pnt_Normal;
      fskipspaces(f);
      assert(fscanf(f, "%f %f", &point->x, &point->y) == 2);
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

static bool readPointList(FILE *f, frm_Frame *points)
{
   int len = 0;
   pnt_Point list[tkg_MaxObjects];  /* list is the buffer that saves point coordinates temporarily. */

   fskipspaces(f);

   if (feof(f)) {
      return(false);
   } /* endif */

   while (len < tkg_MaxObjects && readPoint(f, list + len)) {
      len++;
   } /* endwhile */

   points->len = len;
   points->point = (pnt_Point *) malloc(len * sizeof(pnt_Point));
   memcpy(points->point, list, len * sizeof(pnt_Point));
   return(true);
}

static bool readSequence(FILE *f, frm_Sequence *sequence)
{
   int len = 0;
   frm_Frame list[tkg_MaxSequenceLen];   /* array of frames */

   while (len < tkg_MaxSequenceLen && readPointList(f, list + len)) {
//      if (verbose)
#ifdef DEBUG
         fprintf(stderr, "%d points in frame %d\n", list[len].len, len);
#endif

/* Remember, here each element in list only contains the head pointer to the array of points. Therefore, the
   size of each element is constant. 
   
   Since there is no need to copy coordinates of points, this is also efficient.
*/
      len++;
   } /* endwhile */
   sequence->len = sequence->maxLen = len;
   sequence->frame = (frm_Frame *) malloc(len * sizeof(frm_Frame));
   memcpy(sequence->frame, list, len * sizeof(frm_Frame));
   return(true);
}


int main(int argc, char *argv[])
{
   FILE *f1, *f2 = stdout;
   frm_Sequence s = frm_EmptySequence;
   frm_Sequence refSequence = frm_EmptySequence;
   trk_TrackList trackList = trk_EmptyTrackList;
   trk_TrackList refTracks = trk_EmptyTrackList;

#ifdef DEBUG
   fprintf(stdout, "customized_option1 = %d customized_option2 = %d \n", customized_option1, customized_option2);
#endif

   if (!readProfile(profileName)) {
       return(1);
   } /* if */

#ifdef DEBUG
   fprintf(stdout, "customized_option1 = %d customized_option2 = %d \n", customized_option1, customized_option2);
#endif

   if (parseArgs(argc, argv) == argc - 2) {

      strcpy(readFile, argv[argc - 2]);
      strcpy(writeFile, argv[argc - 1]);

      crt_SetMaxInterpol(maxInterpol);
      crt_SetModelWeights(modelW1, modelW2);

      if ((f1 = fopen(readFile, "rt")) != NULL) {
         readSequence(f1, &s);
         fclose(f1);
         frm_Copy(s, refSequence);
         /* tkg_MakeTracks_BD (s, 
						    (crt_IndividualModel) criterion,	
                            maxSpeed, maxPhi,
                            maxInterpol, minPresent,
                            verbose,
                            minTrackLen, trackList); */

		 tkg_MakeTracks(s, s.frame[0].len,
						(crt_IndividualModel) criterion,	
                        maxSpeed, maxPhi,
                        maxInterpol, minPresent,
                        verbose,
                        minTrackLen, trackList); 


         /*fprintf(stderr, "Found %d tracks with total smoothness: %f\n",
                 trackList.num, trk_Smoothness(trackList, maxPhi)); */

		 fprintf(stdout, "Found %d tracks with total smoothness: %f\n",
                 trackList.num, trk_Smoothness(trackList, maxPhi)); 


         if ((f2 = fopen(writeFile, "wt")) != NULL) {
            saveTrackImage_BD(f2, widthImage, heightImage,
                           trackList, refSequence);
            fclose(f2);

         } else {
            fprintf(stderr, "Could not open '%s'\n", writeFile);
         } /* if */

      } else {
         fprintf(stderr, "File '%s' not found\n", readFile);
      } /* if */
   } else {
      usage(argv[0]);
   } /* if */
}
