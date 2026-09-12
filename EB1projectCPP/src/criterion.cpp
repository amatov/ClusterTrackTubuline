/*--------------------------------------------------------------------------------------/
SPECIAL CASE HANDLING IN COMPUTING VELOCITY & ORIENTATION CONTINUITY

                  o-------->o------->o
                  A   ->    B   ->   C
 frame index      1   ->    2   ->   3


VELOCITY CONTINUITY:

  (1) If A overlaps B or B overlaps C, but NOT BOTH, then velocity change is set to 1.
  (2) IF A, B and C overlap, the velocity change is set to 0.

ORIENTATION CONTINUITY:

  (1) If A overlaps B or B overlaps C, but NOT BOTH, then orientation change is set to 1.
  (2) IF A, B and C overlap, the orientation change is set to 0.


So, in summary,

  (1) If A overlaps B, or B overlaps C, but NOT BOTH, the cost return would be w1 + w2.
  (2) If A overlaps with B AND C, the cost return would be 0.


                               ----> IMPORTANT CHANGES <----

From newbuild006, the following logic is used

VELOCITY CONTINUITY:

  (1) If A overlaps B or B overlaps C, but NOT BOTH, then velocity change is set to 1.
  (2) IF A, B and C overlap, the velocity change is set to 0.

ORIENTATION CONTINUITY:

  (1) If A overlaps B or B overlaps C, but NOT BOTH, then orientation change is set to 0 (NOT 1).
  (2) IF A, B and C overlap, the orientation change is set to 0.


So, in summary,

  No longer consider orientation change anymore.

  (1) If A overlaps B, or B overlaps C, but NOT BOTH, the cost return would be w1.
  (2) If A overlaps with B AND C, the cost return would be 0.



Now users should be aware that this will certainly make the tracking result biased towards
continuous motion rather than schemes such as move-stop-move. Whether this is indeed 
the best way is up to experiments to verify. In practice, a "w1 + w2" will almost surely
lead to track break. However, this may be desirable for track velocity analysis since a
point stays at the same place is likely due to a movement in Z (depth) direction, which 
should not count in X-Y velocity computation. On the other hand, this may lead to errorneous
life-time estimation.


In general, this is a difficult decision but can be at least partly resolved by post
processing.

--------------------------------------------------------------------------------------*/

/***************************/
/*  STABLE RELEASE VER 1.1 */
/***************************/

#include <assert.h>
#include <math.h>
#include <float.h>
#include <stdio.h>
#include <stdlib.h>

#include "criterion.h"
#include "tracks.h"

#define PROTECT_ZERO_DIV   (1.0E-04)

#define STD_CHANGE_THRESHOLD   4.0     // four sigma rule 
#define PCT_MODE   1
/* if PCT_MODE = 1,   simple percentage
   if PCT_MODE = 2,   complex normalization
   if PCT_MODE = 3    STD
*/

#define BIDIR      // allow bidirection, i.e. support anti-parallel motion
#undef BIDIR       // disallow bidirection flow, i.e. particle motion can NOT form a larger than 90deg angle relative
                   // to vector field.
#define ORI_WEIGHT // weight cost using flow orientation
#undef ORI_WEIGHT  // do NOT weight cost using flow orientation


static int crt_MaxInterpol = -1;

/* default weight values */
static double crt_SmoothMotion_W1 = 0.9;
static double crt_SmoothMotion_W2 = 0.1;
static double crt_SmoothMotion_W3 = 0.0;
static double crt_SmoothMotion_W4 = 0.0;
static double crt_SmoothMotion_W5 = 0.0;

extern double maxSpeed; 
extern double maxPhi;
extern double maxAngle;
extern double maxDeflectionAngle;

static double INIT_COS_THRESHOLD; /* use orientation gating scheme, a (-30deg, +30deg) range */
static double COS_THRESHOLD;      /* use orientation gating scheme, a (-30deg, +30deg) range */

static double COS_DEFLECTION_ANGLE_THRESHOLD;

extern bool intensity_cue;  /* If true, use intensity cue */
extern bool flowmap_cue;    /* If true, use flow constraint cue */
extern bool area_cue;
extern bool allow_bidirectional;

extern double *intensityProfile;
extern double *areaProfile;
extern double *flowMap;

extern int image_height;
extern int image_width;

extern double intChangePctThreshold;
extern double areaChangePctThreshold;

void statCalc(double *seq, int N, double &seqAvg, double &seqVar);
void trackStat(trk_Track track,
			   double &avgTrkVMag,  double &varTrkVMag,
			   double &avgTrkVOri,  double &varTrkVOri,
			   double &avgTrkInt,   double &varTrkInt,
			   double &avgTrkArea,  double &varTrkArea);


static const int crt_CriterionOrderLookup[crt_NumIndividualModels] = {
   2,  // smooth-motion 
   1,  // nearest neighbor
   2,
};


