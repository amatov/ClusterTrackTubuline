extern void syntaxError(char *progname, char *args);
extern int checkOption(char **string);
extern void usage(char *programName);
extern bool readOption(PROGRAM_OPTION option, char *p);
extern int parseArgs(int argc, char *argv[]);
extern bool readProfile(const char *fname, bool printout);
