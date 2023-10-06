/***************************************************************************************
  DESCRIPTION                 This software is developed for the tracking of large
							  numbers of densely populated moving point features, 
							  especially speckles and vesicles, that constantly undergo
							  birth/death and merge/split.
							
							  In this release, each point feature can have the
							  following properties (tracking cues):

							  (1) 2D position: namly, its (X, Y) coordinate
							  (2) Intensity:   namely, the gray level. However, 
									           this feature can be turned off.
							  (3) Area: this feature can be turned off.

                              In addition, each position in the image plane is associated
							  with a nomalized flow vector, which defines the most
							  likely orientation of feature movement. This vector
							  is used in both similarity cost (graph node connection
							  weight) computation and track initialization. This normalized
							  flow vector feature can also be turned off.

								  
  ACKNOWLEDGEMENT 		      To maximize productivity, this implementation uses
							  some functions and definitions developed by Dr. Cor J. 
							  Veenman in his GOA tracker software for the paper:

							  Veenman, C.J., Reinders, M.J.T., Backer, E., 
							  Resolving Motion Correspondence for Densely Moving
							  Points. IEEE Transactions on Pattern Analysis and
							  Machine Intelligence, vol. 23, no. 1, pp. 54-72,
							  January 2001
								  
							  In particular, several service modules are used
							  with minor or no changes. However, FUNDAMENTAL CHANGES
							  have been made to the algorithms and data structure, 
							  and also to the organization of the program. 

 
  AUTHOR                      Ge Yang, Ph.D. 
                              geyang@scripps.edu
                              Laboratory for Computational Cell Biology
							  Department of Cell Biology
                              The Scripps Research Institute
 
  DATE OF CREATION            May 27, 2004

  RELEASE                     ver 0.7 (Stable release 0)    August 16, 2004
							  ver 0.8 (Stable release 1.0)  August 25, 2004
							  ver 0.9 (Stable release 1.1)  August 27, 2004
							  ver 1.0 (Stable release 1.2)  December 9, 2004
							  Stable release 2              January 26, 2005
							  Stable release 3              June 12, 2005

                              

  
  HISTORY OF CHANGES          ver 0.1: The code is reorganized for better
                              readability and initial release.

                              ver 0.2: The bug in memory management is now fixed.
							  
							  ver 0.3: Finally, w1 & w2 are no longer the only choice. 
							  Instead, a Mahalanobis distance-based cost function is
							  now supported. 

                              *** Remember, the setting of maxPhi is different under
							  Mahalanobis distance and therefore must be considered.
							
							  ver 0.4: Implementation now considers both intensity and
							           local flux field. These two are incorporated
									   into the cost function.

                              ver 0.5: clean up the program for robustness. 

                              ver 0.6: provides full support for vector field initial-
							           iaztion and cost computation.

                              ver 0.7: Stable release 0. This release supports only 
							           w1-w2 scheme and the intensity cue. The Kalman
									   filter scheme and use of external flow field
									   will be distribued in a separate release.

                              ver 0.8: Stable release 1. This realease supports w1-w2 
							           sheme, intensity cue and external flow constraint.
									   This essentially completes the phase I of this
									   non-kalman scheme, although new features can
									   certainly be added. 

                                       The support of convenient new feature addition
									   would be the major improvement to be done. 

                              ver 0.9: Stable release 1.1. Fixed the problem in function
							           "getLast". 
							
							  ver 1.0: Add the area property. Add the parameter iteration function

							  Stable release 2: Added the support for vesicle tracking. Removed some minor
							                    errors

							  Stable release 3: Formally started verbose mode control since the program is 
							                    getting reasonably stable.
                              
                                
  BUG REPORT:				  geyang@scripps.edu

****************************************************************************************/

/*--------------------------------------------------------------------------------------/
PROGRAM SIZE CONSTRAINTS:

This part explains the major constraints defined in the software. These constraints 
determine memory requirement.

--> main_const.h <--

(1) #define MAX_TOTAL_TRACK_NUM  
(2) #define MAX_PT_NUM_PER_FRAME MAX_TOTAL_TRACK_NUM   
(3) #define MAX_PTNUM_IN_FILEREADING    10000        
(4) #define tkg_MaxFrameNum (1000)
(5) Maximum file name (including path) length is 512 characters.  
--------------------------------------------------------------------------------------*/
/***************************/
/*  STABLE RELEASE 2       */
/***************************/

