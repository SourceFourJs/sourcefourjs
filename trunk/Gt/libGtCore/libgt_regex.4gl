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
# Simple Regular Expression Library
# @category System Program
# @author Scott Newton
# @date April 2008
# @version $Id$
#

DEFINE
    m_matches DYNAMIC ARRAY OF STRING,

    m_regop DYNAMIC ARRAY OF RECORD
        pattern    STRING,
        match      STRING,
        remember   SMALLINT
    END RECORD

#------------------------------------------------------------------------------#
# Function to set WHENEVER ANY ERROR for this module                           #
#------------------------------------------------------------------------------#

FUNCTION libgt_regex_id()

DEFINE
	l_id   STRING

	WHENEVER ANY ERROR CALL gt_system_error
	LET l_id = "$Id$"

END FUNCTION

##
# Function to return the number of regex matches.
#
# @return m_matches.getLength() The number of matches.
#

FUNCTION gt_get_number_of_regex_matches()

    RETURN m_matches.getLength()

END FUNCTION

##
# Function to return the match string for the given pattern number.
#
# @param l_number The match pattern to return.
# @return m_matches[l_number] The match string found.
#

FUNCTION gt_get_regex_match_value(l_number)

DEFINE
    l_number   INTEGER

    IF l_number <= m_matches.getLength() THEN
        RETURN m_matches[l_number]
    ELSE
        RETURN NULL
    END IF

END FUNCTION

##
# Funtion to validate the given regular expression.
#
# @param l_regexp The regular expression to be validated.
# @return l_ok Returns TRUE if the regular expression is valid, FALSE otherwise.
# @return l_exceptionhdl The handle for the raised exception.
#

FUNCTION gt_validate_regular_expression(l_regexp)

DEFINE
    l_regexp   STRING

