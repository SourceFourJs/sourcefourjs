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
   m_in_define          SMALLINT,
   m_in_return          SMALLINT,
   m_in_function        SMALLINT,
   m_in_documentation   SMALLINT,

   m_count                 INTEGER,
   m_tag_count             INTEGER,
   m_function_count        INTEGER,
   m_parameter_count       INTEGER,
   m_return_value_count    INTEGER,
	m_documentation_count   INTEGER,

	m_documentation   DYNAMIC ARRAY OF RECORD
      name   STRING,
      path   STRING,
      text   STRING,

      tag   DYNAMIC ARRAY OF RECORD
         name    STRING,
         value   STRING
      END RECORD,

      function   DYNAMIC ARRAY OF RECORD
         name   STRING,
         text   STRING,

         tag   DYNAMIC ARRAY OF RECORD
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

#------------------------------------------------------------------------------#
# Function to set WHENEVER ANY ERROR for this module                           #
#------------------------------------------------------------------------------#

FUNCTION gtdocgen_parser_id()

DEFINE
	l_id   STRING

	WHENEVER ANY ERROR STOP
	LET l_id = "$Id$"

END FUNCTION

FUNCTION gt_documentation_count()

   RETURN m_documentation.getLength()

END FUNCTION

FUNCTION gt_documentation_values(l_documentation_index)

DEFINE
   l_documentation_index   INTEGER

   RETURN m_documentation[l_documentation_index].name,
          m_documentation[l_documentation_index].path,
          m_documentation[l_documentation_index].text

END FUNCTION

FUNCTION gt_documentation_tag_count(l_documentation_index)

DEFINE
   l_documentation_index   INTEGER

   RETURN m_documentation[l_documentation_index].tag.getLength()

END FUNCTION

FUNCTION gt_documentation_tag_values(l_documentation_index, l_tag_index)

DEFINE
   l_documentation_index   INTEGER,
   l_tag_index             INTEGER

   RETURN m_documentation[l_documentation_index].tag[l_tag_index].name,
          m_documentation[l_documentation_index].tag[l_tag_index].value

END FUNCTION

FUNCTION gt_documentation_function_count(l_documentation_index)

DEFINE
   l_documentation_index   INTEGER

   RETURN m_documentation[l_documentation_index].function.getLength()

END FUNCTION

FUNCTION gt_documentation_function_values(l_documentation_index, l_function_index)

DEFINE
   l_documentation_index   INTEGER,
   l_function_index        INTEGER

   RETURN m_documentation[l_documentation_index].function[l_function_index].name,
          m_documentation[l_documentation_index].function[l_function_index].text

END FUNCTION

FUNCTION gt_documentation_function_tag_count(l_documentation_index, l_function_index)

DEFINE
   l_documentation_index   INTEGER,
   l_function_index        INTEGER

   RETURN m_documentation[l_documentation_index].function[l_function_index].tag.getLength()

END FUNCTION

FUNCTION gt_documentation_function_tag_values(l_documentation_index, l_function_index, l_tag_index)

DEFINE
   l_documentation_index   INTEGER,
   l_function_index        INTEGER,
   l_tag_index             INTEGER

   RETURN m_documentation[l_documentation_index].function[l_function_index].tag[l_tag_index].name,
          m_documentation[l_documentation_index].function[l_function_index].tag[l_tag_index].value

END FUNCTION

FUNCTION gt_documentation_function_parameter_count(l_documentation_index, l_function_index)

DEFINE
   l_documentation_index   INTEGER,
   l_function_index        INTEGER

   RETURN m_documentation[l_documentation_index].function[l_function_index].parameter.getLength()

END FUNCTION

FUNCTION gt_documentation_function_parameter_values(l_documentation_index, l_function_index, l_parameter_index)

DEFINE
   l_documentation_index   INTEGER,
   l_function_index        INTEGER,
   l_parameter_index       INTEGER

   RETURN m_documentation[l_documentation_index].function[l_function_index].parameter[l_parameter_index].name,
          m_documentation[l_documentation_index].function[l_function_index].parameter[l_parameter_index].type,
          m_documentation[l_documentation_index].function[l_function_index].parameter[l_parameter_index].description

END FUNCTION

FUNCTION gt_documentation_function_return_value_count(l_documentation_index, l_function_index)

