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

    Function: This is the head file for profile.cpp. The functions grouped in
	          profile.cpp are used to support the initial reading of the
			  configuration file "track.ini".

*****************************************************************************/


#ifndef PROFILE_HH
#define PROFILE_HH

#ifdef __cplusplus
extern "C"
{
#endif


/*  Maximum length of field values */
#define MAX_VALUE_STR	(80)

/*  Lines that start with '*' are considered to be comment and skipped. */
#define COMMENT     '*'
/*  Character to open a tag */
#define OPEN_TAG    '['
/*  Character to close a tag */
#define CLOSE_TAG   ']'

bool prf_FindTag(const char *fname, const char *tag);
/*  pre:
 *  post:   if fname/tag are found then TRUE is returned, FALSE otherwise.
 */

bool prf_FindField(const char *fname, const char *tag, const char *field);
/*  pre:    
 *  post:   if fname/tag/field are found then TRUE is returned, FALSE otherwise.
 */

bool prf_GetProfileString(const char *fname, const char *tag, const char *field, char *str);
/*  pre:
 *  post:   if fname/tag/field are found then the field value has been put in
 *          str and TRUE is returned, FALSE otherwise.
 *          Error messages: File/Tag/Field not found.
 */

bool prf_GetProfileInt(const char *fname, const char *tag, const char *field,
                       bool accept, int i_default, int *i);
/*  pre:
 *  post:   if fname/tag/field are found then the integer field value has been
 *          put in *i and TRUE is returned. If not found or the field value is
 *          not an integer then FALSE is returned.
 *          Error messages: File/Tag/Field not found or integer error.
 */

bool prf_GetProfileFlt(const char *fname, const char *tag, const char *field,
                       bool accept, double f_default, double *f);
/*  pre:
 *  post:   if fname/tag/field are found then the integer field value has been
 *          put in *i and TRUE is returned. If not found or the field value is
 *          not an integer then FALSE is returned.
 *          Error messages: File/Tag/Field not found or floating point error.
 */

bool prf_GetProfileBool(const char *fname, const char *tag, const char *field, bool *b);
/*  pre:
 *  post:   if fname/tag/field are found then the boolean field value has been
 *          put in *i and TRUE is returned. If not found or the field value is
 *          not an boolean then FALSE is returned.
 *          Error messages: File/Tag/Field not found or boolean error.
 */


#ifdef __cplusplus
};
#endif

#endif