/***** Basic management functions *****/

static PhiNormal phiNormal[crt_NumIndividualModels] = {
   crt_SmoothMotion,
   crt_NearestNeighbor,
   NULL
};

PhiNormal crt_CriterionNormal(crt_IndividualModel criterion)
{
   assert(crt_SmoothMotionIndex <= criterion && criterion <= crt_ProximalUniformIndex);
   return(phiNormal[criterion - crt_SmoothMotionIndex]);
}

static PhiInterpol phiInterpol[crt_NumIndividualModels] = {
   crt_SmoothMotionInterpol,
   crt_NearestNeighborInterpol,
   crt_ProximalUniformInterpol,
};

PhiInterpol crt_CriterionInterpol(crt_IndividualModel criterion)
{
   assert(crt_SmoothMotionIndex <= criterion && criterion <= crt_ProximalUniformIndex);
   return(phiInterpol[criterion - crt_SmoothMotionIndex]);
}


int crt_CriterionOrder(crt_IndividualModel criterion)
{
   return(crt_CriterionOrderLookup[criterion]);
}

void crt_SetMaxInterpol(int maxInterpol)
{
   crt_MaxInterpol = maxInterpol;
}



extern void set_COS_THRESHOLD(double cos1,  double cos2, double cos3) 
{
    INIT_COS_THRESHOLD = cos1;
	COS_THRESHOLD = cos2;
	COS_DEFLECTION_ANGLE_THRESHOLD = cos3;
}


/* Set the weight values for this specific function module */

void crt_SetModelWeights(double w1, double w2, double w3, double w4, double w5)
{
   crt_SmoothMotion_W1 = w1;  
   crt_SmoothMotion_W2 = w2;
   crt_SmoothMotion_W3 = w3;
   crt_SmoothMotion_W4 = w4;
   crt_SmoothMotion_W5 = w5;
}
/***************************************/


/****** Basic comparison operators *****/
inline bool Greater(double a, double b)
{
   return(a - b > FLT_EPSILON);
}

inline bool Less(double a, double b)
{
   return(b - a > FLT_EPSILON);
}

inline bool Equal(double a, double b)
{
   return(fabs(b - a) < 1e-4);
}
/***************************************/


/***** Basic math operators *****/
static inline double sqr(double x)
{
   return(x * x);
}

static inline double rotX(double x, double y, double a)
{
   return(x * cos(a) - y * sin(a));
}

static inline double rotY(double x, double y, double a)
{
   return(x * sin(a) + y * cos(a));
}

static inline int min(const int i, const int j)
{
   return(i < j ? i : j);
}
/********************************/

/***** Basic distance computation *****/
double squarePointDistance(const pnt_Point &p1, const pnt_Point &p2)
{
   return((double) (p1.x - p2.x) * (p1.x - p2.x) +
          (double) (p1.y - p2.y) * (p1.y - p2.y));
}

double crt_PointDistance(const pnt_Point &p1, const pnt_Point &p2)
{
   return(sqrt(squarePointDistance(p1, p2)));

}

double crt_PointAngle(const pnt_Point &p1, const pnt_Point &p2)
{
	return atan2(p1.x - p2.x, p1.x - p2.y);
}


/**************************************/

//typedef struct point_t {
//   float x, y;
//   float intensity;      /* Grey-level of the feature. */
//   float area;
//   unsigned char state;  /* '0' for normal, '1' for empty, others to be defined */
//   short frameID;        /* The frame in which this point resides */
//}  pnt_Point;


static bool pointsSame(const pnt_Point p1, const pnt_Point p2)
{

	assert(p1.state == pnt_Normal);
	assert(p2.state == pnt_Normal);

	if ((fabs(p1.x -p2.x) < 1e-3) &&
	    (fabs(p1.y -p2.y) < 1e-3) &&
	    (fabs(p1.intensity - p2.intensity) < 1e-3) &&
		(fabs(p1.area - p2.area) < 1e-3) &&
	    (p1.frameID == p2.frameID))
		return (true);
	else
		return (false);
}

static bool pointsOverlap(const pnt_Point p1, const pnt_Point p2)
{

	assert(p1.state == pnt_Normal);
	assert(p2.state == pnt_Normal);

	if ((fabs(p1.x -p2.x) < 1e-3) &&
	    (fabs(p1.y -p2.y) < 1e-3))
		return (true);
	else
		return (false);
}



