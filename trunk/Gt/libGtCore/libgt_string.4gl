# $Id$
#------------------------------------------------------------------------------#
# Copyright (c) 2007 Scott Newton <scottn@ihug.co.nz>                          #
#                                                                              #
# MIT License (http://www.opensource.org/licenses/mit-license.php)             #
#                                                                              #
# Permission is hereby granted, free of charge, to any person obtaining a copy #
# of this software and associated documentation files (the "Software"), to     #
# deal in the Software without restriction, including without limitation the   #
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or  #
# sell copies of the Software, and to permit persons to whom the Software is   #
# furnished to do so, subject to the following conditions:                     #
# The above copyright notice and this permission notice shall be included in   #
# all copies or substantial portions of the Software.                          #
#                                                                              #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR   #
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,     #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  #
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER       #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING      #
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS #
# IN THE SOFTWARE.                                                             #
#------------------------------------------------------------------------------#

##
# String Library
#
# This module provides some extra routines for the manipulation of strings.
# @category System Program
# @author Scott Newton
# @date September 2007
# @version $Id$
#

##
# Function to set WHENEVER ANY ERROR for this module
#

FUNCTION libgt_string_id()

DEFINE
	l_id   STRING

	WHENEVER ANY ERROR CALL gt_system_error
	LET l_id = "$Id$"

END FUNCTION

##
# This function checks to see if the given string is empty, i.e. either "" or
# NULL.
# @param l_string The string to check
# @return l_ok TRUE if the string is empty, FALSE otherwise
#

FUNCTION gt_string_is_empty(l_string)

DEFINE
    l_string   STRING

DEFINE
    l_ok   SMALLINT

    LET l_ok = FALSE

    IF l_string IS NULL
    OR l_string == "" THEN
        LET l_ok = TRUE
    ELSE
        LET l_ok = FALSE
    END IF

    RETURN l_ok

END FUNCTION

##
# This function checks to see if the given string contains only whitespace.
# @param l_string The string to check
# @return l_ok TRUE if the string is empty, FALSE otherwise
#

FUNCTION gt_string_is_whitespace(l_string)

DEFINE
    l_string   STRING

DEFINE
    l_ok   SMALLINT,
    i      INTEGER

    LET l_ok = FALSE

    FOR i = 1 TO l_string.getLength()
        IF (l_string.getCharAt(i) == ASCII(32)
        OR  l_string.getCharAt(i) == ASCII(9)
        OR  l_string.getCharAt(i) == ASCII(10)
        OR  l_string.getCharAt(i) == ASCII(13)) THEN
            LET l_ok = TRUE
        ELSE
            LET l_ok = FALSE
            EXIT FOR
        END IF
    END FOR

    RETURN l_ok

END FUNCTION

##
# This function checks to see if the given string is an integer or not
# @param l_string The string to check
# @return l_ok TRUE if the string is an integer, FALSE otherwise
#

FUNCTION gt_string_is_integer(l_string)

DEFINE
    l_string   STRING

DEFINE
    l_ok        SMALLINT,
    l_status    INTEGER,
    l_integer   INTEGER,
    l_float     FLOAT

    LET l_ok = FALSE
    LET l_status = 0

    WHENEVER ANY ERROR CONTINUE
    LET STATUS = 0
    LET l_float = l_string
    LET l_status = STATUS
    WHENEVER ANY ERROR CALL gt_system_error

    IF l_status == 0 THEN
        LET l_integer = l_float

        IF l_integer == l_float THEN
            LET l_ok = TRUE
        END IF
    END IF

    RETURN l_ok

END FUNCTION

##
# This function checks to see if the given string is a decimal or not
# @param l_string The string to check
# @return l_ok TRUE if the string is an integer, FALSE otherwise
#

FUNCTION gt_string_is_decimal(l_string)

DEFINE
    l_string   STRING

DEFINE
    l_ok       SMALLINT,
    l_status   INTEGER,
    l_float    FLOAT

    LET l_ok = FALSE
    LET l_status = 0

    WHENEVER ANY ERROR CONTINUE
    LET STATUS = 0
    LET l_float = l_string
    LET l_status = STATUS
    WHENEVER ANY ERROR CALL gt_system_error

    IF l_status == 0 THEN
        LET l_ok = TRUE
    END IF

    RETURN l_ok

END FUNCTION

