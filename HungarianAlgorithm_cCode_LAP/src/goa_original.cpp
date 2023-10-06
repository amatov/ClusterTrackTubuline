/***************************************************************************************
  
  DESCRIPTION                 This software is developed for the tracking of large
							  numbers of densely populated moving point features
							  that constantly undergo birth/death and merge/split.
							  
							
							  In this release, each point feature is allowed
							  to have the following properties(tracking cues):

									2D position: namly, its (X, Y) coordinate
									intensity:   namely, the gray level. However, 
									             this feature can be turned off.

                              In addition, each position in the image plane is 
							  associated with a nomalized flow vector, which defines 
							  the most likely orientation of feature movement. 
							  This vector is used in both similarity cost (graph node
							  connection weight) computation and track initialization.
							  Again, this feature can be turned off.

								  
  ACKNOWLEDGEMENT 		      To maximize productivity, this implementation uses
							  some functions and definitions developed by Dr.Cor J. 
							  Veenman in his GOA tracker software for the paper:

							  Veenman, C.J., Reinders, M.J.T., Backer, E., 
							  Resolving Motion Correspondence for Densely Moving
							  Points. IEEE Transactions on Pattern Analysis and
							  Machine Intelligence, vol. 23, no. 1, pp. 54-72,
							  January 2001
								  
							  In particular, many of the service modules are used
							  with minor or no changes. 
							  
								               <------------->

							  However, FUNDAMENTAL CHANGES have been made to the
							  algorithms and data structure, and also to the
							  organization of the program. 

								               <------------->

 
  AUTHOR                      Ge Yang, Ph.D. 
                              geyang@scripps.edu
                              Laboratory for Computational Cell Biology
							  Department of Cell Biology
                              The Scripps Research Institute
 
  DATE OF CREATION            May 27, 2004

  RELEASE                     ver 0.7 (Stable release 0)    August 16, 2004
							  ver 0.8 (Stable release 1.0)  August 25, 2004
							  ver 0.9 (Stable release 1.1)  August 27, 2004
                              

  
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
                              
                                
  BUG REPORT:				  geyang@scripps.edu

****************************************************************************************/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <float.h>
#include <assert.h>
#include <time.h>


#include "main_const.h"
#include "tracking.h"
#include "criterion.h"
#include "lap.h"

#define DEBUG
#define inf (1000000)

#include "lap_real_readonly.cpp" /* leave out the LAP kernel. No need to change it. */

//extern int frame_length[500];      /* array to save the number of points in each frame. */
//extern int frame_length_ctr;   /* count how many frames */


static inline bool Greater(double a, double b)
{
   return(a - b > FLT_EPSILON);
}

static double EnclideanDistance(pnt_Point point1, pnt_Point point2)
{
	double temp = 0;
		temp = (point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y);
    return (sqrt(temp));

}

static bool computeTrackStats(frm_Sequence &s, int objects,
                              crt_IndividualModel criterion,
                              double maxPhi,
                              double &phiMax, double &phiTot)
{
   PhiInterpol phi = crt_CriterionInterpol(criterion);
   int i, kk, k, delta = 1;
   double diik;

   phiMax = phiTot = 0.0;

   /* phiTot is the total similarity cost */

   /* phiMax is the ACTUAL phiMax based on computation */

   for (kk = 1; kk < s.len - 1; kk++) {

      k = kk;

      for (i = 0; i < objects; i++) {
         if (s.frame[k + delta].point[i].state == pnt_Normal
          && phi(s, k, i, crt_Forward, s.frame[k + delta].point[i],
                 DBL_MAX, diik)) {
            if (Greater(diik, phiMax)) {
               phiMax = diik;
            } /* endif */
            phiTot += diik;
         } /* endif */
      } /* endfor */
   } /* endfor */
   return(true);
}



/**************************** buildBipartiteGraph_new **********************************/