static bool	cueChangeCalc(double m1, double m2, int mode, double threshold, double coef, double &tempCost) {
/* This function implements different definitions of similarity cost */

	assert((mode >= 1) && (mode <= 4));

	if (mode == 1) { /* Definition of percentage change */	   
		if (fabs((m1 - m2) / m1) > threshold) {  /* m1 is the source */
			tempCost = 0;
	   	    return (false);
		}
		else {

			tempCost = (m1 - m2 ) / m1;
		    tempCost = tempCost * tempCost;      /* square it */
			return (true);
		}
	}

	if (mode == 2) { /* A slightly different definition of percentage change */	   
		if (fabs((m1 - m2) / (m1 + m2)) > threshold) {
			tempCost = 0;
	   	    return (false);
		}
		else {

			tempCost = (m1 - m2 ) / (m1 + m2);
		    tempCost = tempCost * tempCost;
			return (true);
		}
	}


	if (mode == 3) { /* Absolute value change */	   
		if (fabs(m1 - m2) > threshold) {  /* Often the threshold is a STD */
			tempCost = 0;
	   	    return (false);
		}
		else {

			tempCost = (m1 - m2 ) / threshold;  /* Notice the normalization using the threshold value*/
		    tempCost = tempCost * tempCost;
			return (true);
		}
	}

	if (mode == 4) { /* Absolute value change */	   
		if (fabs(m1 - m2) > threshold) {  /* Often the threshold is a STD */
			tempCost = 0;
	   	    return (false);
		}
		else {

			tempCost = (m1 - m2 ) / coef;  /* Notice the normalization using the given coefficient value, which in most cases is the variance*/
		    tempCost = tempCost * tempCost;
			return (true);
		}
	}

	return (false);
}

bool flowMapConstraintCalc(pnt_Point p, pnt_Point q, double *flowMap, int image_width, double &result) {

	double dis_x, dis_y;
    double vec_x, vec_y;

	//int temp_x, temp_y, temp_addr;
	int temp_x, temp_y;

	double temp0, temp1, temp_cos; 
      

	/* First, check whether the two points overlap. If so, no need for using the constraint */
    dis_x = p.x - q.x;
    dis_y = p.y - q.y;
    
	temp1 = sqrt(dis_x * dis_x + dis_y * dis_y);   /* norm of displacement */

    if (temp1 < 1.0e-3){
		result = result;
	    return(true);  /* Basically, two points overlap. No need for orientation gating. 
                          This is also to prevent division by zero */
	}
 
	/* Second, look for possible flow constraint */
    temp_x = (int)p.x; /* along horizontal, or row, direction */
    temp_y = (int)p.y;  

    /* Step 2.1: compute lookup table index */ 
    /* When the flow map is generated, the data is written in a row-by-row (along the horizontal direction) fashion */

    // temp_addr = ((temp_y - 1) * image_width + (temp_x - 1)) * 2;  /* subtract 1 due to the zero offset indexing of C */
    // vec_x = flowMap[temp_addr];
    // vec_y = flowMap[temp_addr + 1];

	vec_x = p.otherFeatures[0];  // This is using the special data structure of EB1 points
	vec_y = p.otherFeatures[1];

    if ((fabs(vec_x) < 1.e-3) && (fabs(vec_y) < 1.e-3)) { /* no gating as no constraint definition is available */
		result = result;
	    return(true);
	}

    temp0 = vec_x * vec_x + vec_y * vec_y;
    assert(fabs(temp0 - 1) < 1e-3); /* check whether the vector is normalized, i.e. data integrity */

    temp0 = vec_x * dis_x + vec_y * dis_y;  /* dot product */
   
//#ifdef BIDIR
//    temp_cos = fabs(temp0 / temp1);  /* note: vec is already normalized */
//#else
//    temp_cos = (temp0 / temp1); /* WARNING: if this is selected, only those going along the flow direction will be allowed */
//#endif

//    if (allow_bidirectional)
//        temp_cos = fabs(temp0 / temp1);  /* note: vec is already normalized */
//    else
//        temp_cos = (temp0 / temp1); /* WARNING: if this is selected, only those going along the flow direction will be allowed */


	 temp_cos = fabs(temp0 / temp1);  /* note: always allow both direction */

	 if (temp_cos < INIT_COS_THRESHOLD)   /* Allow reflective direction change */
	     return(false);
     else {

#ifdef ORI_WEIGHT
	     result = (result) * INIT_COS_THRESHOLD / fabs(temp_cos); /* weight by orientation. However, temp_cos can be negative */
#else
		 result = result; /* weight by orientation using a simple WINDOWING scheme */
#endif
   		 return (true);

   }    

}


/* This function plays a critical role in the computation of costs. Here we must make sure that 
   NO INTERPOLATION will actually be performed. That is, if there is no previous point, a ZERO
   will be returned.
   */