##
# This function checks to see if the given string is numeric or not
# @param l_string The string to check
# @return l_ok TRUE if the string is an integer, FALSE otherwise
#

FUNCTION gt_string_is_numeric(l_string)

DEFINE
    l_string   STRING

    RETURN gt_string_is_decimal(l_string)

END FUNCTION

##
# This function checks to see if the given string is alphabetic
# @param l_string The string to check
# @return l_ok TRUE if the string is alphabetic, FALSE otherwise
#

FUNCTION gt_string_is_alphabetic(l_string)

DEFINE
    l_string   STRING

DEFINE
    l_ok   SMALLINT,
    i      INTEGER

    LET l_ok = FALSE

    FOR i = 1 TO l_string.getLength()
        IF (l_string.getCharAt(i) >= "a"
        AND l_string.getCharAt(i) <= "z")
        OR (l_string.getCharAt(i) >= "A"
        AND l_string.getCharAt(i) <= "Z")
        OR (l_string.getCharAt(i) == "_") THEN
            LET l_ok = TRUE
        ELSE
            LET l_ok = FALSE
            EXIT FOR
        END IF
    END FOR

    RETURN l_ok

END FUNCTION

##
# This function checks to see if the given string is alphanumeric
# @param l_string The string to check
# @return l_ok TRUE if the string is alphanumeric, FALSE otherwise
#

FUNCTION gt_string_is_alphanumeric(l_string)

DEFINE
    l_string   STRING

DEFINE
    l_ok   SMALLINT,
    i      INTEGER

    LET l_ok = FALSE

    FOR i = 1 TO l_string.getLength()
        IF (l_string.getCharAt(i) >= "0"
        AND l_string.getCharAt(i) <= "9")
        OR (l_string.getCharAt(i) >= "a"
        AND l_string.getCharAt(i) <= "z")
        OR (l_string.getCharAt(i) >= "A"
        AND l_string.getCharAt(i) <= "Z")
        OR (l_string.getCharAt(i) == "_") THEN
            LET l_ok = TRUE
        ELSE
            LET l_ok = FALSE
            EXIT FOR
        END IF
    END FOR

    RETURN l_ok

END FUNCTION

##
# This function checks to see if the given string is a valid date or not.
#
# @param l_string The string to check.
# @return l_ok TRUE if the string is a valid date, FALSE otherwise.
#

FUNCTION gt_string_is_date(l_string)

DEFINE
    l_string   STRING

DEFINE
    l_ok       SMALLINT,
    l_status   INTEGER,
    l_date     DATE

    LET l_ok = FALSE
    LET l_status = 0

    IF gt_string_is_empty(l_string) THEN
        RETURN l_ok
    END IF

    WHENEVER ANY ERROR CONTINUE
    LET STATUS = 0
    LET l_date = l_string
    LET l_status = STATUS
    WHENEVER ANY ERROR CALL gt_system_error

    IF l_status == 0 THEN
        LET l_ok = TRUE
    END IF

    RETURN l_ok

END FUNCTION

##
# This function checks to see if the given string is a valid datetime or not.
#
# @param l_string The string to check.
# @return l_ok TRUE if the string is a valid datetime, FALSE otherwise.
#

FUNCTION gt_string_is_datetime(l_string)

DEFINE
    l_string   STRING

DEFINE
    l_ok         SMALLINT,
    l_status     INTEGER,
    l_datetime   DATETIME YEAR TO FRACTION(3)

    LET l_ok = FALSE
    LET l_status = 0

    IF gt_string_is_empty(l_string) THEN
        RETURN l_ok
    END IF

    WHENEVER ANY ERROR CONTINUE
    LET STATUS = 0
    LET l_datetime = l_string
    LET l_status = STATUS
    WHENEVER ANY ERROR CALL gt_system_error

    IF l_status == 0 THEN
        LET l_ok = TRUE
    END IF

    RETURN l_ok

END FUNCTION

##
# This function coverts a string into a proper sentence.
# @param l_text The string to transform.
# @return l_buffer The transformed string.
#

FUNCTION gt_string_to_sentence(l_text)

DEFINE
    l_text   STRING