void buildBipartiteGraph_new( frm_Sequence &s,
							  frm_Sequence &sref,
							  int k, /* k is the index of the source frame. The other one will be frame k + dir */
                              int order, 
							  crt_IndividualModel criterion,
                              crt_Direction dir,
                              double maxSpeed,
							  double maxPhi,
                              double cc[], 
							  int kk[], 
							  int first[]
						    )
{

   PhiInterpol phi = crt_CriterionInterpol(criterion);
   int delta = dir == crt_Forward ? 1 : -1;
   int i, j, p, m, imap;
   double cost;
   int numLinks = 0;
   double dist;

   int *fm1_index, *fm2_index;
   int fm1_ctr = 0, fm2_ctr = 0;


   /***** Step 1 : record all the NON-EMPTY points, check for data integrity *****/
   
   fm1_index = new int[s.frame[k].len];    
   fm2_index = new int[s.frame[k + delta].len];    

   for (i = 0; i < s.frame[k].len; i++)
	   if (s.frame[k].point[i].state != pnt_Empty)
		   fm1_index[fm1_ctr++] = i;  /* Record indices of all the NON-EMPTY points */

   for (j = 0; j < s.frame[k + delta].len; j++)
	   if (s.frame[k + delta].point[j].state != pnt_Empty)
		   fm2_index[fm2_ctr++] = j;  /* Record indices of all the NON-EMPTY points */

   assert(fm1_ctr == sref.frame[k].len);         /* Check for integrity */
   assert(fm2_ctr == sref.frame[k + delta].len); /* Check for integrity */

   delete [] fm1_index;
   delete [] fm2_index;


   /* Here the primary issue to be addressed is the cost calculation. Enclidean distance
      calculation is OK. */

   /* Two primary issues:
      (1) You need to map the point of "sref" back to "s".
	  (2) You need to map the correspondence computed for "sref" back to "s".
   */


   /***** Step 2: compute all connection costs *****/
   for (i = 0; i < sref.frame[k].len; i++) {
       
	   first[i + 1] = numLinks + 1;  /* This is for sparse matrix representation. first is an array. 
									    It records the position to look for connection costs in cc. The indices
	                                    of first ITSELF represents the ROW NUMBER. The column number is determined
	                                    by kk. */

	                                 /* It seems that first, cc, kk all use offset 1, NOT 0 */ 

	   /* Map the point into the CURRENT ACTIVE frame. This only needs to be done once. */

       /* When computing connection cost, we must go back to the true "s" structure since only there 
	      you can find active connection status. */

	   for (m = 0; m < s.frame[k].len; m++)
		   if ((fabs(s.frame[k].point[m].x - sref.frame[k].point[i].x) < 1.0e-6) &&
			   (fabs(s.frame[k].point[m].y - sref.frame[k].point[i].y) < 1.0e-6) &&
			   (fabs(s.frame[k].point[m].intensity - sref.frame[k].point[i].intensity) < 1.0e-6) && 
			   (fabs(s.frame[k].point[m].area - sref.frame[k].point[i].area) < 1.0e-6) && 
			   (s.frame[k].point[m].frameID == sref.frame[k].point[i].frameID) &&
			   (s.frame[k].point[m].state == sref.frame[k].point[i].state)) {

			   imap = m;
			   break; /* got it. */
		   }


       for (j = 0; j < sref.frame[k + delta].len; j++) {
	
		   /* Map the point back into "s" so that cost can be calculated. The following variables are needed 
		   
		   k : frame number, this is already known. No mapping needed.
           dir : known, no mapping needed.
           maxSpeed: known, no mapping needed.

		   s.frame[k + delta].point[j] --> sref.frame[k + delta].point[j]; all we need is the point. 
		   
		   so all we need is to find out imap, which is the mapping of i back into s. 
		   
		   */
           
		   dist=EnclideanDistance(sref.frame[k + delta].point[j], sref.frame[k].point[i]);

		   if (phi(s, k, imap, dir, sref.frame[k + delta].point[j], maxSpeed, cost)) {
		   	   if (!Greater(cost, maxPhi)) {
				   assert(dist <= maxSpeed); /* Check for program integrity */
				   cc[++numLinks] = cost;
				   kk[numLinks] = j + 1;
			   } else {
				   assert(dist <= maxSpeed); /* Check for program integrity */
			       cc[++numLinks] = maxPhi;
                   kk[numLinks] = j + 1;
			   }
		   } /* if */
      } /* for */
      cc[++numLinks] = maxPhi;
      kk[numLinks] = sref.frame[k + delta].len + i + 1;
   } /* for */

   first[i + 1] = numLinks + 1;  // first[sref.frame[k].len + 1] = numLinks + 1;

   for (i = 0; i < sref.frame[k + delta].len; i++) {
      first[sref.frame[k].len + i + 1] = numLinks + 1;
      cc[++numLinks] = maxPhi;
      kk[numLinks] = i + 1;
      for (j = 0; j < sref.frame[k].len; j++) {
         for (p = first[j + 1]; p < first[j + 2] - 1; p++) {// skip slave node
            if (kk[p] == i + 1) {
               cc[++numLinks] = 0;  // SET 0 to avoid adding cost twice.
               kk[numLinks] = sref.frame[k + delta].len + j + 1;
            } /* if */
         } /* for */
      } /* for */
   } /* for */

   first[sref.frame[k].len + i + 1] = numLinks + 1;

}