static int getLast(const frm_Sequence &s,
				   int k,       /* current frame index */
				   int trj,     /* point index within this frame. Actually this is the row number or track index */
				   int points,  /* order, i.e. number of points required */
                   int dir,
				   pnt_Point *list,
				   int *first_valid,
				   pnt_Point &alt)
{
   int frame = k;
   int count = 0;

   int framePtr = 0;


   assert (dir == crt_Forward); /* SPECIFIC to my current tracking scheme, NO backward tracking used. */
   assert(points == 2);

   /* process the first point */
   assert (s.frame[k].point[trj].state == pnt_Normal);
   *first_valid = k;
   list[0] = s.frame[k].point[trj];


   if (s.frame[k - 1].point[trj].state == pnt_Empty) /* no previous point */
	   return (0);
   else {
	   list[1] = s.frame[k - 1].point[trj];

       if (pointsOverlap(list[1], list[0])) {

           /* now we need to go over those overlapping points */
		   framePtr = k - 2;

		   while ((framePtr >= 0) &&
			      (s.frame[framePtr].point[trj].state == pnt_Normal) &&
			      (pointsOverlap(s.frame[framePtr].point[trj], list[1])))
				
				  framePtr = framePtr - 1;


		   if ((framePtr >= 0) &&
			   (s.frame[framePtr].point[trj].state == pnt_Normal) &&
			   (!pointsOverlap(s.frame[framePtr].point[trj], list[1]))) {
				   alt = s.frame[framePtr].point[trj];

			       /* set the intensity */
			       alt.intensity = list[1].intensity;
				   alt.area = list[1].area;  // alt stands for "alternative choice "
		   }
	   }
	   return (2);
   }
}


/********************************** Nearestneighbor criterion *************************************/

bool crt_NearestNeighbor(const pnt_Point &p1, int d1,
                         const pnt_Point &p2, int d2,
                         const pnt_Point &p3,
                         double maxSpeed,
                         double &result)
/* So p2 is the track head and p3 is the potential candidate */
{

   double tempCost;
   double intTempThreshold, areaTempThreshold;
   double intTempSTD, areaTempSTD;
 

   //if ((PCT_MODE == 1) || (PCT_MODE == 2)) {
   //	   intTempThreshold = intChangePctThreshold;
   //	   areaTempThreshold = areaChangePctThreshold;  // copy from the globals
   //}


   //if (PCT_MODE == 3) {
   //	   intTempThreshold = STD_CHANGE_THRESHOLD * intensityProfile[2 * p2.frameID + 1];
   //	   areaTempThreshold = STD_CHANGE_THRESHOLD * areaProfile[2 * p2.frameID + 1];
   //}


   /***** Step 1: compute the distance first *****/
   assert(d2 == 1);
   result = crt_PointDistance(p2, p3);  

   if (result > maxSpeed)
	   return(false);

   result = result * result / maxSpeed / maxSpeed  * crt_SmoothMotion_W2;  
   // Initially, since we do not have an estimation of STD, just use a simple normalization. However, for area and intensity, STD estimations are available.

   /***** Intensity change gating *****/
   if (intensity_cue) {
	   intTempThreshold = 4 * intensityProfile[2 * p2.frameID + 1];  // 4 sigma rule
       intTempSTD = 2 * intensityProfile[2 * p2.frameID + 1];  // notice that you are looking at the difference between two Gauss distribution

	   if (!cueChangeCalc(p2.intensity, p3.intensity, 4, intTempThreshold, intTempSTD, tempCost))  // set coef = 1 to allow compiling
		   return (false);  // I have decided to choose Mahalanobis distance
	   else
	       result += crt_SmoothMotion_W3 * tempCost;  
   }
   /***** End intensity change gating *****/ 

  
   /***** Area change gating *****/
   if (area_cue) {
	   areaTempThreshold = 4 * areaProfile[2 * p2.frameID + 1];  // 4 sigma rule
       areaTempSTD = 2 * areaProfile[2 * p2.frameID + 1];  // notice that you are looking at the difference between two Gauss distribution

	   if (!cueChangeCalc(p2.area, p3.area, 4, areaTempThreshold, areaTempSTD, tempCost)) // set coef = 1 to allow compiling
		   return (false);
	   else
	       result += crt_SmoothMotion_W5 * tempCost;  
   }
   /***** End area change gating *****/

   
   /***** Flow map gating *****/
   flowmap_cue = true;
   if (flowmap_cue) {/* If no flowmap is defined, then no orientation gating */
	   if (!flowMapConstraintCalc(p3, p2, flowMap, image_width, result))  /* orientation weighting, if chosen, is here inside the function call */
		   return (false);
   }
   /***** End flow map gating *****/
   return (true);   

}

bool crt_NearestNeighborInterpol(const frm_Sequence &s, /* frame sequence */
								 int k,                 /* current frame ID */   
								 int t,                 /* index in current frame */ 
								 int dir,               /* direction */
                                 const pnt_Point &p,    /* destination point */
                                 double maxSpeed,
                                 double &result)
{
   //int order = crt_CriterionOrder(crt_ShortestPathIndex);
   //assert(order == 1);

   assert(s.frame[k].point[t].state == pnt_Normal);
   assert(p.state == pnt_Normal);

   
   return(crt_NearestNeighbor(s.frame[k].point[t], // ignored
		                          0, // ignored
                                  s.frame[k].point[t], /* if the point whose index is t in frame k is NORMAL, then it is list[0] */ 
								  1,
								  p,
                                  maxSpeed,
								  result));
}
/**************************************************************************************************/