DEFINE
    l_period      SMALLINT,
    i             INTEGER,
    l_char        STRING,
    l_prev_char   STRING,
    l_buffer      base.StringBuffer

    LET l_char = ""
    LET l_prev_char = ""
    LET l_period = TRUE
    LET l_text = l_text.trim()
    LET l_buffer = base.StringBuffer.create()

    FOR i = 1 TO l_text.getLength()
        LET l_char = l_text.getCharAt(i)

        #----------------------------------------------------------------------#
        # Need only one blank space between words and sentences                #
        #----------------------------------------------------------------------#

        IF l_char.equals(" ")
        AND l_prev_char.equals(" ") THEN
            CONTINUE FOR
        END IF

        IF l_char.equals(".") THEN
            LET l_period = TRUE
        END IF

        IF (l_prev_char.equals("")
        OR l_prev_char.equals(" "))
        AND l_period = TRUE THEN
            LET l_period = FALSE
            CALL l_buffer.append(l_char.toUpperCase())
        ELSE
            CALL l_buffer.append(l_char)
        END IF

        #----------------------------------------------------------------------#
        # Need a full stop at the end of a sentence                            #
        #----------------------------------------------------------------------#

        IF i == l_text.getLength()
        AND l_char != "." THEN
            CALL l_buffer.append(".")
        END IF

        LET l_prev_char = l_char
    END FOR

    RETURN l_buffer.toString()

END FUNCTION

##
# This function sets the given text to be in camel case.
# @param l_text The text to transform.
# @result l_buffer The transformed text.
#

FUNCTION gt_string_to_camelcase(l_text)

DEFINE
    l_text   STRING

DEFINE
    i             INTEGER,
    l_char        STRING,
    l_prev_char   STRING,
    l_buffer      base.StringBuffer

    LET l_char = ""
    LET l_prev_char = ""
    LET l_buffer = base.StringBuffer.create()

    FOR i = 1 TO l_text.getLength()
        LET l_char = l_text.getCharAt(i)

        IF l_char.equals(" ")
        AND l_prev_char.equals(" ") THEN
            CONTINUE FOR
        END IF

        IF l_prev_char.equals("")
        OR l_prev_char.equals(" ") THEN
            CALL l_buffer.append(l_char.toUpperCase())
        ELSE
            CALL l_buffer.append(l_char.toLowerCase())
        END IF

        LET l_prev_char = l_char
    END FOR

    RETURN l_buffer.toString()

END FUNCTION

##
# This function reverses the given string.
# @param l_text The string reverse.
# @return l_copy The reversed output.
#

FUNCTION gt_string_reverse(l_text)

DEFINE
    l_text   STRING

DEFINE
    i          SMALLINT,
    l_length   INTEGER,
    l_buffer   base.StringBuffer

    LET l_length = l_text.getLength()
    LET l_buffer = base.StringBuffer.create()

    FOR i = l_length TO 1 STEP -1
        CALL l_buffer.append(l_text.getCharAt(i))
    END FOR

    RETURN l_buffer.tostring()

END FUNCTION

##
# This function finds the first occurrence of the given pattern in the string.
# @param l_string The string to search in.
# @param l_pattern The pattern to search for.
# @return l_position The position of the pattern. If the pattern is not found
#                    zero is returned. If the string is NULL -1 is returned.
#

FUNCTION gt_string_find(l_string, l_pattern)

DEFINE
    l_string    STRING,
    l_pattern   STRING

    RETURN l_string.getIndexOf(l_pattern, 1)

END FUNCTION

##
# This function finds the last occurrence of the given pattern in the string.
# @param l_string The string to search in.
# @param l_pattern The pattern to search for.
# @return l_position The position of the pattern. If the pattern is not found
#                    zero is returned. If the string is NULL -1 is returned.
#

FUNCTION gt_string_rfind(l_string, l_pattern)

DEFINE
    l_string    STRING,
    l_pattern   STRING

DEFINE
    i         INTEGER,
    l_index   INTEGER

    LET l_index = -1

    IF l_string IS NULL THEN
        RETURN l_index
    END IF

    LET l_index = 0

    FOR i = l_string.getLength() TO 1 STEP -1
        IF l_string.getIndexOf(l_pattern, i) > 0 THEN
            LET l_index = i
            EXIT FOR
        END IF
    END FOR

    RETURN l_index

END FUNCTION

##
# This function replaces the given text in the string with the given new test.
# If globally is TRUE then all occurrences will be replaced, otherwise only the
# first occurrence will be replaced.
# @param l_string The string to search in.
# @param l_old The pattern to search for.
# @param l_new The new text to replace the old text with.
# @param l_globally TRUE is the pattern is to be replaced everywhere in the
#                   string, FALSE if only the first occurrence is to be replaced.
# @return l_buffer The string with the relevant replacements.
#

