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
# Module to parse the source code for documentation.
# @category System Program
# @author Scott Newton
# @date September 2007
# @version $Id$
#

IMPORT os

DEFINE
    m_function_found        SMALLINT,
    m_count                 INTEGER,
    m_tag_count             INTEGER,
    m_function_count        INTEGER,
    m_function_index        INTEGER,
    m_parameter_count       INTEGER,
    m_return_value_count    INTEGER,
	m_documentation_count   INTEGER,

    m_root_directory        STRING,
    m_current_function      STRING,

	m_documentation DYNAMIC ARRAY OF RECORD
        name   STRING,
        path   STRING,
        text   STRING,

        tag DYNAMIC ARRAY OF RECORD
            name    STRING,
            value   STRING
        END RECORD,

        method DYNAMIC ARRAY OF RECORD
            name   STRING,
            text   STRING,

            tag DYNAMIC ARRAY OF RECORD
                name    STRING,
                value   STRING
            END RECORD,

            parameter DYNAMIC ARRAY OF RECORD
                name          STRING,
                type          STRING,
                description   STRING
            END RECORD,

            return_value DYNAMIC ARRAY OF RECORD
                name          STRING,
                type          STRING,
                description   STRING
            END RECORD
        END RECORD
	END RECORD

##
# Function to set WHENEVER ANY ERROR and the Id string
#

FUNCTION gtdocgen_parser_id()

DEFINE
	l_id   STRING

	WHENEVER ANY ERROR STOP
	LET l_id = "$Id$"

END FUNCTION

##
# Function to get the root directory for the documentation
# @return m_root_directory The documentation root directory
#

FUNCTION get_documentation_root_directory()

    RETURN m_root_directory

END FUNCTION

##
# Function to return the current function index.
# @return m_function_index The current function index.
#

FUNCTION gt_function_index()

    RETURN m_function_index

END FUNCTION

##
# Function to return the documentation count.
# @return m_documentation[].getLength() The documentation count.
#

FUNCTION gt_documentation_count()

    RETURN m_documentation.getLength()

END FUNCTION

##
# Function to return the module documentation details.
# @param l_documentation_index The index to use.
# @return m_documentation[].name The name of the file the documentation is from.
# @return m_documentation[].path The path to the file relative to the given root directory.
# @return m_documentation[].text The description of the module.
#

FUNCTION gt_documentation_values(l_documentation_index)

DEFINE
    l_documentation_index   INTEGER

    RETURN m_documentation[l_documentation_index].name,
             m_documentation[l_documentation_index].path,
             m_documentation[l_documentation_index].text

END FUNCTION

##
# Function to return the documentation tag count.
# @param l_documentation_index The index to use.
# @return m_documentation[].tag.getLength() The length of the tag array.
#

FUNCTION gt_documentation_tag_count(l_documentation_index)

DEFINE
    l_documentation_index   INTEGER

    RETURN m_documentation[l_documentation_index].tag.getLength()

END FUNCTION

##
# Function to return the documentation tag values.
# @param l_documentation_index The index to use.
# @param l_tag_index The index to use.
# @return m_documentation[].tag[].name The name of the tag.
# @return m_documentation[].tag[].value The value of the tag.
#

FUNCTION gt_documentation_tag_values(l_documentation_index, l_tag_index)

DEFINE
    l_documentation_index   INTEGER,
    l_tag_index             INTEGER

    RETURN m_documentation[l_documentation_index].tag[l_tag_index].name,
             m_documentation[l_documentation_index].tag[l_tag_index].value

END FUNCTION

##
# Function to return the documentation function count.
# @param l_documentation_index The index to use.
# @return m_documentation[].method.getLength() The length of the function array.
#

FUNCTION gt_documentation_function_count(l_documentation_index)

DEFINE
    l_documentation_index   INTEGER

    RETURN m_documentation[l_documentation_index].method.getLength()

END FUNCTION