/********************************** Smooth motion criterion *************************************/

/* This function, crt_SmoothMotion, is the only place to consider and implement all the special
   case handling explained at the beginning of this paragraph. 
*/

bool crt_SmoothMotion(const pnt_Point &p1, 
					  int d1,
                      const pnt_Point &p2, 
					  int d2,
                      const pnt_Point &p3,
                      double maxSpeed,
                      double &result)

/* Here the primary reason that d1 and d2 are needed is that INTERPOLATION may be done. 

   d1 : index difference between p1 and p2.
   d2 : index difference between p2 and p3.
*/
{
   double len0, len1, xx0, xx1, yy0, yy1;

   double intTempThreshold, areaTempThreshold;
   double intTempSTD, areaTempSTD;

   double tempIntCost, tempAreaCost;

   //if ((PCT_MODE == 1) || (PCT_MODE == 2)) {
   //   intTempThreshold = intChangePctThreshold;
   //   areaTempThreshold = areaChangePctThreshold;
   //}


   // if (PCT_MODE == 3) {
   //    intTempThreshold = STD_CHANGE_THRESHOLD * intensityProfile[2 * p2.frameID + 1];
   //    areaTempThreshold = STD_CHANGE_THRESHOLD * areaProfile[2 * p2.frameID + 1];
   //}

   flowmap_cue = false;

   if (intensity_cue) {
	   intTempThreshold = 4	* intensityProfile[2 * p2.frameID + 1];
       intTempSTD = 2 * intensityProfile[2 * p2.frameID + 1];
   }

   if (area_cue) {
       areaTempThreshold = 4 * areaProfile[2 * p2.frameID + 1];
       areaTempSTD = 2 * areaProfile[2 * p2.frameID + 1];
   }

   /***** Step 1: Check for data integrity *****/
   assert(p1.state != pnt_Empty);
   assert(p2.state != pnt_Empty);
   assert(p3.state != pnt_Empty); 
   /***** End step 1 *****/


   /*---------------------------------*/
   /***** Step 2: Distance gating *****/
   /*---------------------------------*/

   assert(d1 == 1);
   xx0 = (p1.x - p2.x);
   yy0 = (p1.y - p2.y);

   len0 = sqrt(xx0 * xx0 + yy0 * yy0);

   if (Greater(len0, maxSpeed))
      return(false);


   assert(d2 == 1);
   xx1 = (p2.x - p3.x);
   yy1 = (p2.y - p3.y);

   len1 = sqrt(xx1 * xx1 + yy1 * yy1);

   if (Greater(len1, maxSpeed))
      return(false);
  
   /***** End step 2 *****/


   /*-----------------------------------------*/
   /***** Step 3: Intensity change gating *****/
   /*-----------------------------------------*/
   if (intensity_cue) {

	   if (!cueChangeCalc(p2.intensity, p3.intensity, 4, intTempThreshold, intTempSTD, tempIntCost)) // set coef = 1 to allow compiling
		   return (false);
   }

   /*-----------------------------------------*/
   /***** Step 4: Area change gating *****/
   /*-----------------------------------------*/
   
   if (area_cue) {
	   if (!cueChangeCalc(p2.area, p3.area, 4, areaTempThreshold, areaTempSTD, tempAreaCost)) // set coef = 1 to allow compiling
		   return (false);
   }
   /***** End step 3 *****/
   /* So the p2p3 vector passes all previous gating schemes. */

   
   /***** Step 6: Special case handling *****/
   result = 0; 

   if (pointsOverlap(p1, p2)) { /* p1 & p2 overlap */
       if (pointsOverlap(p2, p3)) { /* p2 & p3 overlap.*/
           result = 0;  // Do NOT return here. Still need to consider other cues
	   }
	   else { /* p2 does NOT overlap p3 */
			
 		   result = crt_SmoothMotion_W2; /* This is a critical decision. Another */
	   }		   
	
	   if (intensity_cue) {
   		   result += crt_SmoothMotion_W3 * tempIntCost;
	   }

	   if (area_cue) {
		   result += crt_SmoothMotion_W5 * tempAreaCost;
	   }
		
		   
	   if (flowmap_cue) { /* otherwise tempVecMag is not defined. */
		   if (!flowMapConstraintCalc(p3, p2, flowMap, image_width, result))
				return (false);
	   }

	   return(true);    
   }
   

   if (pointsOverlap(p2, p3)) {  /* we already know that p1 does NOT overlap p2 */
       /* Again, we need to check for distance gating */
 		   result = crt_SmoothMotion_W2; /* This is a critical decision. Another */
		   
		   if (intensity_cue) {
      		   result += crt_SmoothMotion_W3 * tempIntCost;
		   }

		   if (area_cue) {
			   result += crt_SmoothMotion_W5 * tempAreaCost;
		   }
		
		   
		   if (flowmap_cue) { /* otherwise tempVecMag is not defined. */
			   if (!flowMapConstraintCalc(p3, p2, flowMap, image_width, result))
					return (false);
		   }

	   /* No need to consider orientation constrain */
	   return(true);    
   }

   /***** End step 5 *****/

   /* Now, the following handles regular cases. No overlap between p1, p2 and p3 */

   /* Check for integrity */
   assert(len1 > DBL_EPSILON);
   assert(len0 > DBL_EPSILON); 
 
   //printf("W3 = %lf  SIGMA = %lf\n", crt_SmoothMotion_W3, intensityProfile[2 * p2.frameID + 1] );

   result = crt_SmoothMotion_W1 * (1.0 - (xx0 * xx1 + yy0 * yy1) / (len0 * len1)) +   /* Direction smoothness */
		    crt_SmoothMotion_W2 * (1.0 - 2.0 * sqrt(len0 * len1) / (len0 + len1));    /* Velocity smoothness  */

   
   if (intensity_cue) {
	   result += crt_SmoothMotion_W3 * tempIntCost;
	}

   if (area_cue) {
	   result += crt_SmoothMotion_W5 * tempAreaCost;
   }

   if (flowmap_cue) {
	   if (!flowMapConstraintCalc(p3, p2, flowMap, image_width, result))
			return (false);

   }
   if (!checkDeflectionAngle(p1, p2, p3, COS_DEFLECTION_ANGLE_THRESHOLD))
       return (false);
 
                 /* Consistency with the flux field */   
   return(true);
}