DEFINE
   l_documentation_index   INTEGER,
   l_function_index        INTEGER

   RETURN m_documentation[l_documentation_index].function[l_function_index].return_value.getLength()

END FUNCTION

FUNCTION gt_documentation_function_return_value_values(l_documentation_index, l_function_index, l_return_value_index)

DEFINE
   l_documentation_index   INTEGER,
   l_function_index        INTEGER,
   l_return_value_index       INTEGER

   RETURN m_documentation[l_documentation_index].function[l_function_index].return_value[l_return_value_index].name,
          m_documentation[l_documentation_index].function[l_function_index].return_value[l_return_value_index].type,
          m_documentation[l_documentation_index].function[l_function_index].return_value[l_return_value_index].description

END FUNCTION

##
# Function_description
# @param param Parameter_description.
# @return returning Return_description.
#

FUNCTION gt_parse_source(l_directory)

DEFINE
   l_directory   STRING

DEFINE
   l_ok                SMALLINT,
   i,j,k               INTEGER,
   l_dirhdl            INTEGER,
   l_directory_count   INTEGER,
   l_file              STRING,
   l_directory_list    DYNAMIC ARRAY OF STRING

   LET l_ok = FALSE
   LET l_dirhdl = NULL

   IF os.path.isdirectory(l_directory) THEN
      CALL os.path.dirfmask(5)
      CALL os.path.dirsort("name", 1)

      LET l_dirhdl = os.path.diropen(l_directory)

      IF l_dirhdl IS NOT NULL THEN
         LET l_file = os.path.dirnext(l_dirhdl)

         WHILE l_file IS NOT NULL
            IF os.path.isdirectory(l_file) THEN
               LET l_directory_count = l_directory_count + 1
               LET l_directory_list[l_directory_count] = l_file
            END IF

            IF l_file.substring(l_file.getlength() - 3, l_file.getLength()) == ".4gl" THEN
               LET m_documentation_count = m_documentation_count + 1
               LET m_documentation[m_documentation_count].name = l_file
               LET m_documentation[m_documentation_count].path = ""
               CALL gt_4gl_parser_init()
               CALL gt_parse_4gl_file(l_file, TRUE)
               CALL p_gt_extract_documentation()
               LET l_ok = TRUE
            END IF

            LET l_file = os.path.dirnext(l_dirhdl)
         END WHILE

         CALL os.path.dirclose(l_dirhdl)

         IF gt_recursive() THEN
            FOR i = 1 TO l_directory_list.getlength()
               LET l_ok = gt_parse_source(l_directory_list[i])
            END FOR
         END IF
      END IF
   ELSE
   END IF

   FOR i = 1 TO m_documentation_count
      DISPLAY "Module : ", m_documentation[i].name
      DISPLAY "         ", m_documentation[i].text

      FOR j = 1 TO m_documentation[i].function.getlength()
         DISPLAY "   Function : ", m_documentation[i].function[j].name
         DISPLAY "              ", m_documentation[i].function[j].text

         FOR k = 1 TO m_documentation[i].function[j].tag.getlength()
            DISPLAY "      Tags : ", m_documentation[i].function[j].tag[k].name, " - ", m_documentation[i].function[j].tag[k].value
         END FOR

         FOR k = 1 TO m_documentation[i].function[j].parameter.getlength()
            DISPLAY "      Parameter : ", m_documentation[i].function[j].parameter[k].name, " - ", m_documentation[i].function[j].parameter[k].description
         END FOR

         FOR k = 1 TO m_documentation[i].function[j].return_value.getlength()
            DISPLAY "      Return Values : ", m_documentation[i].function[j].return_value[k].name, " - ", m_documentation[i].function[j].return_value[k].description
         END FOR
      END FOR
   END FOR

   RETURN l_ok

END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

FUNCTION p_gt_extract_documentation()