##
# Function to return the documentation function values.
# @param l_documentation_index The documentation index to use.
# @param l_function_index The function index to use.
# @return m_documentation[].method.[].name The name of the method.
# @return m_documentation[].method[].text The method documentation text.
#

FUNCTION gt_documentation_function_values(l_documentation_index, l_function_index)

DEFINE
    l_documentation_index   INTEGER,
    l_function_index        INTEGER

    RETURN m_documentation[l_documentation_index].method[l_function_index].name,
             m_documentation[l_documentation_index].method[l_function_index].text

END FUNCTION

##
# Function to return the function tag count.
# @param l_documentation_index The documentation index to use.
# @param l_function_index The function index to use.
# @return m_documentation[].method[].tag.getLength() The length of the function tag array.
#
FUNCTION gt_documentation_function_tag_count(l_documentation_index, l_function_index)

DEFINE
    l_documentation_index   INTEGER,
    l_function_index        INTEGER

    RETURN m_documentation[l_documentation_index].method[l_function_index].tag.getLength()

END FUNCTION

##
# Function to return the function tag values.
# @param l_documentation_index The documentation index to use.
# @param l_function_index The function index to use.
# @param l_tag index The tag index to use.
# @return m_documentation[].method[].tag[].name The name of the function tag.
# @return m_documentation[].method[].tag[].value The value of the function tag.
#

FUNCTION gt_documentation_function_tag_values(l_documentation_index, l_function_index, l_tag_index)

DEFINE
    l_documentation_index   INTEGER,
    l_function_index        INTEGER,
    l_tag_index             INTEGER

    RETURN m_documentation[l_documentation_index].method[l_function_index].tag[l_tag_index].name,
             m_documentation[l_documentation_index].method[l_function_index].tag[l_tag_index].value

END FUNCTION

##
# Function to return the function parameter count.
# @param l_documentation_index The documentation index.
# @param l_function_index The function index.
# @return m_documentation[].method[].parameter.getLength() The length of the parameter array.
#

FUNCTION gt_documentation_function_parameter_count(l_documentation_index, l_function_index)

DEFINE
    l_documentation_index   INTEGER,
    l_function_index        INTEGER

    RETURN m_documentation[l_documentation_index].method[l_function_index].parameter.getLength()

END FUNCTION

##
# Function to return the function parameter values.
# @param l_documentation_index The documentation index.
# @param l_function_index The function index.
# @param l_parameter_index The parameter index.
# @return m_documentation[].method[].parameter[].name The name of the parameter.
# @return m_documentation[].method[].parameter[].type The type of the parameter.
# @return m_documentation[].method[].parameter[].description The description of the parameter.
#

FUNCTION gt_documentation_function_parameter_values(l_documentation_index, l_function_index, l_parameter_index)

DEFINE
    l_documentation_index   INTEGER,
    l_function_index        INTEGER,
    l_parameter_index       INTEGER

    RETURN m_documentation[l_documentation_index].method[l_function_index].parameter[l_parameter_index].name,
             m_documentation[l_documentation_index].method[l_function_index].parameter[l_parameter_index].type,
             m_documentation[l_documentation_index].method[l_function_index].parameter[l_parameter_index].description

END FUNCTION

##
# Function to return the function return value count.
# @param l_documentation_index The documentation index.
# @param l_function_index The function index.
# @return m_documentation[].method[].return_value.getLength() The length of the return value array.
#

FUNCTION gt_documentation_function_return_value_count(l_documentation_index, l_function_index)

DEFINE
    l_documentation_index   INTEGER,
    l_function_index        INTEGER

    RETURN m_documentation[l_documentation_index].method[l_function_index].return_value.getLength()

END FUNCTION

##
# Function to return the function return value values.
# @param l_documentation_index The documentation index.
# @param l_function_index The function index.
# @param l_return_value_index The return value index.
# @return m_documentation[].method[].return_value[].name The name of the return value.
# @return m_documentation[].method[].return_value[].type The type of the return value.
# @return m_documentation[].method[].return_value[].description The description of the return value.
#

