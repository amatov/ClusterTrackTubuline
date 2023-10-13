/************************************************************************
*
*  lap.h
   version 1.0 - 21 june 1996
   author  Roy Jonker, MagicLogic Optimization Inc.
   
   header file for LAP
*
**************************************************************************/

/*************** CONSTANTS  *******************/

  #define BIG 100000

/*************** TYPES      *******************/

  typedef double row;
  typedef double col;
  //typedef int cost;
  typedef double cost;

/*************** FUNCTIONS  *******************/

extern double lap_1_0(int dim, double *cost1D,
               int *rowsol, int *colsol, double *u, double *v);

extern void checklap(int dim, int **assigncost,
                     int *rowsol, int *colsol, int *u, int *v);

