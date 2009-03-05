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
# This module contains the functions for the parsing specific statements of the
# 4gl language. This includes both those for the langauge itself (e.g. DEFINEs)
# and those for the documentation generation.
# @category System Program
# @author Scott Newton
# @date September 2007
# @version $Id$
#

DEFINE
    m_function DYNAMIC ARRAY OF RECORD
        name   STRING,

        define DYNAMIC ARRAY OF RECORD
            name   STRING,
            type   STRING
        END RECORD,

        return DYNAMIC ARRAY OF RECORD
            name   STRING,
            type   STRING
        END RECORD
    END RECORD

#------------------------------------------------------------------------------#
# Function to set WHENEVER ANY ERROR for this module                           #
#------------------------------------------------------------------------------#

FUNCTION libgt_4gl_grammar_id()

DEFINE
    l_id   STRING

	WHENEVER ANY ERROR STOP
	LET l_id = "$Id$"

END FUNCTION

##
# This function returns whether the given token is a 4gl variable or not.
# @param l_token The token to check.
# @return l_ok TRUE is the token is a 4gl variable, FALSE otherwise.
#

FUNCTION gt_4gl_is_variable(l_token)

DEFINE
    l_token   STRING

DEFINE
    l_ok     SMALLINT,
    i        INTEGER,
    l_char   STRING

    LET l_ok = FALSE

    FOR i = 1 TO l_token.getLength()
        LET l_char = l_token.getcharat(i)

        IF ( l_char >= "a"
        AND  l_char <= "z" )
        OR ( l_char >= "A"
        AND  l_char <= "Z" )
        OR ( l_char >= "0"
        AND  l_char <= "9" )
        OR    l_char == "_" THEN
            LET l_ok = TRUE
        ELSE
            LET l_ok = FALSE
            EXIT FOR
        END IF
    END FOR

    RETURN l_ok

END FUNCTION

##
# This function returns whether the given token is 4gl punctuation or not.
# @param l_token The token to check.
# @return TRUE is the token is 4gl punctuation, FALSE otherwise.
#

FUNCTION gt_4gl_is_punctuation(l_token)

DEFINE
    l_token   STRING

DEFINE
    l_ok   SMALLINT

    LET l_ok = FALSE

    IF l_token == "."
    OR l_token == ","
    OR l_token == "="
    OR l_token == "=="
    OR l_token == "("
    OR l_token == ")"
    OR l_token == "\""
    OR l_token == "'" THEN
        LET l_ok = TRUE
    END IF

    RETURN l_ok

END FUNCTION

##
# This function checks to see whether the given token is a comment or not.
# @param l_token The token to check.
# @return l_ok TRUE is the token is a comment, FALSE otherwise.
#

FUNCTION gt_4gl_is_comment(l_token)

DEFINE
    l_token   STRING

DEFINE
    l_ok   SMALLINT

    LET l_ok = FALSE
    IF l_token.getCharAt(1) == "#"
    OR l_token.subString(1, 2) == "--"
    OR l_token.getCharAt(1) == "{" THEN
        LET l_ok = TRUE
    END IF

    RETURN l_ok

END FUNCTION

##
# This function checks to see whether the given token is a datatype or not.
# @param l_token The token to check.
# @return l_ok TRUE is the token is a datatype, FALSE otherwise.
#

FUNCTION gt_4gl_is_datatype(l_token)

DEFINE
    l_token   STRING