FUNCTION gt_documentation_function_return_value_values(l_documentation_index, l_function_index, l_return_value_index)

DEFINE
    l_documentation_index   INTEGER,
    l_function_index        INTEGER,
    l_return_value_index    INTEGER

    RETURN m_documentation[l_documentation_index].method[l_function_index].return_value[l_return_value_index].name,
             m_documentation[l_documentation_index].method[l_function_index].return_value[l_return_value_index].type,
             m_documentation[l_documentation_index].method[l_function_index].return_value[l_return_value_index].description

END FUNCTION

##
# This function parses all the 4gl files in the given directory.
# @param l_directory The directory to parse.
# @return l_ok TRUE if the parsing was successful, FALSE otherwise.
#

FUNCTION gt_parse_source(l_directory)

DEFINE
    l_directory   STRING

DEFINE
    l_ok                SMALLINT,
    i                   INTEGER,
    l_dirhdl            INTEGER,
    l_directory_count   INTEGER,
    l_file              STRING,
    l_directory_list    DYNAMIC ARRAY OF STRING

    LET l_ok = FALSE
    LET l_dirhdl = NULL

    IF m_root_directory IS NULL THEN
        LET m_root_directory = l_directory
    END IF

    IF os.path.isdirectory(l_directory) THEN
        CALL os.path.dirfmask(5)
        CALL os.path.dirsort("name", 1)

        LET l_dirhdl = os.path.diropen(l_directory)

        LET l_file = os.path.dirNext(l_dirhdl)

        WHILE l_file IS NOT NULL
            IF l_file == "."
            OR l_file == ".." THEN
                CONTINUE WHILE
            END IF

            IF l_directory.getCharAt(l_directory.getLength()) == os.path.separator() THEN
                LET l_file = l_directory, l_file
            ELSE
                LET l_file = l_directory, os.path.separator(), l_file
            END IF

            IF os.path.isdirectory(l_file) THEN
                LET l_directory_count = l_directory_count + 1
                LET l_directory_list[l_directory_count] = l_file
            END IF

            IF l_file.substring(l_file.getlength() - 3, l_file.getLength()) == ".4gl" THEN
                LET m_documentation_count = m_documentation_count + 1
                LET m_documentation[m_documentation_count].name = l_file
                LET m_documentation[m_documentation_count].path = l_directory.subString(m_root_directory.getLength() + 1, l_directory.getLength())
                CALL gt_4gl_parser_init()
DISPLAY "Processing ", l_file, "..."
                CALL gt_parse_4gl_file(l_file, TRUE)
                CALL p_gt_extract_documentation()
                LET l_ok = TRUE
            END IF

            LET l_file = os.path.dirNext(l_dirhdl)
        END WHILE

        CALL os.path.dirclose(l_dirhdl)

        IF gt_recursive() THEN
            FOR i = 1 TO l_directory_list.getlength()
                LET l_ok = gt_parse_source(l_directory_list[i])
            END FOR
        END IF
    ELSE
    END IF

    #FOR i = 1 TO m_documentation_count
        #DISPLAY "Module : ", m_documentation[i].name
        #DISPLAY "            ", m_documentation[i].text

        #FOR j = 1 TO m_documentation[i].function.getlength()
        #    DISPLAY "    Function : ", m_documentation[i].function[j].name
        #    DISPLAY "                  ", m_documentation[i].function[j].text

        #    FOR k = 1 TO m_documentation[i].function[j].tag.getlength()
        #        DISPLAY "        Tags : ", m_documentation[i].function[j].tag[k].name, " : ", m_documentation[i].function[j].tag[k].value
        #    END FOR

        #    FOR k = 1 TO m_documentation[i].function[j].parameter.getlength()
        #        DISPLAY "        Parameter : ", m_documentation[i].function[j].parameter[k].name, " : ", m_documentation[i].function[j].parameter[k].type, " : ", m_documentation[i].function[j].parameter[k].description
        #    END FOR

        #    FOR k = 1 TO m_documentation[i].function[j].return_value.getlength()
        #        DISPLAY "        Return Values : ", m_documentation[i].function[j].return_value[k].name, " : ", m_documentation[i].function[j].return_value[k].type, " : ", m_documentation[i].function[j].return_value[k].description
        #    END FOR
        #END FOR
    #END FOR

    RETURN l_ok

