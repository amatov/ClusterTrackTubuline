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

#include "profile.h"
#include "strio.h"
#include "pixel_write.h"

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
extern double modelW3;
extern double modelW4;
extern double modelW5;

extern bool verbose;
extern char writeFile[256];

extern double maxSpeed;
extern double maxAngle;
extern double maxDeflectionAngle;
extern double maxPhi;

extern int image_height;
extern int image_width;


extern const char *optionStrings[NUM_PROGRAM_OPTIONS]; 
extern const char *criterionStrings[3];
extern const char *optionArgStrings[NUM_PROGRAM_OPTIONS];

extern const char *dataInputOptions[DATA_INPUT_OPTIONS];
extern const char *modeInputOptions[MODE_INPUT_OPTIONS];

extern char defaultFileName[512];
extern char configFileName[512];


extern int gridWidth;
extern int gridHeight;
extern int gridSizeX;
extern int gridSizeY;

extern int applicationMode;

extern bool intensity_cue;
extern bool flowmap_cue;
extern bool area_cue;
extern bool allow_bidirectional;

extern char filePath[512];
extern char pointFileName[512];
extern char trackFileName[512];
extern char trackImageFileName[512];
extern char intensityProfileName[512];
extern char areaProfileName[512];
extern char flowmapFileName[512];
extern int totalFrameNum;


extern void syntaxError(char *progname, char *args)
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

extern void usage(char *programName)
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



extern bool readOption(PROGRAM_OPTION option, char *p)
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

extern int parseArgs(int argc, char *argv[])
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