DEFINE
    l_ok   SMALLINT

    LET l_ok = FALSE
    LET l_token = l_token.touppercase()

    IF l_token == "BASE"
    OR l_token == "BYTE"
    OR l_token == "CHAR"
    OR l_token == "CHARACTER"
    OR l_token == "DATE"
    OR l_token == "DATETIME"
    OR l_token == "DEC"
    OR l_token == "DECIMAL"
    OR l_token == "DOUBLE"
    OR l_token == "FLOAT"
    OR l_token == "INT"
    OR l_token == "INTEGER"
    OR l_token == "INTERVAL"
    OR l_token == "MONEY"
    OR l_token == "NUMERIC"
    OR l_token == "OM"
    OR l_token == "OS"
    OR l_token == "REAL"
    OR l_token == "SMALLFLOAT"
    OR l_token == "SMALLINT"
    OR l_token == "STRING"
    OR l_token == "TEXT"
    OR l_token == "UI"
    OR l_token == "UTILS"
    OR l_token == "VARCHAR" THEN
        LET l_ok = TRUE
    END IF

    RETURN l_ok

END FUNCTION

##
# This function returns whether the given token is a 4gl keyword or not.
# @param l_token The token to check.
# @return l_ok TRUE if the token is a 4gl keyword, FALSE otherwise.
#

FUNCTION gt_4gl_is_keyword(l_token)

DEFINE
    l_token   STRING

DEFINE
    l_ok   SMALLINT

    LET l_ok = FALSE
    LET l_token = l_token.touppercase()

    IF l_token == "CALL"
    OR l_token == "CONSTANT"
    OR l_token == "DATABASE"
    OR l_token == "DEFINE"
    OR l_token == "DELETE"
    OR l_token == "END"
    OR l_token == "EXECUTE"
    OR l_token == "FOR"
    OR l_token == "FUNCTION"
    OR l_token == "GLOBAL"
    OR l_token == "IF"
    OR l_token == "IMPORT"
    OR l_token == "INSERT"
    OR l_token == "LET"
    OR l_token == "RECORD"
    OR l_token == "RETURN"
    OR l_token == "SCHEMA"
    OR l_token == "SELECT"
    OR l_token == "UPDATE"
    OR l_token == "WHENEVER"
    OR l_token == "WHILE" THEN
        LET l_ok = TRUE
    END IF

    RETURN l_ok

END FUNCTION

##
# This function returns whether the given token is a doxygen command or not.
# @param l_token The token to check.
# @return l_ok TRUE is the token is a doxygen command, FALSE otherwise.
#

FUNCTION p_gt_is_doxygen_command(l_token)

