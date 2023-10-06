extern void setPixel(unsigned char *image, int width, int height,
                       int x, int y, int value);

extern int writeChar(unsigned char *image, int width, int height,
                     int x, int y, int ch);


extern void setLine(unsigned char *image, const int width, const int height,
	            int X1, int Y1, int X2, int Y2, const int value);

extern void setCross(unsigned char *image, int width, int height,
                     int x, int y, int csize, int color);

extern void setBox(unsigned char *image, int width, int height,
                   int x, int y, int bsize, int color);
extern void removeExtremeColors(unsigned char *image, int width, int height);

extern int writeString(unsigned char *image, int width, int height,
                       int x, int y, char *s);

extern bool saveTrackImage(FILE *f, int width, int height, trk_TrackList &t, const frm_Sequence &s);

extern bool saveTrackImage_BD(FILE *f, int width, int height,
                              trk_TrackList &t, const frm_Sequence &s,
							  int* numPlottedPoints);
