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
# Module to output the XHTML documentation.
# @category System Program
# @author Scott Newton
# @date September 2007
# @version $Id$
#

IMPORT os

#------------------------------------------------------------------------------#
# Function to set WHENEVER ANY ERROR for this module                           #
#------------------------------------------------------------------------------#

FUNCTION gtdocgen_xhtml_generator_id()

DEFINE
	l_id   STRING

	WHENEVER ANY ERROR STOP
	LET l_id = "$Id$"

END FUNCTION

##
# This function generates an index page for the documentation.
#

FUNCTION gt_generate_xhtml_index(l_source_directory)

DEFINE
    l_source_directory   STRING

DEFINE
    l_ok                     SMALLINT,
    l_requires_index         SMALLINT,
    l_requires_navigation    SMALLINT,
    i                        INTEGER,
    l_count                  INTEGER,
    l_documentation_count    INTEGER,
    l_path                   STRING,
    l_child                  STRING,
    l_dirhdl                 STRING,
    l_offset                 STRING,
    l_directory              STRING,
    l_filename               STRING,
    l_xhtmlhdl               STRING,
    l_class_id               STRING,
    l_stylesheet             STRING,
    l_build_directory        STRING,
    l_output_directory       STRING,
    l_documentation_name     STRING,
    l_documentation_path     STRING,
    l_documentation_text     STRING,
    l_original_source_path   STRING,
    l_directories            DYNAMIC ARRAY OF STRING

    CALL l_directories.clear()
    LET l_requires_index = FALSE
    LET l_requires_navigation = FALSE
    LET l_class_id = gt_class_id()
    LET l_stylesheet = gt_stylesheet()
    LET l_output_directory = gt_output_directory()

    IF NOT os.path.isdirectory(l_output_directory) THEN
        IF NOT os.path.mkdir(l_output_directory) THEN
            DISPLAY SFMT("Unable to create output directory %1", l_output_directory)
            RETURN
        END IF
    END IF

    CALL os.path.dirsort("name", 1)
    CALL os.path.dirfmask(5)

    LET l_dirhdl = os.path.diropen(l_source_directory)
    LET l_child = os.path.dirnext(l_dirhdl)

    WHILE l_child IS NOT NULL
        LET l_path = os.path.join(l_source_directory, l_child)

        IF os.path.isdirectory(l_path) THEN
            CALL gt_generate_xhtml_index(l_path)
            CALL l_directories.appendElement()
            LET l_directories[l_directories.getLength()] = l_path
        END IF

        IF os.path.extension(l_path) == "4gl" THEN
            LET l_requires_index = TRUE
        END IF

        LET l_child = os.path.dirnext(l_dirhdl)
    END WHILE

    CALL os.path.dirclose(l_dirhdl)

    IF l_source_directory = gt_source_directory() THEN
         LET l_requires_index = TRUE
    ELSE
          LET l_requires_navigation = TRUE
    END IF

    IF l_requires_index THEN
        LET l_original_source_path = gt_source_directory()
        LET l_offset = l_source_directory.subString(l_original_source_path.getLength() + 1 , l_source_directory.getLength())
        LET l_build_directory = os.path.join(l_output_directory, l_offset.subString(2, l_offset.getLength()))

        IF NOT os.path.isdirectory(l_build_directory) THEN
            IF NOT os.path.mkdir(l_build_directory) THEN
                DISPLAY SFMT("Unable to create output directory %1", l_output_directory)
                RETURN
            END IF
        END IF

        LET l_filename = os.path.join(l_build_directory, "index.html")

        LET l_count = gt_string_count(l_offset, "/")

        FOR i = 1 TO l_count
            LET l_stylesheet = "../", l_stylesheet
        END FOR

        CALL gt_create_xhtml_document(l_filename, l_stylesheet, l_class_id)
            RETURNING l_ok, l_xhtmlhdl

        IF l_ok THEN
            CALL gt_xhtml_header(l_xhtmlhdl, %"Index")
            CALL gt_xhtml_body(l_xhtmlhdl, "")
            CALL gt_xhtml_heading(l_xhtmlhdl, "index", 1, %"Index")
            CALL gt_xhtml_hr(l_xhtmlhdl, "")
            CALL gt_xhtml_table(l_xhtmlhdl, "index")

            IF l_requires_navigation == TRUE THEN
                CALL gt_xhtml_a(l_xhtmlhdl, "index", %"Back", "../index.html", "")
                CALL gt_xhtml_br(l_xhtmlhdl, "br")
            END IF

            FOR i = 1 TO l_directories.getLength()
                CALL gt_xhtml_tr(l_xhtmlhdl, "index")
                CALL gt_xhtml_td(l_xhtmlhdl, "index")

                LET l_path = os.path.basename(l_directories[i])
                LET l_documentation_path = l_path,
                                                    os.path.separator(),
                                                    "index.html"

                CALL gt_xhtml_a(l_xhtmlhdl, "index", l_path, l_documentation_path, "")
                CALL gt_xhtml_end_td(l_xhtmlhdl)

                CALL gt_xhtml_td(l_xhtmlhdl, "index")
                CALL gt_xhtml_text(l_xhtmlhdl, %"Directory")
                CALL gt_xhtml_end_td(l_xhtmlhdl)

                CALL gt_xhtml_end_tr(l_xhtmlhdl)
          END FOR

            LET l_documentation_count = gt_documentation_count()

            FOR i = 1 TO l_documentation_count

                CALL gt_documentation_values(i)
                    RETURNING l_documentation_name,
                                 l_documentation_path,
                                 l_documentation_text

                IF l_documentation_path == l_offset THEN
                    LET l_directory = os.path.join(gt_output_directory(), l_path)

                    LET l_documentation_name = os.Path.basename(l_documentation_name)
                    LET l_documentation_name = os.Path.rootname(l_documentation_name)
                    LET l_documentation_name = l_documentation_name, ".html"

                    CALL gt_xhtml_tr(l_xhtmlhdl, "index")
                    CALL gt_xhtml_td(l_xhtmlhdl, "index")
                    CALL gt_xhtml_a(l_xhtmlhdl, "index", l_documentation_name, l_documentation_name, "")
                    CALL gt_xhtml_end_td(l_xhtmlhdl)

                    CALL gt_xhtml_td(l_xhtmlhdl, "index")
                    CALL gt_xhtml_text(l_xhtmlhdl, l_documentation_text)
                    CALL gt_xhtml_end_td(l_xhtmlhdl)

                    CALL gt_xhtml_end_tr(l_xhtmlhdl)
                END IF
            END FOR

            CALL gt_xhtml_end_table(l_xhtmlhdl)

            IF l_requires_navigation == TRUE THEN
                CALL gt_xhtml_br(l_xhtmlhdl, "br")
                CALL gt_xhtml_a(l_xhtmlhdl, "index", %"Back", "../index.html", "")
            END IF

            CALL gt_xhtml_hr(l_xhtmlhdl, "")
            CALL gt_xhtml_div(l_xhtmlhdl, "footer")
            CALL gt_xhtml_p(l_xhtmlhdl, "footer")
            CALL gt_xhtml_text(l_xhtmlhdl, %"Documentation generated by GtDocgen")
            CALL gt_xhtml_br(l_xhtmlhdl, "footer")
            CALL gt_xhtml_text(l_xhtmlhdl, TODAY)
            CALL gt_xhtml_end_p(l_xhtmlhdl)
            CALL gt_xhtml_end_div(l_xhtmlhdl)
            CALL gt_write_xhtml_document(l_xhtmlhdl)
        END IF
    END IF

