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

#ifndef IO_HH
#define IO_HH

#include <stdio.h>

#ifdef __cplusplus
extern "C"
{
#endif

static const int MAX_LINE =      1024;

bool fgetline(FILE *f, char *line);
/*  pre:
 *  post:   Returned TRUE if a line could be read from f. Possible error is end-
 *          of-file. The line is maximum MAX_LINE characters long.
 */


#ifdef __cplusplus
};
#endif

#endif