END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

##
# This function extracts the documentation from the module.
#

FUNCTION p_gt_extract_documentation()

DEFINE
    i               INTEGER,
    l_pos           INTEGER,
    l_token_count   INTEGER,
    l_token         STRING

    LET l_pos = 0

    LET m_count = 0
    LET m_tag_count = 0
    LET m_function_count = 0
    LET m_parameter_count = 0
    LET m_return_value_count = 0
    LET m_function_found = FALSE

    LET l_token_count = gt_4gl_token_count()

    WHILE l_pos < l_token_count
        LET l_pos = l_pos + 1
        LET l_token = gt_4gl_next_token(l_pos)

        IF l_token.touppercase() == "FUNCTION"
        OR l_token.touppercase() == "MAIN" THEN
            LET l_pos = gt_4gl_parse_function(l_pos)

            FOR i = 1 TO gt_4gl_function_count()
                LET m_function_count = m_function_count + 1

                IF i == 1 THEN
                    LET m_documentation[m_documentation_count].method[m_function_count].name = gt_4gl_function_value(i)
                ELSE
                    LET m_documentation[m_documentation_count].method[m_function_count].parameter[m_parameter_count].name = gt_4gl_function_value(i)
                END IF
            END FOR
        END IF
    END WHILE

    LET l_pos = 0

    WHILE l_pos < l_token_count
        LET l_pos = l_pos + 1
        LET l_token = gt_4gl_next_token(l_pos)

        IF l_token == "\"" THEN
            LET l_pos = l_pos + 1

            WHILE gt_4gl_next_token(l_pos) != "\""
                LET l_pos = l_pos + 1
            END WHILE

            CONTINUE WHILE
        END IF

        IF l_token == "'" THEN
            LET l_pos = l_pos + 1

            WHILE gt_4gl_next_token(l_pos) != "'"
                LET l_pos = l_pos + 1
            END WHILE

            CONTINUE WHILE
        END IF

        CASE
            WHEN l_token.subString(1, 2) == "##"
                LET l_pos = gtp_parse_documentation(l_pos)

            WHEN l_token.toUpperCase() == "DEFINE"
                LET l_pos = gtp_parse_define(l_pos)
                LET l_pos = l_pos - 1

            WHEN l_token.toUpperCase() == "FUNCTION"
              OR l_token.toUpperCase() == "MAIN"
                LET m_function_found = TRUE

            WHEN l_token.toUpperCase() == "RETURN"
                IF gt_4gl_next_token(l_pos - 1) != "@" THEN
                    LET l_pos = gtp_parse_return(l_pos)
                    LET l_pos = l_pos - 1
                END IF

            OTHERWISE
        END CASE
    END WHILE

END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

##
# This function parses the documentation blocks and extracts into the
# m_documentation module variable.
# @param l_pos The position the documentation block starts.
# @return l_pos The end position of the documentation block.
#

FUNCTION gtp_parse_documentation(l_pos)

DEFINE
    l_pos   INTEGER

