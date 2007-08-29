# $Id$
#------------------------------------------------------------------------------#
# Copyright (c) 2007 Scott Newton <scottn@ihug.co.nz>                          #
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
# 4GL Parser Library
# @category System Library
# @author Scott Newton
# @date August 2007
# @version $Id$
#

DEFINE
   m_line_length   INTEGER,
   m_token_count   INTEGER,
   m_line          STRING,
   m_tokens        DYNAMIC ARRAY OF STRING

#------------------------------------------------------------------------------#
# Function to set the WHENEVER ANY ERROR function for this module              #
#------------------------------------------------------------------------------#

FUNCTION lib_4gl_parser_id()

DEFINE
   l_id   STRING

   WHENEVER ANY ERROR CALL gt_system_error
   LET l_id = "$Id$"

END FUNCTION

##
# Function to clear the token array.
#

FUNCTION gt_4gl_parser_init()

   CALL m_tokens.clear()
   LET m_token_count = 0

END FUNCTION

##
# Function to parse the given file. This would be the normal entry point into
# this function.
# @param l_filename The name of the file to parse.
# @param l_include_comments TRUE if comments are to be included in the token
#                           array, FALSE otherwise.
#

FUNCTION gt_parse_file(l_filename, l_include_comments)

DEFINE
   l_filename           STRING,
   l_include_comments   SMALLINT

DEFINE
   l_ok             SMALLINT,
   l_tmp            STRING,
   l_filehdl        STRING,
   l_exceptionhdl   STRING,
   l_line           base.StringBuffer

   LET m_line_length = 0
   LET l_line = base.StringBuffer.create()

   CALL file_open(l_filename, "r", "")
      RETURNING l_ok, l_filehdl, l_exceptionhdl

   IF l_ok THEN
      WHILE file_read(l_filehdl)
         LET l_tmp = get_io_buffer(l_filehdl)
         CALL l_line.append(l_tmp)
         CALL l_line.append("\n")
         LET m_line_length = m_line_length + l_tmp.getLength() + 1
      END WHILE

      CALL file_close(l_filehdl)
         RETURNING l_ok, l_exceptionhdl

      LET m_line = l_line.toString()

      IF m_line.getLength() < 0 THEN
         DISPLAY "File too long"
         EXIT PROGRAM
      END IF
      CALL p_gt_get_tokens(l_include_comments)
   END IF


END FUNCTION

##
# Function to return the parsed token count.
# @return m_token_count The number of parsed tokens.
#

FUNCTION gt_get_token_count()

   RETURN m_token_count

END FUNCTION

##
# Function to return the next token at the given position.
# @param l_pos The token position.
# @return m_tokens[l_pos] The token at the given position.
#

FUNCTION gt_get_next_token(l_pos)

DEFINE
   l_pos   INTEGER

   IF l_pos > 0 THEN
      RETURN m_tokens[l_pos]
   ELSE
      RETURN ""
   END IF

END FUNCTION

##
# Function to return the next alphanumeric token starting from the given
# postion.
# @param l_pos The position to start from.
# @return l_pos The position of the next alphanumeric token.
# @return l_token The next alphanumeric token.
#

FUNCTION gt_get_next_alphanumeric_token(l_pos)

DEFINE
   l_pos     INTEGER,
   l_token   STRING

   LET l_token = NULL

   WHILE l_pos <= m_token_count
      IF is_string_alphanumeric(m_tokens[l_pos]) THEN
         LET l_token = m_tokens[l_pos]
         EXIT WHILE
      ELSE
         LET l_pos = l_pos + 1
      END IF
   END WHILE

   RETURN l_pos, l_token

END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

##
# Function to parse the file until either the given character or the end of the
# file is found.
# @param i The position to start at.
# @param l_char The character to search for.
# @return i The position the given character was found in.
#

FUNCTION p_gt_wait_for(i, l_char)

DEFINE
   i        INTEGER,
   l_char   STRING

   WHILE i < m_line_length
     AND m_line.getCharAt(i) != l_char
      LET i = i + 1
   END WHILE

   RETURN i

END FUNCTION

##
# Function to parse the contents into tokens.
# @param l_include_comments TRUE if comments are to be included in the parsed
#                           token array, FALSE otherwise.
#

FUNCTION p_gt_get_tokens(l_include_comments)

DEFINE
   l_include_comments   SMALLINT

DEFINE
   i        INTEGER,
   j        INTEGER,
   l_char   CHAR(1),
   l_token   base.StringBuffer

   LET i = 1
   LET m_token_count = 0
   LET l_token = base.StringBuffer.create()

   WHILE i <= m_line_length
      LET l_char = m_line.getCharAt(i)

      IF l_char == "{" THEN
         LET j = p_gt_wait_for(i, "}")
         IF l_include_comments THEN
            LET m_token_count = m_token_count + 1
            LET m_tokens[m_token_count] = m_line.subString(i, j)
         END IF
         LET i = j + 1
         CONTINUE WHILE
      END IF

      IF l_char == "#" THEN
         LET j = p_gt_wait_for(i, "\n")
         IF l_include_comments THEN
            LET m_token_count = m_token_count + 1
            LET m_tokens[m_token_count] = m_line.subString(i, j)
         END IF
         LET i = j + 1
         CONTINUE WHILE
      END IF

      IF l_char == "-" THEN
         IF m_line.getCharAt(i + 1) == "-" THEN
            LET j = p_gt_wait_for(i, "\n")
            IF l_include_comments THEN
               LET m_token_count = m_token_count + 1
               LET m_tokens[m_token_count] = m_line.subString(i, j)
            END IF
            LET i = j + 1
            CONTINUE WHILE
         END IF
      END IF

      CASE
         WHEN l_char == " "
           OR l_char == ASCII(10)
           OR l_char == ASCII(13)
            IF l_token.getLength() > 0 THEN
               LET m_token_count = m_token_count + 1
               LET m_tokens[m_token_count] = l_token.toString()
            END IF

            CALL l_token.clear()

         WHEN ((l_char >= "0"
          AND   l_char <= "9")
           OR  (l_char >= "a"
          AND   l_char <= "z")
           OR  (l_char >= "A"
          AND   l_char <= "Z")
           OR  (l_char == "_"))
            CALL l_token.append(l_char)

         OTHERWISE
            IF l_token.getLength() > 0 THEN
               LET m_token_count = m_token_count + 1
               LET m_tokens[m_token_count] = l_token.toString()
            END IF

            LET m_token_count = m_token_count + 1
            LET m_tokens[m_token_count] = l_char
            CALL l_token.clear()
      END CASE

      LET i = i + 1
   END WHILE

   LET m_line = ""

   #LET i = 1
   #WHILE i <= m_token_count
   #   DISPLAY m_tokens[i]
   #   LET i = i + 1
   #END WHILE

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#