DEFINE
    l_token   STRING

    IF l_token == "@a"
    OR l_token == "@addindex"
    OR l_token == "@addtogroup"
    OR l_token == "@anchor"
    OR l_token == "@arg"
    OR l_token == "@attention"
    OR l_token == "@author"
    OR l_token == "@b"
    OR l_token == "@brief"
    OR l_token == "@bug"
    OR l_token == "@c"
    OR l_token == "@callgraph"
    OR l_token == "@callergraph"
    OR l_token == "@category"
    OR l_token == "@class"
    OR l_token == "@code"
    OR l_token == "@cond"
    OR l_token == "@copydoc"
    OR l_token == "@date"
    OR l_token == "@def"
    OR l_token == "@defgroup"
    OR l_token == "@deprecated"
    OR l_token == "@details"
    OR l_token == "@dir"
    OR l_token == "@dontinclude"
    OR l_token == "@dot"
    OR l_token == "@dotfile"
    OR l_token == "@e"
    OR l_token == "@else"
    OR l_token == "@elseif"
    OR l_token == "@em"
    OR l_token == "@endcode"
    OR l_token == "@endcond"
    OR l_token == "@enddot"
    OR l_token == "@endhtmlonly"
    OR l_token == "@endif"
    OR l_token == "@endlatexonly"
    OR l_token == "@endlink"
    OR l_token == "@endmanonly"
    OR l_token == "@endmsc"
    OR l_token == "@endverbatim"
    OR l_token == "@endxmlonly"
    OR l_token == "@enum"
    OR l_token == "@example"
    OR l_token == "@exception"
    OR l_token == "@f$"
    OR l_token == "@f["
    OR l_token == "@f]"
    OR l_token == "@file"
    OR l_token == "@fn"
    OR l_token == "@hideinitializer"
    OR l_token == "@htmlinclude"
    OR l_token == "@htmlonly"
    OR l_token == "@if"
    OR l_token == "@ifnot"
    OR l_token == "@image"
    OR l_token == "@include"
    OR l_token == "@includelineno"
    OR l_token == "@ingroup"
    OR l_token == "@interval"
    OR l_token == "@invariant"
    OR l_token == "@interface"
    OR l_token == "@latexonly"
    OR l_token == "@li"
    OR l_token == "@line"
    OR l_token == "@link"
    OR l_token == "@mainpage"
    OR l_token == "@manonly"
    OR l_token == "@msc"
    OR l_token == "@n"
    OR l_token == "@name"
    OR l_token == "@namespace"
    OR l_token == "@nosubgrouping"
    OR l_token == "@note"
    OR l_token == "@overload"
    OR l_token == "@p"
    OR l_token == "@package"
    OR l_token == "@page"
    OR l_token == "@par"
    OR l_token == "@paragraph"
    OR l_token == "@param"
    OR l_token == "@post"
    OR l_token == "@pre"
    OR l_token == "@private"
    OR l_token == "@privatesection"
    OR l_token == "@property"
    OR l_token == "@protected"
    OR l_token == "@protectedsection"
    OR l_token == "@protocol"
    OR l_token == "@public"
    OR l_token == "@publicsection"
    OR l_token == "@ref"
    OR l_token == "@relates"
    OR l_token == "@relatesalso"
    OR l_token == "@remarks"
    OR l_token == "@return"
    OR l_token == "@retval"
    OR l_token == "@sa"
    OR l_token == "@section"
    OR l_token == "@see"
    OR l_token == "@seeinitializer"
    OR l_token == "@since"
    OR l_token == "@skip"
    OR l_token == "@skipline"
    OR l_token == "@struct"
    OR l_token == "@subpage"
    OR l_token == "@subsection"
    OR l_token == "@subsubsection"
    OR l_token == "@test"
    OR l_token == "@throw"
    OR l_token == "@todo"
    OR l_token == "@typedef"
    OR l_token == "@union"
    OR l_token == "@until"
    OR l_token == "@var"
    OR l_token == "@verbatim"
    OR l_token == "@verbinclude"
    OR l_token == "@version"
    OR l_token == "@warning"
    OR l_token == "@weakgroup"
    OR l_token == "@xmlonly"
    OR l_token == "@xrefitem"
    OR l_token == "@$"
    OR l_token == "@@"
    OR l_token == "@\\"
    OR l_token == "@&"
    OR l_token == "@~"
    OR l_token == "@<"
    OR l_token == "@>"
    OR l_token == "@#"
    OR l_token == "@%" THEN
        RETURN TRUE
    ELSE
        RETURN FALSE
    END IF

END FUNCTION

##
# This function returns the number of entries in the m_function array.
# @return l_count The number of entries in the m_function array.
#

FUNCTION gt_4gl_function_count()

    RETURN m_function.getlength()

END FUNCTION

##
# This function returns the value of the m_function array for the given position.
# @param l_count The position to get the value for.
# @return l_value The value of the function name at the given position.
#

FUNCTION gt_4gl_function_value(l_count)

DEFINE
    l_count   INTEGER

    RETURN m_function[l_count].name

END FUNCTION

##
# This function parses the FUNCTION statement.
# @param l_pos The position in the token array to start from.
# @return l_pos The position in the token array once parsing is complete.
#

FUNCTION gt_4gl_parse_function(l_pos)

DEFINE
    l_pos   INTEGER