bool crt_SmoothMotionInterpol(const frm_Sequence &s, 
							  int k,    /* index of current frame */
							  int t,    /* point index within this frame */
							  int dir,  /* direction */         
                              const pnt_Point &p,
                              double maxSpeed,
                              double &result)
{
   int len, first;
   int order = crt_CriterionOrder(crt_SmoothMotionIndex);

   double temp_distance;
   double tempIntensityCost = 0, tempStd = 0;
    
  
   pnt_Point alt = EmptyPoint; /* alternative point */

   /* pnt_Point list[order]; */
   pnt_Point list[5];  /* Maximum order is 2 */

   double tempIntCost, tempAreaCost;
   double intTempThreshold, areaTempThreshold;
   double intTempSTD, areaTempSTD;

  

   assert(p.state == pnt_Normal);  // check data integrity

   result = 0.0;
   if ((len = getLast(s, k, t, order, dir, list, &first, alt)) > 0) {
          /* Enough points are obtained to compute cost function. */ 
		  /* Here the trick is this. We check for the scenario between p1, p2 and p3. Then we decide how we want to 
		     pass the data. Now we know at least p1 exists. 

             (1) If we find p1 overlaps p2, now we check for whether p2 overlaps p3. 
			     If p1, p2, p3 overlap, pass them like this.

             (2) If we find p1 overlaps p2, but p2 does not overlap p3. Then we check
			     if "alt" is available at all. If so, pass alt, p2, p3. 
				 If not, pass p1, p2, p3. 
				 
			 These are the only cases that need to be dealt with. 
		  */

		  assert(k == first);
		  assert(len == 2);

		  if (pointsOverlap(list[1], list[0])) { /* p1, p2 overlap */
			  if (pointsOverlap(list[0], p))     /* p2, p3 overlap. normal passing */
				  return(crt_SmoothMotion(list[1], 
			                              1,        /* The point in frame k-1 */
                                          list[0], 
								          1,        /* k is the frame index of p, while first is the frame index of the first available point on
																   "list". */
								          p,
                                          maxSpeed, 
								          result));
			  else {  /* Check whether alt is available */
				  if (alt.state == pnt_Normal) { /* EmptyPoint = {0.0, 0.0, -1, pnt_Empty, -1};*/

					  assert(alt.x > 0);
					  assert(alt.y > 0);
					  assert(alt.intensity > 0);

					  if (area_cue)
						  assert(alt.area > 0);
					  assert(alt.frameID != -1);

					  return(crt_SmoothMotion(alt, 
			                              1,        /* The point in frame k-1 */
                                          list[0], 
								          1,        /* k is the frame index of p, while first is the frame index of the first available point on
																   "list". */
								          p,
                                          maxSpeed, 
								          result));
				  }
				  else
					  return(crt_SmoothMotion(list[1], 
			                              1,        /* The point in frame k-1 */
                                          list[0], 
								          1,        /* k is the frame index of p, while first is the frame index of the first available point on
																   "list". */
								          p,
                                          maxSpeed, 
								          result));
			  }

		  } else {/* p1, p2 do NOT overlap. Now just normal passing */
                  return(crt_SmoothMotion(list[1], 
	 		                              1,        /* The point in frame k-1 */
                                          list[0], 
					  			          1,        /* k is the frame index of p, while first 
																   is the frame index of the first available point on
																   "list". */
								          p,
                                          maxSpeed, 
								          result));
		  }

   } else { /* Not enough points are obtained for cost computation. */ 
		       /* CRITICAL: This part determines the initialization scheme ON FLY. */ 
		  
		    temp_distance = crt_PointDistance(list[0], p);
			if (temp_distance > maxSpeed)
				return(false);
            result = temp_distance * temp_distance / maxSpeed / maxSpeed  * crt_SmoothMotion_W2;

            /* Intensity gating */

			if (intensity_cue) {
			    intTempThreshold = 4 * intensityProfile[2 * list[0].frameID + 1];
				intTempSTD = 2 * intensityProfile[2 * list[0].frameID + 1];
				if (!cueChangeCalc(list[0].intensity, p.intensity, 4, intTempThreshold, intTempSTD, tempIntCost)) // set coef = 1 to allow compiling
					return (false);
				result += crt_SmoothMotion_W3 * tempIntCost;

			}

			if (area_cue) {
			    areaTempThreshold = 4 * areaProfile[2 * list[0].frameID + 1];
				areaTempSTD = 2 * areaProfile[2 * list[0].frameID + 1];
				if (!cueChangeCalc(list[0].area, p.area, 4, areaTempThreshold, areaTempSTD, tempAreaCost)) // set coef = 1 to allow compiling
					return (false);
				result += crt_SmoothMotion_W5 * tempAreaCost;
			}
			
			/* Consider orientation gating */
			if (flowmap_cue) {
				if (!flowMapConstraintCalc(p, list[0], flowMap, image_width, result))
					return (false);
			}
	  }
   return(true);
}

