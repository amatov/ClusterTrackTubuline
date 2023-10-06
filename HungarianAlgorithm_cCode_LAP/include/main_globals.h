/* Definition of global variables for LAPtrack */

bool drawText = false;
bool drawLine = false;
bool drawCross = false;
bool drawBox = false;

bool verbose = false;

bool intensity_cue = false;
bool flowmap_cue = false;
bool area_cue = false;
bool allow_bidirectional = false;


/* --------------------------------------------------*/
char defaultConfigFileName[] = "LAPtrack_config.txt";
char configFileName[512] = "";

extern char filePath[512] = "";
extern char pointFileName[512] = "";
extern char trackFileName[512] = "";
extern char trackImageFileName[512] = "";
extern char intensityProfileName[512] = "";
extern char areaProfileName[512] = "";

extern char flowmapFileName[512] = "";

/* --------------------------------------------------*/

//int applicationMode = 3;  // speckle tracking, property feature number = 3;

int applicationMode = 4;  // vesicle tracking, property feature number = 4;



extern int totalFrameNum = 0;
int minTrackLen = 2;

int widthImage = 1000;
int heightImage = 1000;

int maxInterpol = 100;
int minPresent = 1;
int criterion = crt_SmoothMotionIndex;

int image_height = -1;
int image_width = -1;

int frame_length[500];      /* array to save the number of points in each frame. */
int frame_length_ctr = 0;   /* count how many frames */

int gridWidth = 0;
int gridHeight = 0;
int gridSizeX = 0;
int gridSizeY = 0;

/* --------------------------------------------------*/
double drawMulX = 2;
double drawMulY = 2;

double modelW1 = 0.1;
double modelW2 = 0.9;
double modelW3 = 0.0;  /* weight for the intensity cue */
double modelW4 = 0.0;  /* weight for the flow pattern cue */
double modelW5 = 0.0;  /* weight for the area cue */

double maxSpeed = 3;
double maxAngle = 3.1415926535898;
double maxDeflectionAngle = 3.1415926535898;

double maxPhi = 0.3;
double maxSpeedSqr = 0;

extern double *intensityProfile = NULL;
extern double *intensityMinMax = NULL;

extern double *areaProfile = NULL;
extern double *areaMinMax = NULL;

extern double *flowMap = NULL;

extern double intChangePctThreshold = 0.5;  // 50 percent
extern double areaChangePctThreshold = 0.5; // 50 percent


/* --------------------------------------------------*/
const char *dataInputOptions[DATA_INPUT_OPTIONS] = {
   "file-path",
   "point-file-name",
   "track-file-name",
   "track-image-name",
   "intensity-profile-file-name",
   "area-profile-file-name",
   "flowmap-file-name",
   "total-frame-number"
};


const char *modeInputOptions[MODE_INPUT_OPTIONS] = {
   "application-mode",
   "intensity-cue",
   "flowmap-cue",
   "area-cue",
   "allow-bidirectional",
   "grid-size-x",
   "grid-size-y",
   "grid-width",
   "grid-height"
};

const char *optionStrings[NUM_PROGRAM_OPTIONS] = {
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
   "max-angle",
   "max-deflection-angle",
   "min-present",
   "min-track-len",
   "model-w1",
   "model-w2",
   "model-w3",
   "model-w4",
   "model-w5",
   "verbose",
   "width-image",
   "image-height",
   "image-width"
};

const char *criterionStrings[] = {
   "smooth-motion",
   "shortest-path",
   "proximal-uniform",
};

const char *optionArgStrings[NUM_PROGRAM_OPTIONS] = {
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
   "float[0..1]",
   "float[0..1]",
   "float[0..1]",
   "boolean",
   "integer",
};