DEFINE
    l_count   INTEGER,
    l_token   STRING

    LET l_count = 0
    CALL m_function.clear()

    IF gt_4gl_next_token(l_pos + 2) != "(" THEN
        LET l_pos = l_pos + 1
    ELSE
        LET l_pos = l_pos + 1
        LET l_count = l_count + 1
        LET m_function[l_count].name = gt_4gl_next_token(l_pos)

        WHILE l_token != ")"
            LET l_pos = l_pos + 1
            LET l_token = gt_4gl_next_token(l_pos)

            IF l_token == "("
            OR l_token == "'"
            OR l_token == "\""
            OR l_token == "'" THEN
                LET l_pos = l_pos + 1
                LET l_token = gt_4gl_next_token(l_pos)
                CONTINUE WHILE
            ELSE
                LET l_count = l_count + 1
                LET m_function[l_count].name = l_token
            END IF

            LET l_pos = l_pos + 1
            LET l_token = gt_4gl_next_token(l_pos)
        END WHILE
    END IF

    RETURN l_pos

END FUNCTION

##
# This function returns the number of entries in the m_define array.
# @return l_count The number of entries in the m_define array.
#

FUNCTION gt_4gl_define_count(l_function_index)

DEFINE
    l_function_index   INTEGER

    RETURN m_function[l_function_index].define.getlength()

END FUNCTION

##
# This function returns the value of the m_define array for the given position.
# @param l_count The position to get the value for.
# @return l_value The value of the m_define array at the given position.
#

FUNCTION gt_4gl_define_value(l_function_index, l_define_index)

DEFINE
    l_function_index   INTEGER,
    l_define_index     INTEGER

    RETURN m_function[l_function_index].define[l_define_index].name,
             m_function[l_function_index].define[l_define_index].type

END FUNCTION

##
# This function parses the DEFINE statement.
# @param l_pos The position in the token array to start from.
# @return l_pos The position in the token array once parsing is complete.
#

FUNCTION gt_4gl_parse_define(l_pos)

DEFINE
    l_pos   INTEGER