extern bool readProfile(const char *fname, bool printout)
{
   char string[256];

   printf("Starting to read configuration file.\n");

   /* read in data input controls */
   if (
	   (!prf_GetProfileString(fname, DATA_TAG, dataInputOptions[FILE_PATH], filePath))
    || (!prf_GetProfileString(fname, DATA_TAG, dataInputOptions[POINT_FILE_NAME], pointFileName))
    || (!prf_GetProfileString(fname, DATA_TAG, dataInputOptions[TRACK_FILE_NAME], trackFileName))
    || (!prf_GetProfileString(fname, DATA_TAG, dataInputOptions[TRACK_IMAGE_NAME], trackImageFileName))
    || (!prf_GetProfileString(fname, DATA_TAG, dataInputOptions[INTENSITY_PROFILE_NAME], intensityProfileName))
    || (!prf_GetProfileString(fname, DATA_TAG, dataInputOptions[AREA_PROFILE_NAME], areaProfileName))
    || (!prf_GetProfileString(fname, DATA_TAG, dataInputOptions[FLOWMAP_FILE_NAME], flowmapFileName))
	|| (!prf_GetProfileInt(fname, DATA_TAG, dataInputOptions[TOTAL_FRAME_NUMBER], false, 0, &totalFrameNum))
    ){
	  fprintf(stderr, "Error in DATA options '%s'\n", fname);
      return(false);
   } /* if */


   if (printout == true) {
       printf("filePath = %s\n", filePath);
       printf("pointFileName = %s\n", pointFileName);
       printf("trackFileName = %s\n", trackFileName);
       printf("trackImageFileName = %s\n", trackImageFileName);
	   printf("intensityProfileName = %s\n", intensityProfileName);
	   printf("areaProfileName = %s\n", areaProfileName);
	   printf("flowmapFileName = %s\n", flowmapFileName);
   }


      /* read in data input controls */
   if (
       (!prf_GetProfileInt(fname, MODE_TAG, modeInputOptions[APPLICATION_MODE], false, 0, &applicationMode))
	|| (!prf_GetProfileBool(fname, MODE_TAG, modeInputOptions[INTENSITY_CUE], &intensity_cue))
    || (!prf_GetProfileBool(fname, MODE_TAG, modeInputOptions[FLOWMAP_CUE], &flowmap_cue))
	|| (!prf_GetProfileBool(fname, MODE_TAG, modeInputOptions[AREA_CUE], &area_cue))
    || (!prf_GetProfileBool(fname, MODE_TAG, modeInputOptions[ALLOW_BIDIRECTIONAL], &allow_bidirectional))
    || (!prf_GetProfileInt(fname, MODE_TAG, modeInputOptions[GRID_SIZE_X], false, 0, &gridSizeX))
    || (!prf_GetProfileInt(fname, MODE_TAG, modeInputOptions[GRID_SIZE_Y], false, 0, &gridSizeY))
    || (!prf_GetProfileInt(fname, MODE_TAG, modeInputOptions[GRID_WIDTH], false, 0, &gridWidth))
	|| (!prf_GetProfileInt(fname, MODE_TAG, modeInputOptions[GRID_HEIGHT], false, 0, &gridHeight))
    ){
	  fprintf(stderr, "Error in DATA options '%s'\n", fname);
      return(false);
   } /* if */

   if (printout == true) {
	   printf("intensity_cue = %d\n", intensity_cue);
	   printf("flowmap_cue = %d\n", flowmap_cue);
	   printf("area_cue = %d\n", area_cue);
	   printf("gridSizeX = %d\n", gridSizeX );
       printf("gridSizeY = %d\n", gridSizeY);
       printf("gridWidth = %d\n", gridWidth);
       printf("gridHeight = %d\n", gridHeight);
   }

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
	   !prf_GetProfileInt(fname, OPTION_TAG, optionStrings[IMAGE_HEIGHT], false, 0, &image_height) 
	   || !prf_GetProfileInt(fname, OPTION_TAG, optionStrings[IMAGE_WIDTH], false, 0, &image_width)
    || !prf_GetProfileString(fname, OPTION_TAG, optionStrings[CRITERION], string)
    || !sindex(criterionStrings, NUMELTS(criterionStrings),
               optionStrings[CRITERION], string, &criterion)
    || !prf_GetProfileFlt(fname, OPTION_TAG, optionStrings[MODEL_W1], false, 0.0, &modelW1)
    || !prf_GetProfileFlt(fname, OPTION_TAG, optionStrings[MODEL_W2], false, 0.0, &modelW2)
	|| !prf_GetProfileFlt(fname, OPTION_TAG, optionStrings[MODEL_W3], false, 0.0, &modelW3)
    || !prf_GetProfileFlt(fname, OPTION_TAG, optionStrings[MODEL_W4], false, 0.0, &modelW4)
	|| !prf_GetProfileFlt(fname, OPTION_TAG, optionStrings[MODEL_W5], false, 0.0, &modelW5)
	|| !prf_GetProfileFlt(fname, OPTION_TAG, optionStrings[MAX_SPEED], false, 0.0, &maxSpeed)
	|| !prf_GetProfileFlt(fname, OPTION_TAG, optionStrings[MAX_ANGLE], false, 0.0, &maxAngle)
	|| !prf_GetProfileFlt(fname, OPTION_TAG, optionStrings[MAX_DEFLECTION_ANGLE], false, 0.0, &maxDeflectionAngle)
    || !prf_GetProfileInt(fname, OPTION_TAG, optionStrings[MAX_INTERPOL], false, 0, &maxInterpol)
    || !prf_GetProfileFlt(fname, OPTION_TAG, optionStrings[MAX_PHI], false, 0.0, &maxPhi)
    || !prf_GetProfileInt(fname, OPTION_TAG, optionStrings[MIN_PRESENT], false, 0, &minPresent)
    || !prf_GetProfileInt(fname, OPTION_TAG, optionStrings[MIN_TRACK_LEN], false, 0, &minTrackLen)
    || !prf_GetProfileBool(fname, OPTION_TAG, optionStrings[VERBOSE], &verbose)) {
      fprintf(stderr, "Error in profile '%s'\n", fname);
      return(false);
   } /* if */
   printf("Configuration file reading is done.\n");
   return(true);
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