DEFINE
    i                  INTEGER,
    l_index            INTEGER,
    l_function_count   INTEGER,
    l_line             STRING,
    l_name             STRING,
    l_text             STRING,
    l_token            STRING,
    l_command          STRING

    LET l_function_count = 0
    LET m_count = m_count + 1
    LET m_tag_count  = 0
    LET m_parameter_count = 0
    LET m_return_value_count = 0
    LET m_current_function = NULL

    IF m_count > 1 THEN
        LET m_current_function = gtp_find_next_function(l_pos)

        IF m_current_function IS NOT NULL THEN
            FOR i = 1 TO m_documentation[m_documentation_count].method.getlength()
                IF m_documentation[m_documentation_count].method[i].name = m_current_function THEN
                    LET l_function_count = i
                    EXIT FOR
                END IF
            END FOR

            IF l_function_count == 0 THEN
                RETURN l_pos + 1
            END IF
        ELSE
            RETURN l_pos + 1
        END IF
    ELSE
        LET l_function_count = 2
    END IF

    WHILE NOT gt_4gl_is_keyword(l_token)
        #----------------------------------------------------------------------#
        # Documentation comes through as lines                                 #
        #----------------------------------------------------------------------#

        LET l_line = l_token.trim()

        IF l_line.getCharAt(1) != "#" THEN
            EXIT WHILE
        END IF

        IF l_line.subString(1, 2) == "##" THEN
            EXIT WHILE
        END IF

        LET l_line = l_line.subString(2, l_line.getLength() - 1)
        LET l_line = l_line.trim()

        IF l_line.getlength() == 0 THEN
        END IF

        #----------------------------------------------------------------------#
        # Found a doxygen control character                                    #
        #----------------------------------------------------------------------#

        IF l_line.getCharAt(1) == "@" THEN
            LET l_index = l_line.getindexof(" ", 1)
            LET l_command = l_line.subString(1, l_index)
            LET l_command = l_command.trim()
            LET l_line = l_line.substring(l_index, l_line.getLength())
            LET l_line = l_line.trim()

            CASE
                WHEN l_command == "@param"
                    LET m_parameter_count = m_parameter_count + 1
                    LET l_index = l_line.getindexof(" ", 1)
                    LET l_name = l_line.subString(1, l_index)
                    LET m_documentation[m_documentation_count].method[l_function_count].parameter[m_parameter_count].name = l_name.trim()
                    LET l_text = l_line.subString(l_index, l_line.getLength())
                    LET m_documentation[m_documentation_count].method[l_function_count].parameter[m_parameter_count].description = l_text.trim()

                WHEN l_command == "@return"
                    LET m_return_value_count = m_return_value_count + 1
                    LET l_index = l_line.getindexof(" ", 1)
                    LET l_name = l_line.subString(1, l_index)
                    LET m_documentation[m_documentation_count].method[l_function_count].return_value[m_return_value_count].name = l_name.trim()
                    LET l_text = l_line.subString(l_index, l_line.getLength())
                    LET m_documentation[m_documentation_count].method[l_function_count].return_value[m_return_value_count].description = l_text.trim()

                OTHERWISE
                    IF m_count == 1 THEN
                        LET m_tag_count = m_tag_count + 1
                        LET m_documentation[m_documentation_count].tag[m_tag_count].name = l_command.subString(2, l_command.getLength())
                        LET m_documentation[m_documentation_count].tag[m_tag_count].value = l_line.trim()
                    ELSE
                        LET m_tag_count = m_tag_count + 1
                        LET m_documentation[m_documentation_count].method[l_function_count].tag[m_tag_count].name = l_command.subString(2, l_command.getLength())
                        LET m_documentation[m_documentation_count].method[l_function_count].tag[m_tag_count].value = l_line.trim()
                    END IF
            END CASE
        ELSE
            IF m_count == 1 THEN
                LET m_documentation[m_documentation_count].text = m_documentation[m_documentation_count].text, " ", l_line.trim()
            ELSE
                LET m_documentation[m_documentation_count].method[l_function_count].text = m_documentation[m_documentation_count].method[l_function_count].text, " ", l_line.trim()
            END IF
        END IF

        LET l_pos = l_pos + 1
        LET l_token = gt_4gl_next_token(l_pos)
    END WHILE

    RETURN l_pos