/****************** end of buildBipartiteGraph_new *******************************/

/***************************** GreedyAssign_BD **********************************/

static bool GreedyAssign_BD(frm_Sequence &s, 
							frm_Sequence &sref,
							int frames,
                            crt_IndividualModel criterion,
                            double maxSpeed, double maxPhi,
                            int maxInterpol, int minPresent,
                            crt_Direction dir)
{
   bool changed = false;
   int i, k, kk, j, m, n;
   int order = crt_CriterionOrder(criterion);
   int delta;
   int NEIGHBOR_NUM_MAX = 600;  /* maximum number of neighbors, limiting factor is maxSpeed. */

   clock_t start, finish;

   assert(order > 0);
   delta = dir == crt_Forward ? 1 : -1;

   printf("frames = %d \n", frames);
   for (kk = order - 1; kk < frames - 1; kk++) {

      k = dir == crt_Forward ? kk : frames - kk - 1;

	  fprintf(stdout, "k = %d  kk = %d frame length = %d \n", k, kk, s.frame[k].len);
      
	  int size = sref.frame[k].len + sref.frame[k + delta].len; /* consider NON-EMPTY points only */

	  printf("------------------------------------------------------\n");
	  fprintf(stdout, "\nOriginal sequence:  size = %d\n\n", size);

      int *col = new int[size * NEIGHBOR_NUM_MAX + 1];
	  int *first = new int[size + 2];
      int *x = new int[size + 1];
      int *y = new int[size + 1];
	  double *u = new double[size + 1];
      double *v = new double[size + 1];
      double  *cc = new double[size * NEIGHBOR_NUM_MAX + 1];


	  int *sref_frm1_mapping = new int[sref.frame[k].len];         /* The mapping of sref(k) points back to s(k) */ 
	  
	  int flag = 0;


	  /***** We need to map sref(k) into s(k) *****/
      /* Assignment is done between sref(k) and sref(k + 1) */
  
      for (m = 0; m < sref.frame[k].len; m++) {
		  flag = 0;
		  for (n = 0; n < s.frame[k].len; n++)
			  if ((fabs(sref.frame[k].point[m].x - s.frame[k].point[n].x) < 1.0e-6) &&
			      (fabs(sref.frame[k].point[m].y - s.frame[k].point[n].y) < 1.0e-6) &&
				  (fabs(sref.frame[k].point[m].intensity - s.frame[k].point[n].intensity) < 1.0e-6) &&
				  (fabs(sref.frame[k].point[m].area - s.frame[k].point[n].area) < 1.0e-6) &&
				  (sref.frame[k].point[m].state == s.frame[k].point[n].state)) {
	              sref_frm1_mapping[m] = n; 	
				  flag = 1;
				  break; /* got it. */
			   }

		  assert(flag !=0);
	  }


	  printf("Order = %d  delta = %d\n", order, delta);

      start = clock();
      buildBipartiteGraph_new(s, sref, k, order, criterion, dir,                           
		  maxSpeed, maxPhi, cc, col, first);
	  finish = clock();
	  printf("\nTime to build bipartite graph is %10.2lf seconds\n\n", (double)(finish - start) /CLOCKS_PER_SEC);
      
	  fprintf(stdout, "Bipartite graph building is done.\n"); /* again, notice the mapping is between sref(k) and sref(k+1) */
 

	  double tempcost = 0;
      start = clock();
	  tempcost = lap(size, cc, col, first, x, y, u, v);
	  finish = clock();
	  printf("\nTime to compute LAP assignment is %10.2lf seconds\n\n", (double)(finish - start) /CLOCKS_PER_SEC);


	  printf("LAP cost = %10.3lf\n", tempcost);

	  for (j = 0; j < s.frame[k + delta].len; j++)
		  s.frame[k + delta].point[j] = EmptyPoint;  /* Clear the memory to prepare for writing in new points */

      for (i = 0; i < sref.frame[k].len; i++) {
	  	 if (x[i + 1] <= sref.frame[k + delta].len) {
            //s.frame[k + delta].point[sref_frm1_mapping[i]] = points[sref_frm2_mapping[x[i + 1]]];
            s.frame[k + delta].point[sref_frm1_mapping[i]] = sref.frame[k + delta].point[x[i + 1] - 1]; 
			assert(s.frame[k].point[sref_frm1_mapping[i]].state != pnt_Empty);

         } else {
            s.frame[k + delta].point[sref_frm1_mapping[i]] = EmptyPoint; /* terminate this track */
         } /* if */
      } /* for */

	  
	  int len = s.frame[k].len;

      /* It turns out to be very important to compact track representation. 
	     So what we do first is to find an empty element. Then if find one, put the new point there. */ 

	  int current_first_zero_pos = 0;
      int p;
	  int found_flag = 0;

      for (i = 0; i < sref.frame[k + delta].len; i++) {
          if (y[i + 1] > sref.frame[k].len) {  /* a new track to be added */

			  found_flag = 0;
			  for (p = current_first_zero_pos; p < s.frame[k].len; p++)
			      if (s.frame[k].point[p].state == pnt_Empty) {
				      current_first_zero_pos = p;
				      found_flag = 1;
					  //printf("k = %d, find an empty spot %d\n", k, p);
				  break;
				  
			  }
              if (found_flag ==0 )
					s.frame[k + delta].point[len++] = sref.frame[k + delta].point[i];  /* Add a new row for the new track.
			                                                                              Just need the point value. */
			  else {
				  assert(s.frame[k+delta].point[current_first_zero_pos].state == pnt_Empty); /* make sure it is not occupied. */
				  assert(s.frame[k].point[current_first_zero_pos].state == pnt_Empty);
				  
				  
				  s.frame[k+delta].point[current_first_zero_pos] = sref.frame[k + delta].point[i];
				  current_first_zero_pos++; /* pass this zero, of course */
			  }
         } /* if */
      } /* for */

      s.frame[k + delta].len = len;
      
      delete [] cc;
      delete [] x;
      delete [] y;
      delete [] u;
      delete [] v;
	  delete [] col;
	  delete [] first;
	  delete [] sref_frm1_mapping;

	  printf("Frame %d out of a total of %d is done.\n", k, sref.len);

   } /* endfor */

   return(changed);
}