DEFINE
   i                    INTEGER,
   l_pos                INTEGER,
   l_token_count        INTEGER,
   l_tmp                STRING,
   l_token              STRING

   LET l_pos = 0

   LET m_count = 0
   LET m_tag_count = 0
   LET m_function_count = 0
   LET m_parameter_count = 0
   LET m_return_value_count = 0

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
               LET m_documentation[m_documentation_count].function[m_function_count].name = gt_4gl_function_value(i)
            ELSE
               LET m_documentation[m_documentation_count].function[m_function_count].parameter[m_parameter_count].name = gt_4gl_function_value(i)
            END IF
         END FOR
      END IF
   END WHILE

   LET l_pos = 0

   WHILE l_pos < l_token_count
      LET l_pos = l_pos + 1
      LET l_token = gt_4gl_next_token(l_pos)

      CASE
         WHEN l_token.subString(1, 2) == "##"
            LET l_pos = p_gt_parse_documentation(l_pos)

         #WHEN l_token.touppercase() == "DEFINE"
         #   LET l_pos = gt_4gl_parse_define(l_pos)


         #WHEN l_token.touppercase() == "RETURN"
         #   LET l_pos = gt_4gl_parse_return(l_pos)

         OTHERWISE
      END CASE
   END WHILE

END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

FUNCTION p_gt_parse_documentation(l_pos)

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
   l_command          STRING,
   l_function         STRING,
   l_documentation    STRING,
   l_tokenizer        base.stringtokenizer

   LET l_function = NULL
   LET l_function_count = 0
   LET m_count = m_count + 1
   LET m_tag_count  = 0
   LET m_parameter_count = 0
   LET m_return_value_count = 0

   IF m_count > 1 THEN
      LET l_function = p_gt_find_next_function(l_pos)

      IF l_function IS NOT NULL THEN
         FOR i = 1 TO m_documentation[m_documentation_count].function.getlength()
            IF m_documentation[m_documentation_count].function[i].name = l_function THEN
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
   END IF

   WHILE NOT gt_4gl_is_keyword(l_token)
      #------------------------------------------------------------------------#
      # Documentation comes through as lines                                   #
      #------------------------------------------------------------------------#

      LET l_line = l_token.trim()

      IF l_line.getCharAt(1) != "#" THEN
         EXIT WHILE
      END IF

      LET l_line = l_line.subString(2, l_line.getLength() - 1)
      LET l_line = l_line.trim()

      IF l_line.getlength() == 0 THEN
      END IF

      #------------------------------------------------------------------------#
      # Found a doxygen control character                                      #
      #------------------------------------------------------------------------#

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
               LET m_documentation[m_documentation_count].function[l_function_count].parameter[m_parameter_count].name = l_name
               LET l_text = l_line.subString(l_index, l_line.getLength())
               LET m_documentation[m_documentation_count].function[l_function_count].parameter[m_parameter_count].description = l_text

            WHEN l_command == "@return"
               LET m_return_value_count = m_return_value_count + 1
               LET l_index = l_line.getindexof(" ", 1)
               LET l_name = l_line.subString(1, l_index)
               LET m_documentation[m_documentation_count].function[l_function_count].return_value[m_return_value_count].name = l_name
               LET l_text = l_line.subString(l_index, l_line.getLength())
               LET m_documentation[m_documentation_count].function[l_function_count].return_value[m_return_value_count].description = l_text

            OTHERWISE
               IF m_count == 1 THEN
                  LET m_tag_count = m_tag_count + 1
                  LET m_documentation[m_documentation_count].tag[m_tag_count].name = l_command.subString(2, l_command.getLength())
                  LET m_documentation[m_documentation_count].tag[m_tag_count].value = l_line.trim()
               ELSE
                  LET m_tag_count = m_tag_count + 1
                  LET m_documentation[m_documentation_count].function[l_function_count].tag[m_tag_count].name = l_command.subString(2, l_command.getLength())
                  LET m_documentation[m_documentation_count].function[l_function_count].tag[m_tag_count].value = l_line.trim()
               END IF
         END CASE
      ELSE
         IF m_count == 1 THEN
            LET m_documentation[m_documentation_count].text = m_documentation[m_documentation_count].text, " ", l_line.trim()
         ELSE
            LET m_documentation[m_documentation_count].function[l_function_count].text = m_documentation[m_documentation_count].function[l_function_count].text, " ", l_line.trim()
         END IF
      END IF

      LET l_pos = l_pos + 1
      LET l_token = gt_4gl_next_token(l_pos)
   END WHILE

   RETURN l_pos

END FUNCTION

FUNCTION p_gt_find_next_function(l_pos)

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