END FUNCTION

##
# This function generates the documentation for each of the source modules.
#

FUNCTION gt_generate_xhtml_documentation()

DEFINE
    l_ok                         SMALLINT,
    i                            INTEGER,
    j                            INTEGER,
    k                            INTEGER,
    l_count                      INTEGER,
    l_tag_count                  INTEGER,
    l_function_count             INTEGER,
    l_parameter_count            INTEGER,
    l_return_value_count         INTEGER,
    l_documentation_count        INTEGER,
    l_name                       STRING,
    l_path                       STRING,
    l_text                       STRING,
    l_class_id                   STRING,
    l_directory                  STRING,
    l_filename                   STRING,
    l_xhtmlhdl                   STRING,
    l_stylesheet                 STRING,
    l_tag_name                   STRING,
    l_tag_value                  STRING,
    l_function_name              STRING,
    l_function_text              STRING,
    l_parameter_name             STRING,
    l_parameter_type             STRING,
    l_output_directory           STRING,
    l_parameter_description      STRING,
    l_return_value_name          STRING,
    l_return_value_type          STRING,
    l_return_value_description   STRING,
    l_buffer                     base.StringBuffer

    LET l_class_id = gt_class_id()
    LET l_output_directory = gt_output_directory()
    LET l_buffer = base.StringBuffer.create()

    IF NOT os.path.isdirectory(l_output_directory) THEN
        IF NOT os.path.mkdir(l_output_directory) THEN
            DISPLAY SFMT("Unable to create output directory %1", l_output_directory)
            RETURN
        END IF
    END IF

    LET l_documentation_count = gt_documentation_count()

    FOR i = 1 TO l_documentation_count

        CALL gt_documentation_values(i)
            RETURNING l_name, l_path, l_text

        LET l_stylesheet = gt_stylesheet()
        LET l_name = os.path.basename(l_name)
        LET l_directory = os.path.join(gt_output_directory(), l_path.subString(2, l_path.getLength()))

        LET l_count = gt_string_count(l_path.subString(2, l_path.getLength()), "/")

        FOR j = 1 TO l_count + 1
            LET l_stylesheet = "../", l_stylesheet
        END FOR

        IF NOT os.path.isdirectory(l_directory) THEN
            IF NOT os.path.mkdir(l_directory) THEN
                DISPLAY SFMT("Unable to create output directory %1", l_output_directory)
                RETURN
            END IF
        END IF

        LET l_name = os.path.rootname(l_name)
        LET l_filename = os.path.join(l_directory, l_name || ".html")

        CALL gt_create_xhtml_document(l_filename, l_stylesheet, l_class_id)
            RETURNING l_ok, l_xhtmlhdl

        IF l_ok THEN
            CALL gt_xhtml_header(l_xhtmlhdl, l_name)
            CALL gt_xhtml_body(l_xhtmlhdl, "")
            CALL gt_xhtml_heading(l_xhtmlhdl, "title", 1, l_name)

            CALL gt_xhtml_div(l_xhtmlhdl, "title")
            CALL gt_xhtml_a(l_xhtmlhdl, "title", %"Return to Main Index", "index.html", "")
            CALL gt_xhtml_end_div(l_xhtmlhdl)
            CALL gt_xhtml_hr(l_xhtmlhdl, "")

            LET l_tag_count = gt_documentation_tag_count(i)

            IF l_tag_count > 0 THEN
                CALL gt_xhtml_table(l_xhtmlhdl, "header")

                FOR j = 1 TO l_tag_count
                    CALL gt_documentation_tag_values(i, j)
                        RETURNING l_tag_name, l_tag_value
                    CALL gt_xhtml_tr(l_xhtmlhdl, "header")
                    CALL gt_xhtml_th(l_xhtmlhdl, "header")
                    CALL gt_xhtml_text(l_xhtmlhdl, gt_string_to_camelcase(l_tag_name))
                    CALL gt_xhtml_end_th(l_xhtmlhdl)
                    CALL gt_xhtml_td(l_xhtmlhdl, "header")
                    CALL gt_xhtml_text(l_xhtmlhdl, l_tag_value)
                    CALL gt_xhtml_end_td(l_xhtmlhdl)
                    CALL gt_xhtml_end_tr(l_xhtmlhdl)
                END FOR

                CALL gt_xhtml_end_table(l_xhtmlhdl)
                CALL gt_xhtml_hr(l_xhtmlhdl, "")
            END IF

            LET l_function_count = gt_documentation_function_count(i)

            #------------------------------------------------------------------#
            # Generate the function index                                      #
            #------------------------------------------------------------------#

            CALL gt_xhtml_heading(l_xhtmlhdl, "index", 2, %"Index")
            CALL gt_xhtml_hr(l_xhtmlhdl, "index")

            CALL gt_xhtml_table(l_xhtmlhdl, "index")

            CALL gt_xhtml_tr(l_xhtmlhdl, "index")
            CALL gt_xhtml_th(l_xhtmlhdl, "index")
            CALL gt_xhtml_text(l_xhtmlhdl, %"Function")
            CALL gt_xhtml_end_th(l_xhtmlhdl)
            CALL gt_xhtml_th(l_xhtmlhdl, "index")
            CALL gt_xhtml_text(l_xhtmlhdl, %"Description")
            CALL gt_xhtml_end_th(l_xhtmlhdl)
            CALL gt_xhtml_end_tr(l_xhtmlhdl)

            FOR j = 1 TO l_function_count
                CALL gt_xhtml_tr(l_xhtmlhdl, "index")

                CALL gt_documentation_function_values(i, j)
                    RETURNING l_function_name, l_function_text

                CALL gt_xhtml_td(l_xhtmlhdl, "index")
                CALL gt_xhtml_a(l_xhtmlhdl, "index", l_function_name, "#" || l_function_name, "")
                CALL gt_xhtml_end_td(l_xhtmlhdl)

                CALL gt_xhtml_td(l_xhtmlhdl, "index")
                CALL gt_xhtml_text(l_xhtmlhdl, l_function_text)
                CALL gt_xhtml_end_td(l_xhtmlhdl)

                CALL gt_xhtml_end_tr(l_xhtmlhdl)
            END FOR

            CALL gt_xhtml_end_table(l_xhtmlhdl)
            CALL gt_xhtml_hr(l_xhtmlhdl, "")

            #------------------------------------------------------------------#
            # Generate the documentation for each function                     #
            #------------------------------------------------------------------#

            CALL gt_xhtml_heading(l_xhtmlhdl, "index", 2, %"Details")
            CALL gt_xhtml_hr(l_xhtmlhdl, "index")

            FOR j = 1 TO l_function_count
                LET l_tag_count = gt_documentation_function_tag_count(i, j)
                LET l_parameter_count = gt_documentation_function_parameter_count(i, j)
                LET l_return_value_count = gt_documentation_function_return_value_count(i, j)

                CALL gt_documentation_function_values(i, j)
                    RETURNING l_function_name, l_function_text

                CALL gt_xhtml_a(l_xhtmlhdl, "function", "", "", l_function_name)
                CALL gt_xhtml_heading(l_xhtmlhdl, "function", 3, l_function_name)

                CALL gt_xhtml_table(l_xhtmlhdl, "function")

                CALL gt_xhtml_tr(l_xhtmlhdl, "function")
                CALL gt_xhtml_th(l_xhtmlhdl, "function")
                CALL gt_xhtml_text(l_xhtmlhdl, %"Signature")
                CALL gt_xhtml_end_th(l_xhtmlhdl)
                CALL gt_xhtml_td(l_xhtmlhdl, "function")

                CALL gt_xhtml_code(l_xhtmlhdl, "function", l_function_name)
                CALL gt_xhtml_text(l_xhtmlhdl, "(")

                FOR k = 1 TO l_parameter_count
                    CALL gt_documentation_function_parameter_values(i, j, k)
                        RETURNING l_parameter_name, l_parameter_type, l_parameter_description

                    CALL gt_xhtml_text(l_xhtmlhdl, " ")

                    IF k == 1 THEN
                        CALL gt_xhtml_code(l_xhtmlhdl, "parameter", l_parameter_name)
                    ELSE
                        CALL gt_xhtml_text(l_xhtmlhdl, " , ")
                        CALL gt_xhtml_code(l_xhtmlhdl, "parameter", l_parameter_name)
                    END IF

                    CALL gt_xhtml_text(l_xhtmlhdl, " ")
                END FOR

                CALL gt_xhtml_text(l_xhtmlhdl, ")")

                IF l_return_value_count > 0 THEN
                    CALL gt_xhtml_text(l_xhtmlhdl, %" RETURNING")
                END IF

                FOR k = 1 TO l_return_value_count
                    CALL gt_documentation_function_return_value_values(i, j, k)
                        RETURNING l_return_value_name, l_return_value_type, l_return_value_description

                    CALL gt_xhtml_text(l_xhtmlhdl, " ")

                    IF k == 1 THEN
                        CALL gt_xhtml_code(l_xhtmlhdl, "returnvalue", l_return_value_name)
                    ELSE
                        CALL gt_xhtml_text(l_xhtmlhdl, " , ")
                        CALL gt_xhtml_code(l_xhtmlhdl, "returnvalue", l_return_value_name)
                    END IF

                    CALL gt_xhtml_text(l_xhtmlhdl, " ")
                END FOR

                CALL gt_xhtml_text(l_xhtmlhdl, l_buffer.toString())

                CALL gt_xhtml_end_td(l_xhtmlhdl)
                CALL gt_xhtml_end_tr(l_xhtmlhdl)

                CALL gt_xhtml_tr(l_xhtmlhdl, "function")
                CALL gt_xhtml_th(l_xhtmlhdl, "function")
                CALL gt_xhtml_text(l_xhtmlhdl, %"Description")
                CALL gt_xhtml_end_th(l_xhtmlhdl)
                CALL gt_xhtml_td(l_xhtmlhdl, "function")
                CALL gt_xhtml_text(l_xhtmlhdl, gt_string_to_sentence(l_function_text))
                CALL gt_xhtml_end_td(l_xhtmlhdl)
                CALL gt_xhtml_end_tr(l_xhtmlhdl)
                CALL gt_xhtml_end_table(l_xhtmlhdl)
                CALL gt_xhtml_br(l_xhtmlhdl, "br")

                IF l_parameter_count > 0
                OR l_return_value_count > 0 THEN
                     CALL gt_xhtml_table(l_xhtmlhdl, "parameter")
                END IF

                IF l_parameter_count > 0 THEN
                    CALL gt_xhtml_tr(l_xhtmlhdl, "parameter")
                    CALL gt_xhtml_th(l_xhtmlhdl, "parameter")
                    CALL gt_xhtml_text(l_xhtmlhdl, %"Parameter")
                    CALL gt_xhtml_end_th(l_xhtmlhdl)
                    CALL gt_xhtml_th(l_xhtmlhdl, "parameter")
                    CALL gt_xhtml_text(l_xhtmlhdl, %"Type")
                    CALL gt_xhtml_end_th(l_xhtmlhdl)
                    CALL gt_xhtml_th(l_xhtmlhdl, "parameter")
                    CALL gt_xhtml_text(l_xhtmlhdl, %"Description")
                    CALL gt_xhtml_end_th(l_xhtmlhdl)
                    CALL gt_xhtml_end_tr(l_xhtmlhdl)

                    FOR k = 1 TO l_parameter_count
                        CALL gt_documentation_function_parameter_values(i, j, k)
                            RETURNING l_parameter_name, l_parameter_type, l_parameter_description

                        CALL gt_xhtml_tr(l_xhtmlhdl, "parameter")
                        CALL gt_xhtml_td(l_xhtmlhdl, "parameter")
                        CALL gt_xhtml_text(l_xhtmlhdl, l_parameter_name)
                        CALL gt_xhtml_end_td(l_xhtmlhdl)
                        CALL gt_xhtml_td(l_xhtmlhdl, "parameter")
                        CALL gt_xhtml_text(l_xhtmlhdl, l_parameter_type)
                        CALL gt_xhtml_end_td(l_xhtmlhdl)
                        CALL gt_xhtml_td(l_xhtmlhdl, "parameter")
                        CALL gt_xhtml_text(l_xhtmlhdl, l_parameter_description)
                        CALL gt_xhtml_end_td(l_xhtmlhdl)
                        CALL gt_xhtml_end_tr(l_xhtmlhdl)
                    END FOR
                END IF

                IF l_return_value_count > 0 THEN
                    CALL gt_xhtml_tr(l_xhtmlhdl, "returnvalue")
                    CALL gt_xhtml_th(l_xhtmlhdl, "returnvalue")
                    CALL gt_xhtml_text(l_xhtmlhdl, %"Return Value")
                    CALL gt_xhtml_end_th(l_xhtmlhdl)
                    CALL gt_xhtml_th(l_xhtmlhdl, "returnvalue")
                    CALL gt_xhtml_text(l_xhtmlhdl, %"Type")
                    CALL gt_xhtml_end_th(l_xhtmlhdl)
                    CALL gt_xhtml_th(l_xhtmlhdl, "returnvalue")
                    CALL gt_xhtml_text(l_xhtmlhdl, %"Description")
                    CALL gt_xhtml_end_th(l_xhtmlhdl)
                    CALL gt_xhtml_end_tr(l_xhtmlhdl)

                    FOR k = 1 TO l_return_value_count
                        CALL gt_documentation_function_return_value_values(i, j, k)
                            RETURNING l_return_value_name, l_return_value_type, l_return_value_description

                        CALL gt_xhtml_tr(l_xhtmlhdl, "returnvalue")
                        CALL gt_xhtml_td(l_xhtmlhdl, "returnvalue")
                        CALL gt_xhtml_text(l_xhtmlhdl, l_return_value_name)
                        CALL gt_xhtml_end_td(l_xhtmlhdl)
                        CALL gt_xhtml_td(l_xhtmlhdl, "returnvalue")
                        CALL gt_xhtml_text(l_xhtmlhdl, l_return_value_type)
                        CALL gt_xhtml_end_td(l_xhtmlhdl)
                        CALL gt_xhtml_td(l_xhtmlhdl, "returnvalue")
                        CALL gt_xhtml_text(l_xhtmlhdl, l_return_value_description)
                        CALL gt_xhtml_end_td(l_xhtmlhdl)
                        CALL gt_xhtml_end_tr(l_xhtmlhdl)
                    END FOR
                END IF

                IF l_parameter_count > 0
                OR l_return_value_count > 0 THEN
                     CALL gt_xhtml_end_table(l_xhtmlhdl)
                END IF

                CALL gt_xhtml_br(l_xhtmlhdl, "")
                CALL gt_xhtml_a(l_xhtmlhdl, "function", %"Return to Top", "#top", "")
                CALL gt_xhtml_hr(l_xhtmlhdl, "")
            END FOR

            CALL gt_xhtml_div(l_xhtmlhdl, "footer")
            CALL gt_xhtml_p(l_xhtmlhdl, "footer")
            CALL gt_xhtml_text(l_xhtmlhdl, %"Documentation generated by GtDocgen")
            CALL gt_xhtml_br(l_xhtmlhdl, "")
            CALL gt_xhtml_text(l_xhtmlhdl, TODAY)
            CALL gt_xhtml_end_p(l_xhtmlhdl)
            CALL gt_xhtml_end_div(l_xhtmlhdl)
            CALL gt_write_xhtml_document(l_xhtmlhdl)
        END IF
    END FOR

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