/************************** end of GreedyAssign_BD ******************************/


/* ****************************** tkg_MakeTracks_BD  ********************************** */  

/* Here we will NOT give the number of objects. */


bool tkg_MakeTracks_BD(frm_Sequence &s, frm_Sequence &sref,
	                   crt_IndividualModel criterion,
                       double maxSpeed, double maxPhi,
                       int maxInterpol, int minPresent,
                       bool verbose,
                       int minTrackLen, 
				  	   trk_TrackList &trackList,
					   int *numTrackedPoints)
{


    int i;
    //int j;
    int counter = 0;
  

	/***** STEP 1: Initialization of the first two frames based on NEAREST NEIGHBOR *****/
    GreedyAssign_BD(s, sref, 2, 
                    crt_ShortestPathIndex,
                    maxSpeed, maxSpeed, maxInterpol, minPresent, crt_Forward);

    fprintf(stdout, "First 2 frames done.\n");

    counter = 0;
    for (i = 0; i < s.frame[1].len; i++)
	    if (s.frame[1].point[i].state == 0)
		    counter++;
	printf("counter = %d\n", counter);
  
	/* Move on to the rest of the sequence */
    AssignBidir_BD(s, sref, s.len, criterion,
               maxSpeed, maxPhi, maxInterpol, minPresent);

    printf("Returned from AssignBidir_BD, now starting collecting tracks.\n");
    collectTracks_BD(s, minTrackLen, trackList, numTrackedPoints);

    return(true);
}