DEFINE
    l_ok         SMALLINT,
    l_remember   SMALLINT,
    i            INTEGER,
    j            INTEGER

    LET j = 1
    LET l_ok = FALSE

    #--------------------------------------------------------------------------#
    # Parse the regular expression string                                      #
    #--------------------------------------------------------------------------#

    FOR i = 1 TO l_regexp.getLength()
        CASE
            WHEN l_regexp.getCharAt(i) == "^"
                IF i != 1 THEN
                    LET l_ok = FALSE
                    CALL gt_set_error("ERROR", %"^NotAtStart")
                    RETURN l_ok
                END IF

                LET m_regop[j].pattern = "OP_START"
                LET m_regop[j].match = ""
                LET m_regop[j].remember = FALSE
                LET j = j + 1

            WHEN l_regexp.getCharAt(i) == "$"
                IF i != l_regexp.getLength() THEN
                    LET l_ok = FALSE
                    CALL gt_set_error("ERROR", %"$NotAtEnd")
                    RETURN l_ok
                END IF

                LET m_regop[j].pattern = "OP_END"
                LET m_regop[j].match = ""
                LET m_regop[j].remember = FALSE
                LET j = j + 1

            WHEN l_regexp.getCharAt(i) == "("
                LET l_remember = TRUE

            WHEN l_regexp.getCharAt(i) == ")"
                LET l_remember = FALSE

            WHEN l_regexp.getCharAt(i) == "."
                LET m_regop[j].pattern = "OP_DOT"

                CASE
                    WHEN l_regexp.getCharAt(i + 1) == "+"
                        LET m_regop[j].match = "OP_PLUS"
                        LET i = i + 1

                    WHEN l_regexp.getCharAt(i + 1) == "?"
                        LET m_regop[j].match = "OP_QUESTION"
                        LET i = i + 1

                    WHEN l_regexp.getCharAt(i + 1) == "*"
                        LET m_regop[j].match = "OP_STAR"
                        LET i = i + 1

                    OTHERWISE
                        LET i = i + 1
                END CASE

                LET m_regop[j].remember = l_remember
                LET j = j + 1

            WHEN l_regexp.getCharAt(i) == ASCII(92)
                CASE
                    WHEN l_regexp.getCharAt(i + 1) == "."
                        LET m_regop[j].pattern = l_regexp.getCharAt(i + 1)
                        LET m_regop[j].match = ""
                        LET m_regop[j].remember = l_remember
                        LET i = i + 1
                        LET j = j + 1

                    WHEN l_regexp.getCharAt(i + 1) == ASCII(92)
                        LET m_regop[j].pattern = l_regexp.getCharAt(i + 1)
                        LET m_regop[j].match = ""
                        LET m_regop[j].remember = l_remember
                        LET i = i + 1
                        LET j = j + 1

                    WHEN l_regexp.getCharAt(i + 1) == "("
                        LET m_regop[j].pattern = l_regexp.getCharAt(i + 1)
                        LET m_regop[j].match = ""
                        LET m_regop[j].remember = l_remember
                        LET i = i + 1
                        LET j = j + 1

                    WHEN l_regexp.getCharAt(i + 1) == ")"
                        LET m_regop[j].pattern = l_regexp.getCharAt(i + 1)
                        LET m_regop[j].match = ""
                        LET m_regop[j].remember = l_remember
                        LET i = i + 1
                        LET j = j + 1

                    WHEN l_regexp.getCharAt(i + 1) == "w"
                        LET m_regop[j].pattern = "OP_ALPHANUMERIC"

                        CASE
                            WHEN l_regexp.getCharAt(i + 2) == "+"
                                LET m_regop[j].match = "OP_PLUS"
                                LET i = i + 2

                            WHEN l_regexp.getCharAt(i + 2) == "?"
                                LET m_regop[j].match = "OP_QUESTION"
                                LET i = i + 2

                            WHEN l_regexp.getCharAt(i + 2) == "*"
                                LET m_regop[j].match = "OP_STAR"
                                LET i = i + 2

                            OTHERWISE
                                LET l_ok = FALSE
                                CALL gt_set_error("ERROR", %"Invalid multiplier")
                                RETURN l_ok
                        END CASE

                        LET m_regop[j].remember = l_remember
                        LET j = j + 1

                    WHEN l_regexp.getCharAt(i + 1) == "W"
                        LET m_regop[j].pattern = "NOP_ALPHANUMERIC"

                        CASE
                            WHEN l_regexp.getCharAt(i + 2) == "+"
                                LET m_regop[j].match = "OP_PLUS"
                                LET i = i + 2

                            WHEN l_regexp.getCharAt(i + 2) == "?"
                                LET m_regop[j].match = "OP_QUESTION"
                                LET i = i + 2

                            WHEN l_regexp.getCharAt(i + 2) == "*"
                                LET m_regop[j].match = "OP_STAR"
                                LET i = i + 2

                            OTHERWISE
                                LET l_ok = FALSE
                                CALL gt_set_error("ERROR", %"Invalid multiplier")
                                RETURN l_ok
                        END CASE

                        LET m_regop[j].remember = l_remember
                        LET j = j + 1

                    WHEN l_regexp.getCharAt(i + 1) == "s"
                        LET m_regop[j].pattern = "OP_WHITESPACE"

                        CASE
                            WHEN l_regexp.getCharAt(i + 2) == "+"
                                LET m_regop[j].match = "OP_PLUS"
                                LET i = i + 2

                            WHEN l_regexp.getCharAt(i + 2) == "?"
                                LET m_regop[j].match = "OP_QUESTION"
                                LET i = i + 2

                            WHEN l_regexp.getCharAt(i + 2) == "*"
                                LET m_regop[j].match = "OP_STAR"
                                LET i = i + 2

                            OTHERWISE
                                LET l_ok = FALSE
                                CALL gt_set_error("ERROR", %"Invalid multiplier")
                                RETURN l_ok
                        END CASE

                        LET m_regop[j].remember = l_remember
                        LET j = j + 1

                    WHEN l_regexp.getCharAt(i + 1) == "S"
                        LET m_regop[j].pattern = "NOP_WHITESPACE"

                        CASE
                            WHEN l_regexp.getCharAt(i + 2) == "+"
                                LET m_regop[j].match = "OP_PLUS"
                                LET i = i + 2

                            WHEN l_regexp.getCharAt(i + 2) == "?"
                                LET m_regop[j].match = "OP_QUESTION"
                                LET i = i + 2

                            WHEN l_regexp.getCharAt(i + 2) == "*"
                                LET m_regop[j].match = "OP_STAR"
                                LET i = i + 2

                            OTHERWISE
                                LET l_ok = FALSE
                                CALL gt_set_error("ERROR", %"Invalid multiplier")
                                RETURN l_ok
                        END CASE

                        LET m_regop[j].remember = l_remember
                        LET j = j + 1

                    WHEN l_regexp.getCharAt(i + 1) == "d"
                        LET m_regop[j].pattern = "OP_NUMERIC"

                        CASE
                            WHEN l_regexp.getCharAt(i + 2) == "+"
                                LET m_regop[j].match = "OP_PLUS"
                                LET i = i + 2

                            WHEN l_regexp.getCharAt(i + 2) == "?"
                                LET m_regop[j].match = "OP_QUESTION"
                                LET i = i + 2

                            WHEN l_regexp.getCharAt(i + 2) == "*"
                                LET m_regop[j].match = "OP_STAR"
                                LET i = i + 2

                            OTHERWISE
                                LET l_ok = FALSE
                                CALL gt_set_error("ERROR", %"Invalid multiplier")
                                RETURN l_ok
                        END CASE

                        LET m_regop[j].remember = l_remember
                        LET j = j + 1

                    WHEN l_regexp.getCharAt(i + 1) == "D"
                        LET m_regop[j].pattern = "NOP_NUMERIC"

                        CASE
                            WHEN l_regexp.getCharAt(i + 2) == "+"
                                LET m_regop[j].match = "OP_PLUS"
                                LET i = i + 2

                            WHEN l_regexp.getCharAt(i + 2) == "?"
                                LET m_regop[j].match = "OP_QUESTION"
                                LET i = i + 2

                            WHEN l_regexp.getCharAt(i + 2) == "*"
                                LET m_regop[j].match = "OP_STAR"
                                LET i = i + 2

                            OTHERWISE
                                LET l_ok = FALSE
                                CALL gt_set_error("ERROR", %"Invalid multiplier")
                                RETURN l_ok
                        END CASE

                        LET m_regop[j].remember = l_remember
                        LET j = j + 1

                    OTHERWISE
                        LET m_regop[j].pattern = l_regexp.getCharAt(i)
                        LET m_regop[j].match = ""
                        LET m_regop[j].remember = l_remember
                        LET j = j + 1
                END CASE

            OTHERWISE
                LET m_regop[j].pattern = l_regexp.getCharAt(i)
                LET m_regop[j].match = ""
                LET m_regop[j].remember = l_remember
                LET j = j + 1
        END CASE
    END FOR

    RETURN TRUE

