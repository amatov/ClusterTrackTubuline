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

*****************************************************************************/


#ifndef STRIO_HH
#define STRIO_HH

#ifdef __cplusplus
extern "C"
{
#endif

static const char si_ARGSEP =      ',';
static const char si_EOS =         '\0';
static const char si_EOL =         '\n';
static const int si_MAX_STR =      256;

extern char si_Seps[];

bool serror(const char *type, const char *value);

bool sindex(const char *list[], int n, const char *type, const char *value, int *index);
/*  pre:
 *  post:   If value is present in list then *index contains the index and TRUE
 *          is returned. If not then an error message is sent to 'stderr'. The
 *          string 'type' tells what type of value the function expected.
 */

bool sindexlist(const char *list[], int n, char *type, char *value,
                           int *idxlist, int *indexnum);
/*  pre:
 *  post:   Same as prf_StringToIndex(), but now the string 'value' may contain
 *          a number of strings from list separated by comma's. The indices are
 *          stored in idxlist. In case value contains one string that is not
 *          present in list then FALSE is returned and 'type' tells what type
 *          of value the function expected.
 */

bool sargint(char **buf, int *i, bool accept_default, int _default);
/*  pre:
 *  post:   Returns TRUE if integer on input or we may accept the given
 *          default. The buf pointer has been incremented
 */

bool sargchar(char **buf, char *c, bool accept_default, char _default);
/*  pre:
 *  post:   Returns TRUE if character on input or we may accept the given
 *          default. The buf pointer has been incremented
 */

bool sargstr(char **buf, char *str, bool accept_default, char *_default);
/*  pre:
 *  post:   Returns TRUE if string on input or we may accept the given
 *          default. The buf pointer has been incremented
 */

void sskipspaces(char **buf);
/*  pre:
 *  post:   The buf pointer has been incremented until after the last space.
 */

bool sgetbyte(char **buf, signed char *i);
/*  pre:
 *  post:   Read byte into *i, incremented buf pointer and returned TRUE if
 *          there was a byte in buf. Otherwise FALSE is returned.
 */

bool sgetshort(char **buf, short *i);
/*  pre:
 *  post:   Read short into *i, incremented buf pointer and returned TRUE if
 *          there was a short in buf. Otherwise FALSE is returned.
 */

bool sgetlong(char **buf, long *i);
/*  pre:
 *  post:   Read long into *i, incremented buf pointer and returned TRUE if
 *          there was a long in buf. Otherwise FALSE is returned.
 */

bool sgetint(char **buf, int *i);
/*  pre:
 *  post:   Read integer into *i, incremented buf pointer and returned TRUE if
 *          there was a integer in buf. Otherwise FALSE is returned.
 */

bool sgetflt(char **buf, float *d);
/*  pre:
 *  post:   Read float into *i, incremented buf pointer and returned TRUE if
 *          there was a float in buf. Otherwise FALSE is returned.
 */

bool sgetdbl(char **buf, double *d);
/*  pre:
 *  post:   Read double into *i, incremented buf pointer and returned TRUE if
 *          there was a double in buf. Otherwise FALSE is returned.
 */

bool sgetldbl(char **buf, long double *d);
/*  pre:
 *  post:   Read long double into *i, incremented buf pointer and returned TRUE
 *          if there was a long double in buf. Otherwise FALSE is returned.
 */

bool sgetstr(char **buf, char *str, char *seps);
/*  pre:
 *  post:   Read string into str (if str != NULL), incremented buf pointer and
 *          returned TRUE if there was a string in buf. Otherwise FALSE is
 *          returned.
 */

bool sgetbool(char **buf, bool *b);
/*  pre:
 *  post:   Read bool value into *b, incremented buf pointer and
 *          returned TRUE if there was a bool in buf. Otherwise FALSE is
 *          returned.
 */

bool sgeteoln(char **buf);
/*  pre:
 *  post:   Read end-of-line into *i, incremented buf pointer and returned TRUE
 *          if there was an end-of-line in buf. Otherwise FALSE is returned.
 */


#ifdef __cplusplus
};
#endif

#endif