bool	checkDeflectionAngle(const pnt_Point p1, const pnt_Point p2, const pnt_Point p3, const double threshold){

       double len0, len1, xx0, xx1, yy0, yy1;
	   double temp_cos;

	   xx0 = p2.x - p1.x;
	   yy0 = p2.y - p1.y;

	   xx1 =p3.x - p2.x;
	   yy1 = p3.y - p2.y;

	   len0 = sqrt(xx0 * xx0 + yy0 * yy0);
	   len1 = sqrt(xx1 * xx1 + yy1 * yy1);

       temp_cos = (xx0 * xx1 + yy0 * yy1) / len0 /len1;

	   if (temp_cos < threshold)
		   return (false);
	   else
		   return (true);

}
/**************************************************************************************************/


/***** Mahalanobis distance *****/

bool crt_Mahalanobis( const pnt_Point &p1, 
                      const pnt_Point &p2, 
                      const pnt_Point &p3,
                      double covar_Matrix[],
                      double &result)
{
   double len0, len1, xx0, xx1, yy0, yy1;
   double dot_product, theta; 

   
   assert(p1.state != pnt_Empty);
   assert(p2.state != pnt_Empty);
   assert(p3.state != pnt_Empty); 

   
   xx0 = (p1.x - p2.x); 
   yy0 = (p1.y - p2.y); 

   len0 = sqrt(xx0 * xx0 + yy0 * yy0);

   xx1 = (p2.x - p3.x);
   yy1 = (p2.y - p3.y);

   len1 = sqrt(xx1 * xx1 + yy1 * yy1);

   dot_product = xx0 * xx1 + yy0 * yy1;
   theta = acos(dot_product / len0 / len1);


   /* Assume that direction and displacement are independent. */
   result = theta * theta / covar_Matrix[0] + (len1 - len0) * (len1 - len0) / covar_Matrix[3];


   return(true);
}
/*********************************/



/***** Criterion used in Chetverikov's paper *****/
static double computeC1(const frm_Sequence &s, int k)
{
   double c1 = 0.0;
   double xx0, yy0;
   double xx1, yy1;
   double dx, dy;
   int x, z;

   for (x = 0; x < s.frame[k].len; x++) {

      assert(s.frame[k - 1].point[x].state == pnt_Normal);

      assert(s.frame[k].point[x].state == pnt_Normal);

      xx0 = s.frame[k].point[x].x - s.frame[k - 1].point[x].x;
      yy0 = s.frame[k].point[x].y - s.frame[k - 1].point[x].y;

      for (z = 0; z < s.frame[k].len; z++) {

         xx1 = s.frame[k + 1].point[z].x - s.frame[k].point[x].x;
         yy1 = s.frame[k + 1].point[z].y - s.frame[k].point[x].y;

         dx = xx1 - xx0;
         dy = yy1 - yy0;

         c1 += sqrt(dx * dx + dy * dy);

      } /* for */
   } /* for */
   return(c1);
}