DEFINE
    i                  INTEGER,
    l_save             INTEGER,
    l_count            INTEGER,
    l_index            INTEGER,
    l_function_index   INTEGER,
    l_tmp              STRING,
    l_type             STRING,
    l_token            STRING,
    l_variable         STRING

    LET l_save = 0
    LET l_function_index = gt_function_index()

    IF l_function_index == 0 THEN
        LET l_count = 1
    ELSE
        LET l_count = m_function[l_function_index].define.getLength()
    END IF

    LET l_pos = l_pos + 1
    LET l_token = gt_4gl_next_token(l_pos)

    WHILE TRUE
        CASE
            WHEN l_token.toUpperCase() == "DYNAMIC"
                LET l_pos = l_pos + 1
                LET l_token = gt_4gl_next_token(l_pos)
                CONTINUE WHILE

            WHEN l_token.toUpperCase() == "ARRAY"
                LET i = i + 1
                LET l_type = "ARRAY"
                LET l_count = l_count + 1

                IF l_variable.getLength() > 0 THEN
                    LET m_function[l_function_index].define[l_count].name = l_variable

                    IF l_save > 0 THEN
                        FOR i = l_save TO l_count
                            LET m_function[l_function_index].define[i].type = l_type
                        END FOR

                        LET l_save = 0
                    ELSE
                        LET m_function[l_function_index].define[l_count].type = l_type
                    END IF
                END IF

                WHILE TRUE
                    LET l_pos =  l_pos + 1
                    LET l_token = gt_4gl_next_token(l_pos)

                    IF l_token.toUpperCase() == "OF" THEN
                        EXIT WHILE
                    END IF
                END WHILE

                LET l_variable = l_variable, "[]"
                LET l_pos =  l_pos + 1
                LET l_token = gt_4gl_next_token(l_pos)
                CONTINUE WHILE

            WHEN l_token.toUpperCase() == "RECORD"
                LET l_variable = l_variable, "."
                LET l_pos =  l_pos + 1
                LET l_token = gt_4gl_next_token(l_pos)

                IF l_token.toUpperCase() == "LIKE" THEN
                    LET l_pos =  l_pos + 1
                    LET l_token = gt_4gl_next_token(l_pos)
                END IF

                CONTINUE WHILE

            WHEN l_token.toUpperCase() == "LIKE"
                LET l_pos =  l_pos + 1
                LET l_token = gt_4gl_next_token(l_pos)
                CONTINUE WHILE

            WHEN l_token.toUpperCase() == "END"
                #DISPLAY "FOUND END"
                LET l_tmp = gt_4gl_next_token(l_pos + 1)

                IF l_tmp.toUpperCase() == "RECORD" THEN
                    LET l_pos = l_pos + 2
                    LET l_token = gt_4gl_next_token(l_pos)
                    LET l_index = gt_string_rfind(l_variable, ".")

                    IF l_index > 0 THEN
                        LET l_variable = l_variable.subString(1, l_index - 1)
                        LET l_index = gt_string_rfind(l_variable, ".")

                        IF l_index > 0 THEN
                            LET l_variable = l_variable.subString(1, l_index)
                        END IF
                    END IF
                END IF

                CONTINUE WHILE

            WHEN l_token == "."
                LET l_variable = l_variable, l_token
                LET l_pos =  l_pos + 1
                LET l_token = gt_4gl_next_token(l_pos)
                CONTINUE WHILE

            WHEN l_token == ","
                LET l_pos =  l_pos + 1
                LET l_token = gt_4gl_next_token(l_pos)
                CONTINUE WHILE

            WHEN gt_4gl_is_datatype(l_token)
                IF l_variable.getCharAt(l_variable.getLength()) == "." THEN
                    LET l_variable = l_variable, l_token
                    LET l_pos = l_pos + 1
                    LET l_token = gt_4gl_next_token(l_pos)
                    CONTINUE WHILE
                END IF

                #DISPLAY "DATATYPE : ", l_token
                CALL gtp_4gl_parse_simple_datatype(l_pos, l_variable)
                    RETURNING l_pos, l_variable, l_type

                LET i = i + 1
                LET l_count = l_count + 1

                IF l_variable.getLength() > 0 THEN
                    LET m_function[l_function_index].define[l_count].name = l_variable

                    IF l_save > 0 THEN
                        FOR i = l_save TO l_count
                            LET m_function[l_function_index].define[i].type = l_type
                        END FOR

                        LET l_save = 0
                    ELSE
                        LET m_function[l_function_index].define[l_count].type = l_type
                    END IF

                    LET l_index = gt_string_rfind(l_variable, ".")

                    IF l_index > 0 THEN
                        LET l_variable = l_variable.subString(1, l_index)
                    ELSE
                        LET l_variable = ""
                    END IF
                END IF

                FOR i = 1 TO l_count
#DISPLAY "DEFINE : ", i USING "###", " : ",
#                            m_function[l_function_index].define[i].name, " : ",
#                            m_function[l_function_index].define[i].type
                END FOR

            WHEN gt_4gl_is_keyword(l_token)
              OR gt_4gl_is_comment(l_token)
                EXIT WHILE

            OTHERWISE
                LET l_variable = l_variable, l_token

                WHILE gt_4gl_next_token(l_pos + 1) == "."
                    LET l_pos = l_pos + 1
                    LET l_token = gt_4gl_next_token(l_pos)
                    LET l_variable = l_variable, l_token
                    LET l_pos = l_pos + 1
                    LET l_token = gt_4gl_next_token(l_pos)
                    LET l_variable = l_variable, l_token
                END WHILE
        END CASE

        LET l_pos = l_pos + 1
        LET l_token = gt_4gl_next_token(l_pos)
        #DISPLAY "End token = ", l_token
    END WHILE

    RETURN l_pos

END FUNCTION

##
# This function returns the number of entries in the m_define array.
# @return l_count The number of entries in the m_define array.
#

FUNCTION gt_4gl_return_count(l_function_index)

DEFINE
    l_function_index   INTEGER

    RETURN m_function[l_function_index].return.getlength()

END FUNCTION

