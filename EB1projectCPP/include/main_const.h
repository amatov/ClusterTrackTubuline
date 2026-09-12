#define DEBUG


/****************************************/

/* Compiler control */
#define BENCH_TESTING
#undef BENCH_TESTING

#define PARAMETER_CONFIGURATION_CHECK 
//#undef PARAMETER_CONFIGURATION_CHECK   

#define INPUTDATA_DIMENSION_CHECK
//#undef INPUTDATA_DIMENSION_CHECK
/****************************************/

/*****************************************************/
#ifndef PROGRAM_OPTION_CONST
#define PROGRAM_OPTION_CONST

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
   MAX_ANGLE,
   MAX_DEFLECTION_ANGLE,
   MIN_PRESENT,
   MIN_TRACK_LEN,
   MODEL_W1,
   MODEL_W2,
   MODEL_W3,
   MODEL_W4,
   MODEL_W5,
   VERBOSE,
   WIDTH_IMAGE,
   IMAGE_HEIGHT,
   IMAGE_WIDTH,
   NUM_PROGRAM_OPTIONS,
}  PROGRAM_OPTION;

typedef enum {
   FILE_PATH,
   POINT_FILE_NAME,
   TRACK_FILE_NAME,
   TRACK_IMAGE_NAME,
   INTENSITY_PROFILE_NAME,
   AREA_PROFILE_NAME,
   FLOWMAP_FILE_NAME, 
   TOTAL_FRAME_NUMBER,
   DATA_INPUT_OPTIONS,
}  DATA_OPTION;

typedef enum {
   APPLICATION_MODE,
   INTENSITY_CUE,
   FLOWMAP_CUE,
   AREA_CUE,
   ALLOW_BIDIRECTIONAL,
   GRID_SIZE_X,
   GRID_SIZE_Y,
   GRID_WIDTH,
   GRID_HEIGHT, 
   MODE_INPUT_OPTIONS,
}  MODE_OPTION;

#endif
/*****************************************************/


/*****************************************************/
#ifndef MAIN_CONST
#define MAIN_CONST

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

#define DATA_TAG                "data"
#define MODE_TAG                "mode"
#define DRAW_TAG                "draw"
#define OPTION_TAG              "options"

#define NO_TEXT_TIME_LABEL

/* ---------- Choose tracking scale -------------- */
//#define MEDIUM_SCALE_TRACKING
//#define LARGE_SCALE_TRACKING
#define SMALL_SCALE_TRACKING
/* --------   only ONE can be selected ----------- */


/* Memory controls */

#ifdef LARGE_SCALE_TRACKING
#define MAX_TOTAL_TRACK_NUM  (10000 * 50) 
#define MAX_PTNUM_IN_FILEREADING    10000   /* maximum number of points per frame */
#define tkg_MaxFrameNum (100)
#endif

#ifdef MEDIUM_SCALE_TRACKING
#define MAX_TOTAL_TRACK_NUM  (2000 * 50) 
#define MAX_PTNUM_IN_FILEREADING    5000   /* maximum number of points per frame */
#define tkg_MaxFrameNum (350)
#endif


#ifdef SMALL_SCALE_TRACKING
#define MAX_TOTAL_TRACK_NUM  (2000 * 30) 
#define MAX_PTNUM_IN_FILEREADING    1000   /* maximum number of points per frame */
#define tkg_MaxFrameNum (500)
#endif



#define MAX_PT_NUM_PER_FRAME MAX_TOTAL_TRACK_NUM

#define MAX_POINT_FEATURE_DIM 3

#endif
/*****************************************************/