extern bool readPoint(FILE *f, pnt_Point *point, int frameID, int pointReadMode);
extern bool readPointList(FILE *f, frm_Frame *points, int frameID, int pointReadMode);
extern bool readSequence(FILE *f, int pointReadMode, frm_Sequence *sequence);

extern bool readIntensityProfile(char*, double*, double*, int);
//extern bool readIntensityProfile(char *filename, double *intensityProfile, int &frameNum);
extern bool readFlowMap(char *filename, double *flowMap, int gridNum);
extern bool readAreaProfile(char *filename, double *areaProfile, double *areaMinMax, int frameNum);