##
# This function returns the value of the m_define array for the given position.
# @param l_count The position to get the value for.
# @return l_value The value of the m_define array at the given position.
#

FUNCTION gt_4gl_return_value(l_function_index, l_return_index)

DEFINE
    l_function_index   INTEGER,
    l_return_index     INTEGER

    RETURN m_function[l_function_index].return[l_return_index].type

END FUNCTION

##
# This function parses the RETURN statement.
# @param l_pos The position in the token array to start from.
# @return l_pos The position in the token array once parsing is complete.
#

FUNCTION gt_4gl_parse_return(l_function_index, l_pos)

DEFINE
    l_function_index   INTEGER,
    l_pos              INTEGER

DEFINE
    i                INTEGER,
    j                INTEGER,
    l_count          INTEGER,
    l_save           INTEGER,
    l_index          INTEGER,
    l_token          STRING,
    l_return_value   STRING,
    l_tmp            base.StringBuffer

    LET l_save = 0
    LET l_return_value = ""
    LET l_tmp = base.StringBuffer.create()

    LET l_pos = l_pos + 1
    LET l_token = gt_4gl_next_token(l_pos)

    WHILE TRUE
        IF gt_4gl_is_keyword(l_token) THEN
            EXIT WHILE
        END IF

        LET l_return_value = l_return_value, l_token

        LET l_pos = l_pos + 1
        LET l_token = gt_4gl_next_token(l_pos)

        CASE
            WHEN l_token == "("
                LET l_count = 0

                WHILE TRUE
                    LET l_return_value = l_return_value, l_token
                    LET l_pos = l_pos + 1
                    LET l_token = gt_4gl_next_token(l_pos)

                    IF l_token == "(" THEN
                        LET l_count = l_count + 1
                    END IF

                    IF l_token == ")" THEN
                        IF l_count = 0 THEN
                            EXIT WHILE
                        ELSE
                            LET l_count = l_count - 1
                        END IF
                    END IF
                END WHILE

                CONTINUE WHILE

            WHEN l_token == "["
                LET l_return_value = l_return_value, l_token

                WHILE TRUE
                    LET l_pos = l_pos + 1
                    LET l_token = gt_4gl_next_token(l_pos)

                    IF l_token == "]" THEN
                        EXIT WHILE
                    END IF
                END WHILE

                CONTINUE WHILE

            WHEN l_token == "."
                WHILE l_token == "."
                    LET l_return_value = l_return_value, l_token
                    LET l_pos = l_pos + 1
                    LET l_token = gt_4gl_next_token(l_pos)
                END WHILE

                CONTINUE WHILE

            WHEN l_token == "\""
                WHILE TRUE
                    LET l_return_value = "STRING"
                    LET l_pos = l_pos + 1
                    LET l_token = gt_4gl_next_token(l_pos)

                    IF l_token == "\"" THEN
                                                LET l_pos = l_pos + 1
                        LET l_token = gt_4gl_next_token(l_pos)
                        EXIT WHILE
                    END IF
                END WHILE

            WHEN l_token == "'"
                WHILE TRUE
                    LET l_return_value = "STRING"
                    LET l_pos = l_pos + 1
                    LET l_token = gt_4gl_next_token(l_pos)

                    IF l_token == "'" THEN
                        LET l_pos = l_pos + 1
                        LET l_token = gt_4gl_next_token(l_pos)
                        EXIT WHILE
                    END IF
                END WHILE

            OTHERWISE
                LET i = i + 1
