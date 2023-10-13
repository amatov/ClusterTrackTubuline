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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "strio.h"

#define VOWELS          "aieo"

#define IS_VOWEL(c)     strchr(VOWELS, (c))

#define EOLINE(c)       ((c) == si_EOL || (c) == si_EOS)

char si_Seps[] = {si_EOL, si_ARGSEP, si_EOS};

void sskipspaces(char **buf)
{
    while (!EOLINE(**buf) && isspace(**buf)) (*buf)++;
}

int snextc(char *buf)
{
    return(*buf ? *buf : EOF);
}

bool serror(const char *type, const char *value)
{
    fprintf(stderr, "'%s' not a%s %s value\n",
            value, IS_VOWEL(*type) ? "n" : "", type);
    return(false);
}

bool sindex(const char *list[], int n, const char *type, const char *value, int *index)
{
   int i;

   for (i = 0; i < n; i++) {
	   /* if (strcasecmp(list[i], value) == 0) {  */
	   if (_stricmp(list[i], value) == 0) {
         *index = i;
         return(true);
      } /* endif */
   } /* endfor */
   return(serror(type, value));
}

bool sindexlist(const char *list[], int n, char *type, char *value,
                           int *idxlist, int *indexnum)
{
    int i;
    char *p;

    *indexnum = 0;
    do {
        sskipspaces(&value);
        if (*value == '\0') {
            break;
        } /* endif */

        if ((p = strchr(value, ',')) == NULL) p = strchr(value, '\0');

        for (i = 0; i < n; i++) {
            if (strncmp(list[i], value, strlen(list[i])) == 0) {
                idxlist[(*indexnum)++] = i;
                break;
            } /* endif */
        } /* endfor */
        if (i >= n) return(serror(type, value));
        if (*p == ',') {
            value = p + 1;
            //while (*value == ' ') value++;
        } /* endif */
    } while (*p == ',');
    return(true);
}

bool sgetbyte(char **buf, signed char *i)
{
    bool read = false;
    int sign = 1;

    sskipspaces(buf);
    if (i) *i = 0;
    if (**buf == '-') sign = -1;
    if (sign < 0 || **buf == '+') (*buf)++;
    while (isdigit(**buf)) {
        if (i) *i = *i * 10 + **buf - '0';
        (*buf)++;
        read = true;
    } /* endwhile */
    if (i) *i *= sign;
    return(read);
}

bool sgetint(char **buf, int *i)
{
   const char *p = *buf;

   *i = strtol(p, (char **) buf, 10);

   return(*buf != p);
}

bool sgetdbl(char **buf, double *d)
{
   const char *p = *buf;

   *d = strtod(p, (char **) buf);

   return(*buf != p);
}

bool sargint(char **buf, int *i, bool accept_default, int _default)
{
   sskipspaces(buf);
   switch (**buf) {
   case si_ARGSEP:
      (*buf)++;
   case si_EOS:
   case si_EOL:
      *i = _default;
      return(accept_default);
   default:
      if (sgetint(buf, i)) {
         sskipspaces(buf);
         switch (**buf) {
         case si_ARGSEP:
            (*buf)++;
         case si_EOS:
         case si_EOL:
            return(true);
         } /* endwitch */
      } /* endif */
      return(false);
   } /* endwitch */
}

bool sargchar(char **buf, char *c, bool accept_default, char _default)
{
   sskipspaces(buf);
   switch (**buf) {
   case si_ARGSEP:
      (*buf)++;
   case si_EOS:
   case si_EOL:
      *c = _default;
      return(accept_default);
   default:
      if ((*c = **buf) != si_EOS) {
         sskipspaces(buf);
         switch (**buf) {
         case si_ARGSEP:
            (*buf)++;
         case si_EOS:
         case si_EOL:
            return(true);
         } /* endwitch */
      } /* endif */
      return(false);
   } /* endwitch */
}

bool sgetstr(char **buf, char *str, char *seps)
{
   int i = 0;

   sskipspaces(buf);
   while (i < si_MAX_STR && !EOLINE(**buf)) {
      if (**buf == '!') {
         if (strchr(seps, *(*buf + 1))) {
            (*buf)++;
         } /* endif */
      } else {
         if (strchr(seps, **buf))
            break;
      } /* endif */
      if (str)
         *str++ = **buf;
      (*buf)++, i++;
   } /* endwhile */
   if (str)
      *str = si_EOS;
   return(i > 0);
}

bool sgetbool(char **buf, bool *b)
{
static const char *BoolStr[] = {
   "false",
   "true"
};

    char str[si_MAX_STR];
    int i;

    if (sgetstr(buf, str, si_Seps)
     && sindex(BoolStr, 2, "boolean", str, &i)) {
        *b = i;
        return(true);
    } /* endif */
    return(false);
}

bool sargstr(char **buf, char *str, bool accept_default, char *_default)
{
   sskipspaces(buf);
   switch (**buf) {
   case si_ARGSEP:
      (*buf)++;
   case si_EOS:
   case si_EOL:
      if (_default)
         strcpy(str, _default);
      return(accept_default);
   default:
      if (sgetstr(buf, str, si_Seps)) {
         sskipspaces(buf);
         switch (**buf) {
         case si_ARGSEP:
            (*buf)++;
         case si_EOS:
         case si_EOL:
            return(true);
         } /* endwitch */
      } /* endif */
      return(false);
   } /* endwitch */
}

bool sgeteoln(char **buf)
{
    sskipspaces(buf);
    return(EOLINE(**buf));
}