/* **************************  end of  tkg_MakeTracks_BD  ***************************** */


/* ****************************** AssignBidir_BD  ********************************** */  

/* Here you can choose whether to use bidirectional assignment */

static bool AssignBidir_BD(frm_Sequence &s, frm_Sequence &sref, int frames, 
                         crt_IndividualModel criterion,
                         double maxSpeed, double maxPhi,
                         int maxInterpol, int minPresent)
{
   /* Optimize in FORWARD direction */
   GreedyAssign_BD(s, sref, frames, criterion,
                maxSpeed, maxPhi, maxInterpol, minPresent,
                crt_Forward);

   /* Optimize in BACKWARD direction */
   //GreedyAssign_BD(s, sref, frames - 1, criterion,
   //             maxSpeed, maxPhi, maxInterpol, minPresent,
   //             crt_Backward);

   return(true);
}

/* **************************  end of AssignBidir_BD  ***************************** */


/************************ addRowTracks_BD ******************************/

static void addRowTracks_BD(frm_Sequence &s, int row,
                         int minTrackLen, 
						 trk_TrackList &trackList,
						 int* numTrackedPoints)
{
   int k, first_frame;
   int frame_pointer; 
   /* pnt_Point list[s.len]; */
   trk_Track track;
   pnt_Point *list;


#ifdef DEBUG
//   fprintf(stdout, "---------s.len = %d-----------\n", s.len);
#endif


   list = (pnt_Point *) malloc (s.len * sizeof(pnt_Point));

   frame_pointer = 0;
   /* skip INITIAL empty points */
   while  ((frame_pointer <= (s.len - 1)) && (s.frame[frame_pointer].point[row].state == pnt_Empty)) {  
	   if  (s.frame[frame_pointer].point[row].state == pnt_Empty)
		   frame_pointer++;
	   if (frame_pointer > (s.len - 1))
		   break;
   }


   while (frame_pointer <= (s.len - 1)) {
	   k = 0;
	   first_frame = frame_pointer + 1;   /* This is a critical correction. Here adding 1 is because we
										     assume frame starts from number 1. It is critical to record
	                                         the correct ID of the first frame */

	   do {
		   list[k] = s.frame[frame_pointer].point[row];
	       k++;
		   (*numTrackedPoints)++;
		   frame_pointer++;
		   if (frame_pointer > (s.len - 1))
			   break;
	   } while (s.frame[frame_pointer].point[row].state != pnt_Empty);

       trk_CreateTrack(track, list, first_frame, k);
	   trk_AppendTrack(trackList, track);
	  
	   while  ((frame_pointer <= (s.len - 1)) && (s.frame[frame_pointer].point[row].state == pnt_Empty)) {  /* skip empty points */
	       if  (s.frame[frame_pointer].point[row].state == pnt_Empty)
	            frame_pointer++;
	       if  (frame_pointer > (s.len - 1))
		        break;
	   }
   } /* if */
}