FUNCTION gt_string_replace(l_string, l_old, l_new, l_globally)

DEFINE
    l_string     STRING,
    l_old        STRING,
    l_new        STRING,
    l_globally   SMALLINT

DEFINE
    i          INTEGER,
    l_pos      INTEGER,
    l_end      INTEGER,
    l_start    INTEGER,
    l_buffer   base.StringBuffer

    LET l_start = 1
    LET l_end = l_string.getLength()
    LET l_buffer = base.StringBuffer.create()

    FOR i = l_start TO l_end
        LET l_pos = l_string.getIndexOf(l_old, i)

        IF l_pos > 0 THEN
            CALL l_buffer.append(l_string.subString(l_start, l_pos - 1))
            CALL l_buffer.append(l_new)
            LET l_start = l_pos + l_old.getLength()
            LET i = l_start
        END IF

        IF NOT l_globally AND l_start > 1 THEN
            EXIT FOR
        END IF
    END FOR

    CALL l_buffer.append(l_string.substring(l_start, l_end))

    RETURN l_buffer.tostring()

END FUNCTION

##
# This function counts the number of occurrences of the given pattern in the
# given string.
# @param l_string The string to search in.
# @param l_pattern The pattern to search for.
# @return l_count The number of occurrences.
#

FUNCTION gt_string_count(l_string, l_pattern)

DEFINE
    l_string    STRING,
    l_pattern   STRING

DEFINE
    i         INTEGER,
    l_pos     INTEGER,
    l_end     INTEGER,
    l_count   INTEGER,
    l_start   INTEGER

    LET l_count = 0
    LET l_start = 1
    LET l_end = l_string.getLength()

    FOR i = l_start TO l_end
        LET l_pos = l_string.getIndexOf(l_pattern, i)

        IF l_pos > 0 THEN
            LET l_count = l_count + 1
            LET l_start = l_pos + l_pattern.getLength()
            LET i = l_start
        END IF
    END FOR

    RETURN l_count

END FUNCTION

##
#
# This function converts a string to an integer.
#
# @param l_string The string to convert.
# @return l_ok TRUE if the string was successfully converted, FALSE otherwise.
#

FUNCTION gt_convert_string_to_integer(l_string)

DEFINE
    l_string   STRING

DEFINE
    l_ok        SMALLINT,
    l_status    INTEGER,
    l_integer   INTEGER,
    l_decimal   FLOAT

    LET l_ok = FALSE
    LET l_decimal = 0
    LET l_integer = 0

    WHENEVER ANY ERROR CONTINUE
    LET STATUS = 0
    LET l_integer = l_string
    LET l_status = STATUS
    WHENEVER ANY ERROR CALL gt_system_error

    IF l_status == 0 THEN
        LET l_decimal = l_integer

        IF l_decimal == l_integer THEN
            LET l_ok = TRUE
        ELSE
            LET l_ok = FALSE
            CALL gt_set_error("ERROR", SFMT(%"Unable to convert string %1 to an integer", l_string))
        END IF
    ELSE
        LET l_ok = FALSE
        CALL gt_set_error("ERROR", SFMT(%"Unable to convert string %1 to an integer", l_string))
    END IF

    RETURN l_ok, l_integer

END FUNCTION

##
#
# This function converts a string to a decimal.
#
# @param l_string The string to convert.
# @return l_ok TRUE if the string was successfully converted, FALSE otherwise.
#

FUNCTION gt_convert_string_to_decimal(l_string)

DEFINE
    l_string   STRING

DEFINE
    l_ok        SMALLINT,
    l_status    INTEGER,
    l_decimal   FLOAT

    LET l_ok = FALSE
    LET l_decimal = 0

    WHENEVER ANY ERROR CONTINUE
    LET STATUS = 0
    LET l_decimal = l_string
    LET l_status = STATUS
    WHENEVER ANY ERROR CALL gt_system_error

    IF l_status == 0 THEN
        LET l_ok = TRUE
    ELSE
        LET l_ok = FALSE
        CALL gt_set_error("ERROR", SFMT(%"Unable to convert string %1 to a decimal", l_string))
    END IF

    RETURN l_ok, l_decimal

END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