END FUNCTION

##
# Function to validate the given data using the given regular expression.
#
# @param l_regexp The regular expression to be test the data against.
# @param l_data The data to be compared to the regular expression.
# @return l_ok Returns TRUE if the data conforms to the regular expression,
#              FALSE otherwise.
# @return l_exceptionhdl The handle to raised exception.
#

FUNCTION gt_validate_data_using_regex(l_regexp, l_data)

DEFINE
    l_regexp    STRING,
    l_data      STRING

DEFINE
    l_ok         SMALLINT,
    l_at_start   SMALLINT,
    l_remember   SMALLINT,
    i            INTEGER,
    j            INTEGER,
    k            INTEGER,
    l_tmp        STRING
    
    DISPLAY "<", l_regexp, ">"
    DISPLAY "<", l_data, ">"

    LET j = 1
    LET k = 1
    LET l_ok = FALSE
    LET l_at_start = FALSE
    LET l_remember = FALSE

    CALL m_regop.clear()
    CALL m_matches.clear()

    IF l_regexp.getLength() == 0 THEN
        IF l_data.getLength() == 0 THEN
            LET l_ok = TRUE
            RETURN l_ok
        END IF
    END IF

    CALL gt_validate_regular_expression(l_regexp)
        RETURNING l_ok

    IF NOT l_ok THEN
        RETURN l_ok
    END IF

    #--------------------------------------------------------------------------#
    # Compare the given string with the regular expression                     #
    #--------------------------------------------------------------------------#

    FOR i = 1 TO m_regop.getLength()

        CASE
            #------------------------------------------------------------------#
            # Pattern : ^                                                      #
            #------------------------------------------------------------------#

            WHEN m_regop[i].pattern == "OP_START"
                LET l_at_start = TRUE

            #------------------------------------------------------------------#
            # Pattern : $                                                      #
            #------------------------------------------------------------------#

            WHEN m_regop[i].pattern == "OP_END"
                IF l_at_start THEN
                    LET l_at_start = FALSE
                    IF j != 1 THEN
                        LET l_ok = FALSE
                        CALL gt_set_error("ERROR", %"")
                        RETURN l_ok
                    END IF
                END IF

                IF j == l_data.getLength() + 1 THEN
                    LET l_ok = TRUE
                    EXIT FOR
                ELSE
                    LET l_ok = FALSE
                    CALL gt_set_error("ERROR", %"")
                    RETURN l_ok
                END IF

            #------------------------------------------------------------------#
            # Pattern : .                                                      #
            #------------------------------------------------------------------#

            WHEN m_regop[i].pattern == "OP_DOT"
                IF l_at_start THEN
                    LET l_at_start = FALSE
                    IF j != 1 THEN
                        LET l_ok = FALSE
                        CALL gt_set_error("ERROR", %"")
                        RETURN l_ok
                    END IF
                END IF

                CASE
                    WHEN m_regop[i].match == "OP_PLUS"
                        IF m_regop[i].remember THEN
                            LET m_matches[k] = l_data.subString(j, l_data.getLength())
                            LET k = k + 1
                        END IF

                        LET l_ok = TRUE
                        EXIT FOR

                    WHEN m_regop[i].match == "OP_QUESTION"
                        IF m_regop[i].remember THEN
                            LET m_matches[k] = l_data.subString(j, j + 1)
                            LET k = k + 1
                        END IF

                        LET j = j + 1

                    WHEN m_regop[i].match == "OP_STAR"
                        IF m_regop[i].remember THEN
                            LET m_matches[k] = l_data.subString(j, l_data.getLength())
                            LET k = k + 1
                        END IF

                        LET l_ok = TRUE
                        EXIT FOR

                    OTHERWISE
                        LET l_ok = FALSE
                        CALL gt_set_error("ERROR", %"NoMatch")
                        RETURN l_ok
                END CASE

            #------------------------------------------------------------------#
            # Pattern : \w                                                     #
            #------------------------------------------------------------------#

            WHEN m_regop[i].pattern == "OP_ALPHANUMERIC"
                IF l_at_start THEN
                    LET l_at_start = FALSE
                    IF j != 1 THEN
                        LET l_ok = FALSE
                        CALL gt_set_error("ERROR", %"")
                        RETURN l_ok
                    END IF
                END IF

                LET l_tmp = ""

                CASE
                    WHEN m_regop[i].match == "OP_PLUS"
                        IF gt_string_is_alphanumeric(l_data.getCharAt(j)) THEN
                            WHILE TRUE
                                IF gt_string_is_alphanumeric(l_data.getCharAt(j)) THEN
                                    IF m_regop[i].remember THEN
                                        LET l_tmp = l_tmp.append(l_data.getCharAt(j))
                                    END IF
                                    LET j = j + 1
                                ELSE
                                    IF m_regop[i].remember THEN
                                        LET m_matches[k] = l_tmp
                                        LET k = k + 1
                                    END IF

                                    IF i = m_regop.getLength() AND j = l_data.getLength() + 1 THEN

                                        LET l_ok = TRUE
                                    ELSE
                                        LET l_ok = FALSE
                                    END IF

                                    EXIT WHILE
                                END IF
                            END WHILE
                        ELSE
                            LET l_ok = FALSE
                            CALL gt_set_error("ERROR", %"Not alphanumeric")
                            RETURN l_ok
                        END IF

                    WHEN m_regop[i].match == "OP_QUESTION"
                        IF gt_string_is_alphanumeric(l_data.getCharAt(j)) THEN
                            IF m_regop[i].remember THEN
                                LET m_matches[k] = l_data.getCharAt(j)
                                LET k = k + 1
                            END IF
                        END IF

                    WHEN m_regop[i].match == "OP_STAR"
                        IF gt_string_is_alphanumeric(l_data.getCharAt(j)) THEN
                            WHILE TRUE
                                IF gt_string_is_alphanumeric(l_data.getCharAt(j)) THEN
                                    IF m_regop[i].remember THEN
                                        LET l_tmp = l_tmp.append(l_data.getCharAt(j))
                                    END IF
                                    LET j = j + 1
                                ELSE
                                    IF m_regop[i].remember THEN
                                        LET m_matches[k] = l_tmp
                                        LET k = k + 1
                                    END IF

                                    IF i = m_regop.getLength() AND j = l_data.getLength() + 1 THEN

                                        LET l_ok = TRUE
                                    ELSE
                                        LET l_ok = FALSE
                                    END IF

                                    EXIT WHILE
                                END IF
                            END WHILE
                        END IF

                    OTHERWISE
                        CALL gt_set_abort(FALSE, "Invalid regexp operation")
                END CASE

            #------------------------------------------------------------------#
            # Pattern : \W                                                     #
            #------------------------------------------------------------------#

            WHEN m_regop[i].pattern == "NOP_ALPHANUMERIC"
                IF l_at_start THEN
                    LET l_at_start = FALSE
                    IF j != 1 THEN
                        LET l_ok = FALSE
                        CALL gt_set_error("ERROR", %"")
                        RETURN l_ok
                    END IF
                END IF

                LET l_tmp = ""

                CASE
                    WHEN m_regop[i].match == "OP_PLUS"
                        IF j <= l_data.getLength()
                        AND NOT gt_string_is_alphanumeric(l_data.getCharAt(j)) THEN
                            WHILE TRUE
                                IF j <= l_data.getLength()
                                AND NOT gt_string_is_alphanumeric(l_data.getCharAt(j)) THEN
                                    IF m_regop[i].remember THEN
                                        LET l_tmp = l_tmp.append(l_data.getCharAt(j))
                                    END IF
                                    LET j = j + 1
                                ELSE
                                    IF m_regop[i].remember THEN
                                        LET m_matches[k] = l_tmp
                                        LET k = k + 1
                                    END IF

                                    IF i = m_regop.getLength() AND j = l_data.getLength() + 1 THEN

                                        LET l_ok = TRUE
                                    ELSE
                                        LET l_ok = FALSE
                                    END IF

                                    EXIT WHILE
                                END IF
                            END WHILE
                        ELSE
                            LET l_ok = FALSE
                            CALL gt_set_error("ERROR", %"Not alphanumeric")
                            RETURN l_ok
                        END IF

                    WHEN m_regop[i].match == "OP_QUESTION"
                        IF j <= l_data.getLength()
                        AND NOT gt_string_is_alphanumeric(l_data.getCharAt(j)) THEN
                            IF m_regop[i].remember THEN
                                LET m_matches[k] = l_data.getCharAt(j)
                                LET k = k + 1
                            END IF
                        END IF

                    WHEN m_regop[i].match == "OP_STAR"
                        IF j <= l_data.getLength()
                        AND NOT gt_string_is_alphanumeric(l_data.getCharAt(j)) THEN
                            WHILE TRUE
                                IF j <= l_data.getLength()
                                AND NOT gt_string_is_alphanumeric(l_data.getCharAt(j)) THEN
                                    IF m_regop[i].remember THEN
                                        LET l_tmp = l_tmp.append(l_data.getCharAt(j))
                                    END IF
                                    LET j = j + 1
                                ELSE
                                    IF m_regop[i].remember THEN
                                        LET m_matches[k] = l_tmp
                                        LET k = k + 1
                                    END IF

                                    IF i = m_regop.getLength() AND j = l_data.getLength() + 1 THEN

                                        LET l_ok = TRUE
                                    ELSE
                                        LET l_ok = FALSE
                                    END IF

                                    EXIT WHILE
                                END IF
                            END WHILE
                        END IF

                    OTHERWISE
                        CALL gt_set_abort(FALSE, "Invalid regexp operation")
                END CASE

            #------------------------------------------------------------------#
            # Pattern : \s                                                     #
            #------------------------------------------------------------------#

            WHEN m_regop[i].pattern == "OP_WHITESPACE"
                IF l_at_start THEN
                    LET l_at_start = FALSE
                    IF j != 1 THEN
                        LET l_ok = FALSE
                        CALL gt_set_error("ERROR", %"")
                        RETURN l_ok
                    END IF
                END IF

                LET l_tmp = ""

                CASE
                    WHEN m_regop[i].match == "OP_PLUS"
                        IF gt_string_is_whitespace(l_data.getCharAt(j)) THEN
                            WHILE TRUE
                                IF gt_string_is_whitespace(l_data.getCharAt(j)) THEN
                                    IF m_regop[i].remember THEN
                                        LET l_tmp = l_tmp.append(l_data.getCharAt(j))
                                    END IF
                                    LET j = j + 1
                                ELSE
                                    IF m_regop[i].remember THEN
                                        LET m_matches[k] = l_tmp
                                        LET k = k + 1
                                    END IF

                                    IF i = m_regop.getLength() AND j = l_data.getLength() + 1 THEN

                                        LET l_ok = TRUE
                                    ELSE
                                        LET l_ok = FALSE
                                    END IF

                                    EXIT WHILE
                                END IF
                            END WHILE
                        ELSE
                            LET l_ok = FALSE
                            CALL gt_set_error("ERROR", %"Not whitespace")
                            RETURN l_ok
                        END IF

                    WHEN m_regop[i].match == "OP_QUESTION"
                        IF gt_string_is_whitespace(l_data.getCharAt(j)) THEN
                            IF m_regop[i].remember THEN
                                LET m_matches[k] = l_data.getCharAt(j)
                                LET k = k + 1
                            END IF
                        END IF

                    WHEN m_regop[i].match == "OP_STAR"
                        IF gt_string_is_whitespace(l_data.getCharAt(j)) THEN
                            WHILE TRUE
                                IF gt_string_is_whitespace(l_data.getCharAt(j)) THEN
                                    IF m_regop[i].remember THEN
                                        LET l_tmp = l_tmp.append(l_data.getCharAt(j))
                                    END IF
                                    LET j = j + 1
                                ELSE
                                    IF m_regop[i].remember THEN
                                        LET m_matches[k] = l_tmp
                                        LET k = k + 1
                                    END IF

                                    IF i = m_regop.getLength() AND j = l_data.getLength() + 1 THEN

                                        LET l_ok = TRUE
                                    ELSE
                                        LET l_ok = FALSE
                                    END IF

                                    EXIT WHILE
                                END IF
                            END WHILE
                        END IF

                    OTHERWISE
                        CALL gt_set_abort(FALSE, "Invalid regexp operation")
                END CASE

            #------------------------------------------------------------------#
            # Pattern : \S                                                     #
            #------------------------------------------------------------------#

            WHEN m_regop[i].pattern == "NOP_WHITESPACE"
                IF l_at_start THEN
                    LET l_at_start = FALSE
                    IF j != 1 THEN
                        LET l_ok = FALSE
                        CALL gt_set_error("ERROR", %"")
                        RETURN l_ok
                    END IF
                END IF

                LET l_tmp = ""

                CASE
                    WHEN m_regop[i].match == "OP_PLUS"
                        IF NOT gt_string_is_whitespace(l_data.getCharAt(j)) THEN
                            WHILE TRUE
                                IF NOT gt_string_is_whitespace(l_data.getCharAt(j)) THEN
                                    IF m_regop[i].remember THEN
                                        LET l_tmp = l_tmp.append(l_data.getCharAt(j))
                                    END IF
                                    LET j = j + 1
                                ELSE
                                    IF m_regop[i].remember THEN
                                        LET m_matches[k] = l_tmp
                                        LET k = k + 1
                                    END IF

                                    IF i = m_regop.getLength() AND j = l_data.getLength() + 1 THEN

                                        LET l_ok = TRUE
                                    ELSE
                                        LET l_ok = FALSE
                                    END IF

                                    EXIT WHILE
                                END IF
                            END WHILE
                        ELSE
                            LET l_ok = FALSE
                            CALL gt_set_error("ERROR", %"Not alphanumeric")
                            RETURN l_ok
                        END IF

                    WHEN m_regop[i].match == "OP_QUESTION"
                        IF NOT gt_string_is_whitespace(l_data.getCharAt(j)) THEN
                            IF m_regop[i].remember THEN
                                LET m_matches[k] = l_data.getCharAt(j)
                                LET k = k + 1
                            END IF
                        END IF

                    WHEN m_regop[i].match == "OP_STAR"
                        IF NOT gt_string_is_whitespace(l_data.getCharAt(j)) THEN
                            WHILE TRUE
                                IF NOT gt_string_is_alphanumeric(l_data.getCharAt(j)) THEN
                                    IF m_regop[i].remember THEN
                                        LET l_tmp = l_tmp.append(l_data.getCharAt(j))
                                    END IF
                                    LET j = j + 1
                                ELSE
                                    IF m_regop[i].remember THEN
                                        LET m_matches[k] = l_tmp
                                        LET k = k + 1
                                    END IF

                                    IF i = m_regop.getLength() AND j = l_data.getLength() + 1 THEN

                                        LET l_ok = TRUE
                                    ELSE
                                        LET l_ok = FALSE
                                    END IF

                                    EXIT WHILE
                                END IF
                            END WHILE
                        END IF

                    OTHERWISE
                        CALL gt_set_abort(FALSE, "Invalid regexp operation")
                END CASE

            #------------------------------------------------------------------#
            # Pattern : \d                                                     #
            #------------------------------------------------------------------#

            WHEN m_regop[i].pattern == "OP_NUMERIC"
                IF l_at_start THEN
                    LET l_at_start = FALSE
                    IF j != 1 THEN
                        LET l_ok = FALSE
                        CALL gt_set_error("ERROR", %"")
                        RETURN l_ok
                    END IF
                END IF

                LET l_tmp = ""

                CASE
                    WHEN m_regop[i].match == "OP_PLUS"
                        IF gt_string_is_numeric(l_data.getCharAt(j)) THEN
                            WHILE TRUE
                                IF gt_string_is_numeric(l_data.getCharAt(j)) THEN
                                    IF m_regop[i].remember THEN
                                        LET l_tmp = l_tmp.append(l_data.getCharAt(j))
                                    END IF
                                    LET j = j + 1
                                ELSE
                                    IF m_regop[i].remember THEN
                                        LET m_matches[k] = l_tmp
                                        LET k = k + 1
                                    END IF

                                    IF i = m_regop.getLength() AND j = l_data.getLength() + 1 THEN

                                        LET l_ok = TRUE
                                    ELSE
                                        LET l_ok = FALSE
                                    END IF

                                    EXIT WHILE
                                END IF
                            END WHILE
                        ELSE
                            LET l_ok = FALSE
                            CALL gt_set_error("ERROR", %"Not numeric")
                            RETURN l_ok
                        END IF

                    WHEN m_regop[i].match == "OP_QUESTION"
                        IF gt_string_is_numeric(l_data.getCharAt(j)) THEN
                            IF m_regop[i].remember THEN
                                LET m_matches[k] = l_data.getCharAt(j)
                                LET k = k + 1
                            END IF
                        END IF

                    WHEN m_regop[i].match == "OP_STAR"
                        IF gt_string_is_numeric(l_data.getCharAt(j)) THEN
                            WHILE TRUE
                                IF gt_string_is_numeric(l_data.getCharAt(j)) THEN
                                    IF m_regop[i].remember THEN
                                        LET l_tmp = l_tmp.append(l_data.getCharAt(j))
                                    END IF
                                    LET j = j + 1
                                ELSE
                                    IF m_regop[i].remember THEN
                                        LET m_matches[k] = l_tmp
                                        LET k = k + 1
                                    END IF

                                    IF i = m_regop.getLength() AND j = l_data.getLength() + 1 THEN

                                        LET l_ok = TRUE
                                    ELSE
                                        LET l_ok = FALSE
                                    END IF

                                    EXIT WHILE
                                END IF
                            END WHILE
                        END IF

                    OTHERWISE
                        CALL gt_set_abort(FALSE, "Invalid regexp operation")
                END CASE

            #------------------------------------------------------------------#
            # Pattern : \D                                                     #
            #------------------------------------------------------------------#

            WHEN m_regop[i].pattern == "NOP_NUMERIC"
                IF l_at_start THEN
                    LET l_at_start = FALSE
                    IF j != 1 THEN
                        LET l_ok = FALSE
                        CALL gt_set_error("ERROR", %"")
                        RETURN l_ok
                    END IF
                END IF

                LET l_tmp = ""

                CASE
                    WHEN m_regop[i].match == "OP_PLUS"
                        IF NOT gt_string_is_numeric(l_data.getCharAt(j)) THEN
                            WHILE TRUE
                                IF NOT gt_string_is_numeric(l_data.getCharAt(j)) THEN
                                    IF m_regop[i].remember THEN
                                        LET l_tmp = l_tmp.append(l_data.getCharAt(j))
                                    END IF
                                    LET j = j + 1
                                ELSE
                                    IF m_regop[i].remember THEN
                                        LET m_matches[k] = l_tmp
                                        LET k = k + 1
                                    END IF

                                    IF i = m_regop.getLength() AND j = l_data.getLength() + 1 THEN

                                        LET l_ok = TRUE
                                    ELSE
                                        LET l_ok = FALSE
                                    END IF

                                    EXIT WHILE
                                END IF
                            END WHILE
                        ELSE
                            LET l_ok = FALSE
                            CALL gt_set_error("ERROR", %"Not alphanumeric")
                            RETURN l_ok
                        END IF

                    WHEN m_regop[i].match == "OP_QUESTION"
                        IF NOT gt_string_is_numeric(l_data.getCharAt(j)) THEN
                            IF m_regop[i].remember THEN
                                LET m_matches[k] = l_data.getCharAt(j)
                                LET k = k + 1
                            END IF
                        END IF

                    WHEN m_regop[i].match == "OP_STAR"
                        IF NOT gt_string_is_numeric(l_data.getCharAt(j)) THEN
                            WHILE TRUE
                                IF NOT gt_string_is_numeric(l_data.getCharAt(j)) THEN
                                    IF m_regop[i].remember THEN
                                        LET l_tmp = l_tmp.append(l_data.getCharAt(j))
                                    END IF
                                    LET j = j + 1
                                ELSE
                                    IF m_regop[i].remember THEN
                                        LET m_matches[k] = l_tmp
                                        LET k = k + 1
                                    END IF

                                    IF i = m_regop.getLength() AND j = l_data.getLength() + 1 THEN

                                        LET l_ok = TRUE
                                    ELSE
                                        LET l_ok = FALSE
                                    END IF

                                    EXIT WHILE
                                END IF
                            END WHILE
                        END IF

                    OTHERWISE
                        CALL gt_set_abort(FALSE, "Invalid regexp operation")
                END CASE

            #------------------------------------------------------------------#
            # Pattern :                                                        #
            #------------------------------------------------------------------#

            OTHERWISE
                 IF l_at_start THEN
                    LET l_at_start = FALSE
                    IF j != 1 THEN
                        LET l_ok = FALSE
                        CALL gt_set_error("ERROR", %"")
                        RETURN l_ok
                    END IF
                END IF

              IF l_data.getCharAt(j) == m_regop[i].pattern THEN
                    LET j = j + 1
                ELSE
                    LET l_ok = FALSE
                    CALL gt_set_error("ERROR", %"NoMatch")
                    RETURN l_ok
                END IF
        END CASE
    END FOR

    RETURN l_ok

END FUNCTION


#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