/******************* End of addRowTracks_BD ****************************/


/* **************************  collectTracks_BD  ***************************** */


static void collectTracks_BD(frm_Sequence &s, 
                             int minTrackLen, 
						     trk_TrackList &trackList,
							 int* numTrackedPoints)
{
   int i;
   int max_len;

   assert(trackList.track == NULL);

   trk_Create(trackList, MAX_TOTAL_TRACK_NUM);
   *numTrackedPoints = 0;


   /* Frame sequence structure "s" saves the entire tracking record, including the correspondance relation. */
   max_len = 0;
   for (i = 0; i < s.len; i++)
	   if (s.frame[i].len > max_len)
		   max_len = s.frame[i].len;  /* find the maximum of ROW number */


   for (i = 0; i < max_len; i++) {
       addRowTracks_BD(s, i, minTrackLen, trackList, numTrackedPoints);
   } /* for */
}
/* **********************  end of collectTracks_BD  ************************** */


/**************************** buildBipartiteGraph_original **********************************/

void buildBipartiteGraph_original(frm_Sequence &s,
								   int k, /* k is the index of the source frame. The other one will be frame k + dir */
                                   int order, 
								   crt_IndividualModel criterion,
                                   crt_Direction dir,
                                   double maxSpeed,
								   double maxPhi,
                                   double cc[], 
								   int kk[], 
								   int first[] 
								  )

// Explanation of the construction:
// cc is the cost vector (in compact form, not a matrix) 
// first:   first[i] records that in cc, the index of the element that is the first used one in that row
// kk: records the corresponding column number

{

   PhiInterpol phi = crt_CriterionInterpol(criterion);
   int delta = dir == crt_Forward ? 1 : -1;
   int i, j, p;
   double cost;
   int numLinks = 0;
   
   double dist;

   for (i = 0; i < s.frame[k].len; i++) {
      first[i + 1] = numLinks + 1;
      for (j = 0; j < s.frame[k + delta].len; j++) {
         if ((s.frame[k + delta].point[j].state == pnt_Normal)
          && phi(s, k, i, dir, s.frame[k + delta].point[j],
                 maxSpeed, cost)
          && !Greater(cost, maxPhi)) {

			dist=EnclideanDistance(s.frame[k + delta].point[j], s.frame[k].point[i]);

			if ( dist > maxSpeed) {
				//printf("Maximum speed violated. %lf\n", dist);
				//cc[++numLinks] = maxPhi * 2;
				//	kk[numLinks] = j + 1;  
			    //fflush(stdin);
				//scanf(".");
			}
			else
			{
					cc[++numLinks] = cost;
					kk[numLinks] = j + 1;
			}

         } else {
            //fprintf(stderr, "*******\n");
           	dist=EnclideanDistance(s.frame[k + delta].point[j], s.frame[k].point[i]);

			if (dist <= maxSpeed) {
			    cc[++numLinks] = maxPhi;
                kk[numLinks] = j + 1;
			}
         } /* if */

      } /* for */
      cc[++numLinks] = maxPhi;
      kk[numLinks] = s.frame[k + delta].len + i + 1;
   } /* for */

   first[i + 1] = numLinks + 1;

   for (i = 0; i < s.frame[k + delta].len; i++) {
      first[s.frame[k].len + i + 1] = numLinks + 1;
      cc[++numLinks] = maxPhi;
      kk[numLinks] = i + 1;
      for (j = 0; j < s.frame[k].len; j++) {
         for (p = first[j + 1]; p < first[j + 2] - 1; p++) {// skip slave node
            if (kk[p] == i + 1) {
               cc[++numLinks] = 0;
               kk[numLinks] = s.frame[k + delta].len + j + 1;
            } /* if */
         } /* for */
      } /* for */
   } /* for */

   first[s.frame[k].len + i + 1] = numLinks + 1;

   printf("----numLinks = %d ----\n", numLinks);
}

/****************** end of buildBipartiteGraph_original *******************************/