END FUNCTION

##
# Function to parse the DEFINEs.
# @param l_pos The position the DEFINEs start from.
# @return l_pos The end position of the DEFINEs.
#

FUNCTION gtp_parse_define(l_pos)

DEFINE
    l_pos   INTEGER

DEFINE
    i                  INTEGER,
    j                  INTEGER,
    l_function_index   INTEGER,
    l_name             STRING,
    l_type             STRING

    # m_function_found is only set to TRUE once the first FUNCTION statement has
    # been found. So if it is FALSE then we must be looking at the modular
    # DEFINEs.

    IF m_function_found == TRUE THEN
        FOR i = 1 TO m_documentation[m_documentation_count].method.getlength()
            IF m_documentation[m_documentation_count].method[i].name = m_current_function THEN
                LET l_function_index = i
                EXIT FOR
            END IF
        END FOR

        # We did not find the function which should never happen!

        IF l_function_index == 0 THEN
            RETURN l_pos + 1
        END IF
    ELSE
        LET l_function_index = 1
    END IF

    LET m_function_index = l_function_index

    CALL gt_4gl_parse_define(l_pos)
        RETURNING l_pos

    FOR i = 1 TO gt_4gl_define_count(l_function_index)
        CALL gt_4gl_define_value(l_function_index, i)
            RETURNING l_name, l_type

        FOR j = 1 TO gt_documentation_function_parameter_count(m_documentation_count, l_function_index)
            #DISPLAY m_documentation[m_documentation_count].function[l_function_index].parameter[j].name, ":", l_name, ":", l_type
            IF m_documentation[m_documentation_count].method[l_function_index].parameter[j].name == l_name THEN
                #DISPLAY "MATCH!", l_function_index
                LET m_documentation[m_documentation_count].method[l_function_index].parameter[j].type = l_type
                EXIT FOR
            END IF
        END FOR
    END FOR

    RETURN l_pos

END FUNCTION

##
# Function to parse the RETURNs.
# @param l_pos The position the RETURNs start from.
# @return l_pos The end position of the RETURNs.
#

FUNCTION gtp_parse_return(l_pos)

DEFINE
    l_pos   INTEGER

DEFINE
    i                  INTEGER,
    l_function_index   INTEGER,
    l_type             STRING

    FOR i = 1 TO m_documentation[m_documentation_count].method.getlength()
        IF m_documentation[m_documentation_count].method[i].name = m_current_function THEN
            LET l_function_index = i
            EXIT FOR
        END IF
    END FOR

    IF l_function_index == 0 THEN
        RETURN l_pos + 1
    END IF

    LET l_pos = gt_4gl_parse_return(l_function_index, l_pos)

    FOR i = 1 TO gt_4gl_return_count(l_function_index)
        CALL gt_4gl_return_value(l_function_index, i)
            RETURNING l_type

        LET m_documentation[m_documentation_count].method[l_function_index].return_value[i].type = l_type
    END FOR

    RETURN l_pos

END FUNCTION

##
# Function to find the next FUNCTION statement.
# @param l_pos The position to start from.
# @return l_function The next function.
#

FUNCTION gtp_find_next_function(l_pos)

DEFINE
    l_pos   INTEGER

DEFINE
    i            INTEGER,
    l_token      STRING,
    l_function   STRING

    LET l_function = NULL

    FOR i = l_pos TO gt_4gl_token_count()
        LET l_token = gt_4gl_next_token(i)
        LET l_token = l_token.touppercase()

        IF l_token == "MAIN" THEN
            LET l_function = "main"
            EXIT FOR
        END IF

        IF l_token == "FUNCTION" THEN
            LET l_function = gt_4gl_next_token(i + 1)
            EXIT FOR
        END IF
    END FOR

    RETURN l_function

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