static double computeC2(const frm_Sequence &s, int k)
{
   double c2 = 0.0;
   double dx, dy;
   int x, z;

   for (x = 0; x < s.frame[k].len; x++) {
	   for (z = 0; z < s.frame[k+1].len; z++) {  /* changed by GY */
         dx = s.frame[k + 1].point[z].x - s.frame[k].point[x].x;
         dy = s.frame[k + 1].point[z].y - s.frame[k].point[x].y;

         c2 += sqrt(dx * dx + dy * dy);

      } /* for */
   } /* for */
   return(c2);
}

bool crt_ProximalUniformInterpol(const frm_Sequence &s, int k, int t, int dir,
                                 const pnt_Point &p,
                                 double maxSpeed,
                                 double &result)
{
   double c1 = computeC1(s, k);
   double c2 = computeC2(s, k);
   double xx0, yy0;
   double xx1, yy1;
   double dx, dy;

   assert(c1 > DBL_EPSILON);
   assert(c2 > DBL_EPSILON);

   xx0 = s.frame[k].point[t].x - s.frame[k - 1].point[t].x;
   yy0 = s.frame[k].point[t].y - s.frame[k - 1].point[t].y;

   xx1 = p.x - s.frame[k].point[t].x;
   yy1 = p.y - s.frame[k].point[t].y;

   dx = xx1 - xx0;
   dy = yy1 - yy0;

   result = sqrt(dx * dx + dy * dy) / c1 + sqrt(xx1 * xx1 + yy1 * yy1) / c2;

   return(true);
}

/*************************************************/


void varianceEstimation(trk_TrackList trackList, 
						double &varVMag_Seq_mean,
						double &varVOri_Seq_mean,
						double &varInt_Seq_mean,
						double &varArea_Seq_mean)

{

	int i, j;
	int minTrackLen = 5;
    int trackNum, trackLen;
	int counter = 0;

	trackNum = trackList.num;


	double *varVMag_Seq = new double[trackNum];
	double *varVOri_Seq = new double[trackNum];
    double *varInt_Seq = new double[trackNum];
	double *varArea_Seq = new double[trackNum];

	double avgTrkVMag, varTrkVMag, avgTrkVOri, varTrkVOri, avgTrkInt, varTrkInt, avgTrkArea, varTrkArea;

	

	for (i = 0; i < trackNum; i++){

        trackLen = trackList.track[i].len;

		if (trackLen < minTrackLen)
			continue;

		for (j = 0; j < trackLen; j++)
			trackStat(trackList.track[i], 
			          avgTrkVMag, varTrkVMag,
					  avgTrkVOri, varTrkVOri,
					  avgTrkInt, varTrkInt,
					  avgTrkArea, varTrkArea);

		varVMag_Seq[counter] = varTrkVMag;
		varVOri_Seq[counter] = varTrkVOri;
		varInt_Seq[counter] = varTrkInt;
		varArea_Seq[counter++] = varTrkArea;

	}

    // Now we calculate the variance

	double temp;

	statCalc(varVMag_Seq, counter, varVMag_Seq_mean, temp);
	statCalc(varVOri_Seq, counter, varVOri_Seq_mean, temp);
	statCalc(varInt_Seq, counter, varInt_Seq_mean, temp);
	statCalc(varArea_Seq, counter, varArea_Seq_mean, temp);
}
void statCalc(double *seq, int N, double &seqAvg, double &seqVar)
{
	int i;
	double tempSum;

	tempSum = 0;
	for (i = 0; i < N; i++) {
		tempSum = tempSum + seq[i];
	}
	seqAvg = tempSum / N;

    tempSum = 0;
	for (i = 0; i < N; i++) {
		tempSum = tempSum + (seq[i] - seqAvg) * (seq[i] - seqAvg);
	}

	seqVar = tempSum / (N - 1);

}

void trackStat(trk_Track track,
			   double &avgTrkVMag,  double &varTrkVMag,
			   double &avgTrkVOri,  double &varTrkVOri,
			   double &avgTrkInt,   double &varTrkInt,
			   double &avgTrkArea,  double &varTrkArea)
{
	int i, trackLen;
	trackLen = track.len;
	
	double *trkVMag = new double[trackLen];
	double *trkVOri = new double[trackLen];
    double *trkInt = new double[trackLen];
	double *trkArea = new double[trackLen];

    int counter1 = 0, counter2 = 0;
	
	for (i = 1; i <= trackLen; i++){
		trkVMag[counter1] =  crt_PointDistance(track.point[i] , track.point[i-1]);
		trkVOri[counter1] =  crt_PointAngle(track.point[i], track.point[i - 1]);
		trkInt[counter1] = fabs(track.point[i-1].area - track.point[i].area);
	    trkArea[counter1++] = fabs(track.point[i-1].intensity - track.point[i].intensity);
	}

    statCalc(trkVMag, counter1, avgTrkVMag, varTrkVMag);
	statCalc(trkVOri, counter1, avgTrkVOri, varTrkVOri);
	statCalc(trkInt, counter1, avgTrkInt, varTrkInt);
	statCalc(trkArea, counter1, avgTrkArea, varTrkArea);
}