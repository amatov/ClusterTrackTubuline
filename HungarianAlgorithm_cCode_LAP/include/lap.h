/************************************************************************
*
*  lap.h
   version 1.0 - 21 june 1996
   author  Roy Jonker, MagicLogic Optimization Inc.
   
   header file for LAP
*
**************************************************************************/

/*************** CONSTANTS  *******************/

  #define BIG 1000000

/*************** TYPES      *******************/

  typedef int row;
  typedef int col;
  typedef int cost;

/*************** FUNCTIONS  *******************/

extern int lap_int(int dim, int *assigncost,
               int *rowsol, int *colsol, int *u, int *v);

extern void checklap_int(int dim, int *assigncost,
                     int *rowsol, int *colsol, int *u, int *v);