#DISPLAY "RETURN : ", l_return_value
                LET m_function[l_function_index].return[i].name = l_return_value

                # Stored names will not include functions like getLength() etc

                IF l_return_value.getCharAt(l_return_value.getLength()) == ")" THEN
                    LET l_index = gt_string_rfind(l_return_value, ".")
                    LET l_return_value = l_return_value.subString(1, l_index - 1)
                END IF

                FOR j = 1 TO m_function[l_function_index].define.getLength()
                    IF m_function[l_function_index].define[j].name == l_return_value THEN
                        #DISPLAY l_return_value, " -> ", m_function[l_function_index].define[j].name, ":", m_function[l_function_index].define[j].type
                        LET m_function[l_function_index].return[i].type = m_function[l_function_index].define[j].type
                        EXIT FOR
                    END IF
                END FOR

                IF gt_string_is_empty(m_function[l_function_index].return[i].type) THEN
                    FOR j = 1 TO m_function[1].define.getLength()
                        #DISPLAY l_return_value, " -> ", m_function[1].define[j].name, ":", m_function[1].define[j].type
                        IF m_function[1].define[j].name == l_return_value THEN
                            LET m_function[l_function_index].return[i].type = m_function[1].define[j].type
                            EXIT FOR
                        END IF
                    END FOR
                END IF

                IF l_token == "," THEN
                    LET l_return_value = ""
                ELSE
                    EXIT WHILE
                END IF
        END CASE

        LET l_pos = l_pos + 1
        LET l_token = gt_4gl_next_token(l_pos)
    END WHILE

    RETURN l_pos

END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

FUNCTION gtp_4gl_parse_simple_datatype(l_pos, l_name)

DEFINE
    l_pos    INTEGER,
    l_name   STRING

DEFINE
    l_type    STRING,
    l_token   STRING

    LET l_token = gt_4gl_next_token(l_pos)

    CASE
        WHEN l_token.toUpperCase() == "BYTE"
            LET l_type = "BYTE"

        WHEN l_token.toUpperCase() == "CHAR"
          OR l_token.toUpperCase() == "CHARACTER"
            LET l_type = "CHAR"

        WHEN l_token.toUpperCase() == "DATE"
            LET l_type = "DATE"

        WHEN l_token.toUpperCase() == "DATETIME"
            LET l_type = "DATETIME"

        WHEN l_token.toUpperCase() == "DEC"
          OR l_token.toUpperCase() == "DECIMAL"
          OR l_token.toUpperCase() == "NUMERIC"
            LET l_type = "DECIMAL"

        WHEN l_token.toUpperCase() == "FLOAT"
          OR l_token.toUpperCase() == "DOUBLE PRECISION"
            LET l_type = "FLOAT"

        WHEN l_token.toUpperCase() == "INT"
          OR l_token.toUpperCase() == "INTEGER"
            LET l_type = "INTEGER"

        WHEN l_token.toUpperCase() == "INTERVAL"
            LET l_type = "INTERVAL"

        WHEN l_token.toUpperCase() == "MONEY"
            LET l_type = "MONEY"

        WHEN l_token.toUpperCase() == "REAL"
          OR l_token.toUpperCase() == "SMALLFLOAT"
            LET l_type = "REAL"

        WHEN l_token.toUpperCase() == "SMALLINT"
            LET l_type = "SMALLINT"

        WHEN l_token.toUpperCase() == "STRING"
            LET l_type = "STRING"

        WHEN l_token.toUpperCase() == "TEXT"
            LET l_type = "TEXT"

        WHEN l_token.toUpperCase() == "VARCHAR"
            LET l_type = "VARCHAR"

        # Now handle the Genero extensions

        WHEN l_token.toUpperCase() == "BASE"
          OR l_token.toUpperCase() == "OM"
          OR l_token.toUpperCase() == "OS"
          OR l_token.toUpperCase() == "UI"
          OR l_token.toUpperCase() == "UTILS"
            LET l_type = l_token

            WHILE gt_4gl_next_token(l_pos + 1) == "."
                LET l_pos = l_pos + 1
                LET l_type = l_type, gt_4gl_next_token(l_pos)
                LET l_pos = l_pos + 1
                LET l_type = l_type, gt_4gl_next_token(l_pos)
            END WHILE

        OTHERWISE
            LET l_type = "UNKNOWN"

    END CASE

    RETURN l_pos, l_name, l_type

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
