/*****************************************************************************

    Copyright (c) 2002 C.J. Veenman

    Permission is hereby granted, free of charge, to any person
    obtaining a copy of this software and associated documentation files
    (the "Software"), to deal in the Software without restriction,
    including without limitation the rights to use, copy, modify, merge,
    publish, distribute, sublicense, and/or sell copies of the Software,
    and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:

    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
    BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
    ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.


    Correspondence should be directed to:

            Cor J. Veenman

            Department of Mediamatics
            Faculty of Information Technology and Systems
            Delft University of Technology
            Delft
            The Netherlands

            email:  C.J.Veenman@its.tudelft.nl

    Function: These functions are used to support the initial reading of the 
	          configuration file "track.ini". 

*****************************************************************************/

#include <stdio.h>
#include <string.h>

#include "io.h"
#include "strio.h"
#include "profile.h"

bool seekTag(FILE *f, const char *tag)
{
    char *p;
    char buf[MAX_LINE];
    int len = strlen(tag);

    fseek(f, 0, SEEK_SET);
    while (p = buf, fgetline(f, buf)) {
	sskipspaces(&p);
        if (*p == COMMENT)
            continue;
        if (p[0] == OPEN_TAG && strncmp(p + 1, tag, len) == 0
         && p[len + 1] == CLOSE_TAG) {
	    p += len + 2;
            return(sgeteoln(&p));
	} /* endif */
    } /* endwhile */
    return(false);
}

static bool seekField(FILE *f, const char *field, char *val)
{
    char *p;
    char buf[MAX_LINE];
    int len = strlen(field);

	/* printf("FILED %s\n", field); */

    while (p = buf, fgetline(f, buf)) {
	sskipspaces(&p);
        if (*p == COMMENT)
            continue;
        if (*p == OPEN_TAG)
            return(false);  /* Don't leave tag record */
	if (strncmp(p, field, len) == 0) {
	    p += len;
	    sskipspaces(&p);
            if (*p++ == '=') {
		sskipspaces(&p);
                if (val) {
                  strcpy(val, p);
                } /* endif */
		return(true);
	    } /* endif */
	} /* endif */
    } /* endwhile */
    return(false);
}

bool prf_FindTag(const char *fname, const char *tag)
{
    FILE *f;

   if ((f = fopen(fname, "rt")) != NULL) {
      if (tag == NULL || seekTag(f, tag)) {
         fclose(f);
         return(true);
      } else {
         /* fprintf(stderr, "Tag '%s' not found\n", tag); */
      } /* endif */
      fclose(f);
   } else {
      /* fprintf(stderr, "File '%s' not found\n", fname);*/
   } /* endif */
   return(false);
}

bool prf_FindField(const char *fname, const char *tag, const char *field)
{
    FILE *f;

   if ((f = fopen(fname, "rt")) != NULL) {
      if (tag == NULL || seekTag(f, tag)) {
         if (seekField(f, field, NULL)) {
            fclose(f);
            return(true);
         } else {
             /* fprintf(stderr, "Field '%s' not found\n", field); */
         } /* endif */
      } else {
         /* fprintf(stderr, "Tag '%s' not found\n", tag); */
      } /* endif */
      fclose(f);        
   } else {
      /* fprintf(stderr, "File '%s' not found\n", fname);*/
   } /* endif */
   return(false);
}

bool prf_GetProfileString(const char *fname, const char *tag, const char *field, char *str)
{
    FILE *f;

	/* printf("TAG = %s\n", tag); */

    if ((f = fopen(fname, "rt")) != NULL) {
        if ((tag == NULL || seekTag(f, tag))) {
            if (seekField(f, field, str)) {
                fclose(f);
                return(true);
            } else {
                fprintf(stderr, "Field '%s' not found\n", field);
            } /* endif */
        } else {
            fprintf(stderr, "Tag '%s' not found\n", tag);
	} /* endif */
	fclose(f);
    } else {
        fprintf(stderr, "File '%s' not found\n", fname);
    } /* endif */
    return(false);
}

bool prf_GetProfileInt(const char *fname, const char *tag, const char *field,
                       bool accept, int i_default, int *i)
{
    char str[si_MAX_STR];
    char *p = str;

    if (prf_GetProfileString(fname, tag, field, str)) {
        if (*str) {
            return((sgetint(&p, i) && sgeteoln(&p)) ||
                   serror("integer", str));
        } else {
            *i = i_default;
            return(accept);
        } /* endif */
    } /* endif */
    return(false);
}

bool prf_GetProfileFlt(const char *fname, const char *tag, const char *field,
                       bool accept, double f_default, double *f)
{
    char str[si_MAX_STR];
    char *p = str;

    if (prf_GetProfileString(fname, tag, field, str)) {
        if (*str) {
            return((sgetdbl(&p, f) && sgeteoln(&p)) || serror("float", str));
        } else {
            *f = f_default;
            return(accept);
        } /* endif */
    } /* endif */
    return(false);
}

bool prf_GetProfileBool(const char *fname, const char *tag, const char *field, bool *b)
{
static const char *BoolStr[] = {
   "false",
   "true"
};

    char str[si_MAX_STR];
    int i;

    if (prf_GetProfileString(fname, tag, field, str)
     && sindex(BoolStr, 2, "boolean", str, &i)) {
        if (i == 0)
			*b = false;
		else
			*b = true;
		return(true);
    } /* endif */
    return(false);
}