#include <stdio.h>
#include <iostream>
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
#include "pixel_write.h"
#include "pt_trk_io.h"

#include "main_const.h"     // definition of constants
#include "main_globals.h"   // definition of global variables

#include "usageparse.h"
#include "point_list.h"

#define VERBOSE_INPUT
//#undef  VERBOSE_INPUT

#define PARAMETER_CONFIGURATION_CHECK
#define INPUTDATA_DIMENSION_CHECK



int main(int argc, char *argv[])
{

/*--------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------*/

    char fileNameBuffer[512] = "";
	FILE *f1, *f2 = stdout;

    int i, j, k, len;
	int numTotalPoints, numTrackedPoints, numPlottedPoints;
    int detected_track = 0, print_counter = 0;
    int pointReadMode;

	double tempFlowVecMag;

	double temp, temp2;

	frm_Sequence s = frm_EmptySequence, refSequence = frm_EmptySequence;
    trk_TrackList trackList = {0, MAX_TOTAL_TRACK_NUM, NULL}, benchTrackList = {0, MAX_TOTAL_TRACK_NUM, NULL};
/*--------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------*/
 	
	//int tempX, tempY, tempptr;
    //double vecX, vecY;

/*--------------------------------------------------------------------------------------------------------------*/
/*----------------------------------  Step 1: parameter settings & data input   --------------------------------*/
/*--------------------------------------------------------------------------------------------------------------*/

	/*-----------------------------------------------------*/
	/***** Step 1.1: Look for the configuration file. *****/
    /*-----------------------------------------------------*/

    /* A single configuration file, which contains all parameter settings, is required. */
	if (argc == 2) 
	    strcpy(configFileName, argv[argc - 1]);      /* User provides a configuration file */
    else { 

		if (argc > 2)
			printf("Too many inputs. Program now terminates.\n");

		if (argc == 1)
			printf("Configuration file missing. Program now terminates.\n");

		exit(0);
	}

	/*----------------------------------------*/
	/***** Step 1.2: Read in the profile. *****/
	/*----------------------------------------*/

    if (!readProfile(configFileName, true)) { /* set the second parameter to true to enable verbose printout */
	    printf("Error found in configuration file.\n");
        return(1);
	}
	else
	{
		printf("---------------------------------------\n");
	    printf("Configuration file verification: PASSED\n");
		printf("---------------------------------------\n");
	}


	if (allow_bidirectional){
		printf("Allow bidirectional flow.\n");
	}else {
		printf("DO NOT allow bidirectional flow.\n");
	}



    crt_SetMaxInterpol(maxInterpol);
    crt_SetModelWeights(modelW1, modelW2, modelW3, modelW4, modelW5);

	temp = cos(maxAngle / 180 * 3.1415926535898);

    temp2 = cos(maxDeflectionAngle / 180 * 3.1415926535898);
    set_COS_THRESHOLD(temp, temp, temp2);
	
    /***** Parameter settings must be checked. *****/

	maxSpeedSqr = maxSpeed * maxSpeed;

#ifdef PARAMETER_CONFIGURATION_CHECK 
    printf("--------------------------------------------------\n");
	printf("Application Mode = %d\n", applicationMode);
    printf("Image Height = %d   Image Width = %d\n", image_height, image_width);
    printf("\nW1 = %8.5lf   W2 = %8.5lf   W3 = %8.5lf    [W4 = %8.5lf]  W5 = %8.5lf\n", modelW1, modelW2, modelW3, modelW4, modelW5);
    printf("totalFrameNum = %d  maxSpeed = %8.5lf  maxAngle = %8.5lf  maxPhi = %8.5lf\n", totalFrameNum, maxSpeed, maxAngle, maxPhi);
    printf("Intensity Cue = %1d  Flowmap Cue = %1d   Area Cue = %d\n", intensity_cue, flowmap_cue, area_cue);

#ifdef VERBOSE_INPUT	  

	if (verbose) {
		printf("Please take a moment to check these important parameter settings.\n");
		fflush(stdin);
		scanf(".");
	}

#endif
#endif


	pointReadMode = applicationMode;  /* no need to read area information */
	

    /*--------------------------------------*/
    /***** Step 1.3: Read in data files *****/
	/*--------------------------------------*/

   	/* Read in the original frame-by-frame coordinate file. */

	strcpy(fileNameBuffer, filePath);
	strcat(fileNameBuffer, pointFileName);
	strcpy(pointFileName,  fileNameBuffer);

    if ((f1 = fopen(pointFileName, "rt")) != NULL) {
        readSequence(f1, pointReadMode, &s);
        fclose(f1);
		printf("-------------------------------\n");
		printf("Point data file reading: PASSED\n");
		printf("-------------------------------\n");
	}  
	else {
        fprintf(stderr, "Point data file '%s' not found\n", pointFileName);
	    exit(0);
	}

    /*------------------------------------------------------*/
	/***** Step 1.4: Read intensity distribution files. *****/
	/*------------------------------------------------------*/
	if (intensity_cue != false) {
	    strcpy(fileNameBuffer, filePath);
	    strcat(fileNameBuffer, intensityProfileName);
	    strcpy(intensityProfileName, fileNameBuffer);

	    intensityProfile = new double[totalFrameNum * 2];
		intensityMinMax = new double[totalFrameNum * 2];

		if (!readIntensityProfile(intensityProfileName, intensityProfile, intensityMinMax, totalFrameNum)) {
		    printf("Error in intensity profile reading. Program now terminates.\n");
		    exit(0);
		}
		else {
			printf("---------------------------------\n");
			printf("Intensity profile reading: PASSED\n");
			printf("---------------------------------\n");
		}


#ifdef VERBOSE_INPUT	
			// printf("     MEAN        STD\n");
			// for (i = 0; i < totalFrameNum; i++)
		    // printf(" %10.8lf  %10.8lf\n", intensityProfile[2 * i], intensityProfile[2 * i + 1]); 

		if (verbose) {
				printf("Press ENTER to continue\n");
				fflush(stdin);
				scanf(".");
		}
#endif
	}

	/*------------------------------------------------------*/
	/***** Step 1.5: Read area distribution files. *****/
	/*------------------------------------------------------*/



	if (area_cue != false) {
	    strcpy(fileNameBuffer, filePath);
	    strcat(fileNameBuffer, areaProfileName);
	    strcpy(areaProfileName, fileNameBuffer);

	    areaProfile = new double[totalFrameNum * 2];
		areaMinMax = new double[totalFrameNum * 2];

		if (!readAreaProfile(areaProfileName, areaProfile, areaMinMax, totalFrameNum)) {
		    printf("Error in area profile reading. Program now terminates.\n");
		    exit(0);
		}else 
		{	
			 printf("----------------------------\n");
			 printf("Area profile reading: PASSED\n");
			 printf("----------------------------\n");
		}
	 


        #ifdef VERBOSE_INPUT	
			printf("     MEAN        STD\n");
			for (i = 0; i < totalFrameNum; i++)
			    printf(" %10.8lf  %10.8lf\n", areaProfile[2 * i], areaProfile[2 * i + 1]); 

			// printf("Please take a moment to check area profile. Press ENTER to continue\n");
			// fflush(stdin);
			// scanf(".");
        #endif
	}



	/*----------------------------------------*/
	/***** Step 1.6: Read flow map files. *****/
	/*----------------------------------------*/

	if (flowmap_cue != false) {

	    strcpy(fileNameBuffer,  filePath);
	    strcat(fileNameBuffer,  flowmapFileName);
	    strcpy(flowmapFileName, fileNameBuffer);

	    flowMap = new double[image_height * image_width * 2];  /* two components, i.e. 2D */
		if (readFlowMap(flowmapFileName, flowMap, image_height * image_width)){
             printf("-------------------------------\n");
			 printf("Flow constraint reading: PASSED\n");
			 printf("-------------------------------\n");
		}
		   
        tempFlowVecMag = 0; 
	    
		for (i = 0; i < image_height * image_width; i++) {
	        tempFlowVecMag = flowMap[2 * i] * flowMap[2 * i] + flowMap[2 * i + 1] * flowMap[2 * i + 1];
		    if (tempFlowVecMag < 1.e-6)
		  	    continue;  /* no vector given */
			if (fabs(tempFlowVecMag - 1.0) < 1e-3)
			    continue;

		    printf(" i= %d  %lf  %lf\n", i, flowMap[2 * i], flowMap[2 * i + 1]);
			printf("Error in flow map data: non-zero vector is not normalized. Program now terminates.\n");
			exit(0);
		}
		printf("-------------------------------------\n");
		printf("Flow constraint verification: PASSED.\n");
		printf("-------------------------------------\n");
        
#ifdef VERBOSE_INPUT	
		if (verbose) {
  				printf("Press ENTER to continue\n");
				fflush(stdin);
				scanf(".");
		}
#endif
	 }

	 
/*--------------------------------------------------------------------------------------------------------*/      
/***************************** Step 2: Data preparation for tracking **************************************/
/*--------------------------------------------------------------------------------------------------------*/      

	  /*------------------------------------------------------------*/
	  /***** Step 2.1: Make a backup of the original point data *****/
	  /*------------------------------------------------------------*/

	  cleanSequence(s);
	  frm_Copy(s, refSequence);   /* make a copy of the original frames */

#ifdef INPUTDATA_DIMENSION_CHECK
	  printf("Checking the frameID domain of each point.\n");
	
	  for (k = 0; k < s.len; k++) 
		  for (i = 0; i < s.frame[k].len; i++)
			  assert((s.frame[k].point[i].frameID == k));

	  printf("Total frame number = %d   s.len = %d\n", totalFrameNum, s.len);
      assert(s.len == totalFrameNum);

	  printf("----------------------------\n");
	  printf("FrameID domain check: PASSED\n");
	  printf("----------------------------\n");

	  // for (k = 0; k < s.len; k++) 
	  //	  printf("frameID = %d\n", s.frame[k].point[0].frameID);
	 

#ifdef VERBOSE_INPUT

	  if (verbose) {
  		  printf("Press ENTER to continue.\n");
		  fflush(stdin);
	      scanf(".");
	  }

#endif

#endif


	  /***** Step 2.2: Allocate memory for tracking. ******/
      for (k = 0; k < s.len; k++) {
          len = s.frame[k].len;
	      /* fprintf(stdout, "before: # of points in frame %d is %d\n", k, len); */
          extendPointList(s.frame[k], MAX_PT_NUM_PER_FRAME); 
          s.frame[k].len = len;  /* reset the length number. extendPointList basically sets the memory. */
		  s.frame[k].maxLen = MAX_PT_NUM_PER_FRAME;
	     /* fprintf(stdout, "after: # of points in frame %d is %d\n", k, len); */
	  } /* for */   

	  printf("--------------------------------------------------\n");

	  /***** Step 2.3: Check for frame numbers and point numbers *****/
	  frame_length_ctr = 0;   /* count how many frames */
	  numTotalPoints = 0;

	  for (i = 0; i < s.len; i++) {
          frame_length[frame_length_ctr++] = s.frame[i].len;

	 	  printf("Number of points in frame %d is %d\n", i, s.frame[i].len);
		  numTotalPoints += s.frame[i].len;

		  for (j = 0; j < s.frame[i].len; j++)
			  assert(s.frame[i].point[j].state == pnt_Normal);  /* check data integrity */
		  for (j = s.frame[i].len; j < s.frame[i].maxLen; j++)  /* check data integrity */
			  assert(s.frame[i].point[j].state == pnt_Empty);
	  }

#ifdef INPUTDATA_DIMENSION_CHECK
	  for (i = 1; i < refSequence.len; i++)
		  printf("SIZE of bipartite graph is %d\n", refSequence.frame[i].len + refSequence.frame[i-1].len);
#endif


	  printf("Total number of points is %d\n", numTotalPoints); 
	  printf("--------------------------------------------------\n");
	  printf("Verification of input point data: PASSED.\n");

	  /***** Step 2.4: Set output file names *****/
	  strcpy(fileNameBuffer, filePath);
	  strcat(fileNameBuffer, trackImageFileName);
	  strcpy(trackImageFileName, fileNameBuffer);

	  strcpy(fileNameBuffer, filePath);
	  strcat(fileNameBuffer, trackFileName);
	  strcpy(trackFileName, fileNameBuffer);

#ifdef VERBOSE_INPUT
	  if (verbose) {
  		  printf("Press ENTER to start tracking\n");
		  fflush(stdin);
	      scanf(".");
	  }
#endif

	  /***************************** Step 3: Track process **************************************/
        
      /* This is the kernel of the implementation. The source file is in goa_original.cpp */ 
	
	  //double varVMag, varVOri, varInt, varArea; 
	  
	  //for (i = 0; i < 4; i ++) {
 	  //    numTrackedPoints = 0;

          tkg_MakeTracks_BD(s, refSequence,
	 	  			        (crt_IndividualModel) criterion,	
                            maxSpeed, maxPhi, maxInterpol, minPresent,
                            verbose, minTrackLen, trackList, &numTrackedPoints);
		  /* ----------------------------------- Kernel ------------------------------------- */



          /* Recalculate parameters using the Kalman-filtering equivalence relation */  
	  //    varianceEstimation(trackList, varVMag, varVOri, varInt, varArea);

	  //    modelW1 = 1 / varVMag;
	  //    modelW2 = 1 / varVOri;
	  //    modelW3 = 1 / varInt;
	  //    modelW4 = 1 / varArea;

	  //    crt_SetModelWeights(modelW1, modelW2, modelW3, modelW4, modelW5);  /* Set weights */
	  //}
	                                                                     /* Set thresholds */
	  printf("Total number of TRACKED points is %d\n", numTrackedPoints);
	  fprintf(stdout, "Found %d tracks with total smoothness: %f\n",
                 trackList.num, trk_Smoothness(trackList, maxPhi)); 

	  /*********************** Step 4: Generate output record files *****************************/

      /***** Step 4.1: Generate output image *****/
	  numPlottedPoints = 0;

      if ((f2 = fopen(trackImageFileName, "wt")) != NULL) {
          saveTrackImage_BD(f2, widthImage, heightImage,
                           trackList, refSequence, &numPlottedPoints);

	      printf("Track image has been generated in PGM format .\n");
          fclose(f2);

		  printf("Total number of INITIAL points is %d\n", numTotalPoints);
		  printf("Total number of PLOTTED points is %d\n", numPlottedPoints);

		  if ( numTotalPoints != numPlottedPoints) 
			  printf("WARNING: some data points are not plotted");
      } 
	  else {
            fprintf(stderr, "Could not open '%s'\n", trackImageFileName);
      } /* if */


      /***** Step 4.2: Generate track file *****/
	  int tracked_pt_num = 0;
	  detected_track = trackList.num;
      printf("Total number of computed tracks is %d\n", detected_track);

      if ((f2 = fopen(trackFileName, "wt")) != NULL) {
	  	  for (i = 0; i < detected_track; i++) {
			  print_counter = 0;
			  if (applicationMode == 3)
				  fprintf(f2, "(%8.3lf  %8.3lf  %10.8lf) ", (double)trackList.track[i].first, (double)trackList.track[i].len, -1.000);
			  else
				  fprintf(f2, "(%8.3lf  %8.3lf  %10.8lf  %10.8lf) ", (double)trackList.track[i].first, (double)trackList.track[i].len, -1.000, -1.000);
			  print_counter++;

			  for (j = 0; j < trackList.track[i].len; j++) {
				  if (applicationMode == 3)
			  		  fprintf(f2,"(%8.3f  %8.3f  %12.8f) ", trackList.track[i].point[j].x, trackList.track[i].point[j].y, 
					  trackList.track[i].point[j].intensity); 
				  else
					  fprintf(f2,"(%8.3f  %8.3f  %12.8f  %10.6f) ", trackList.track[i].point[j].x, trackList.track[i].point[j].y,
					  trackList.track[i].point[j].intensity, trackList.track[i].point[j].area); 
				  print_counter++;
						
				  if (j == (trackList.track[i].len - 1)) {
					  fprintf(f2, ".\n");
					  print_counter = 0;
				  }
				  else {
				 	  if ((print_counter % 5) == 0) {
						  fprintf(f2, "\n");
					  }
				  }
			  }
		      tracked_pt_num += trackList.track[i].len;
		  }
		  fclose(f2);
		  printf("Record of tracking result has been generated. A total of %d points have been written\n", tracked_pt_num);

		  if (tracked_pt_num != numTotalPoints)
			  printf("WARNING: some points are missing in tracking.\n");
	  } 
      else {
        fprintf(stderr, "Could not open '%s'\n", trackFileName);
    } /* if */

#ifdef VERBOSE_INPUT	  
	    if (verbose) {
		    fflush(stdin);
		    scanf(".");
	    }
#endif

	// Add parameter adaptation here
    // Estimation of parameters: velocity, orientation, intensity, area

	return 0;
	
}