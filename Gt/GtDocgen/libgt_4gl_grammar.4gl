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
   m_function   DYNAMIC ARRAY OF STRING,

   m_define     DYNAMIC ARRAY OF RECORD
      name   STRING,
      type   STRING
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
      OR   l_char == "_" THEN
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

   IF l_token == "BYTE"
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
   OR l_token == "REAL"
   OR l_token == "SMALLFLOAT"
   OR l_token == "SMALLINT"
   OR l_token == "STRING"
   OR l_token == "TEXT"
   OR l_token == "VARCHAR" THEN
      LET l_ok = TRUE
   END IF

   RETURN l_ok

END FUNCTION

##
# This function returns whether the given token is a 4gl keyword or not.
# @param l_token The token to check.
# @return l_ok TRUE if the token is a 4gl keyword, FALSE otherwise
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
# @return l_value The value of the m_function array at the given position.
#

FUNCTION gt_4gl_function_value(l_count)

DEFINE
   l_count   INTEGER

   RETURN m_function[l_count]

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
      LET m_function[l_count] = gt_4gl_next_token(l_pos)

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
            LET m_function[l_count] = l_token
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

FUNCTION gt_4gl_define_count()

   RETURN m_define.getlength()

END FUNCTION

##
# This function returns the value of the m_define array for the given position.
# @param l_count The position to get the value for.
# @return l_value The value of the m_define array at the given position.
#

FUNCTION gt_4gl_define_value(l_count)

DEFINE
   l_count   INTEGER

   RETURN m_define[l_count].name, m_define[l_count].type

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
   i         INTEGER,
   l_count   INTEGER,
   l_save    INTEGER,
   l_token   STRING

   LET l_save = 0
   LET l_count = 0
   LET l_pos = l_pos + 1
   LET l_token = gt_4gl_next_token(l_pos)

   WHILE NOT gt_4gl_is_keyword(l_token)

      LET l_count = l_count + 1
      LET m_define[l_count].name = l_token

      LET l_pos = l_pos + 1
      LET l_token = gt_4gl_next_token(l_pos)

      IF l_token == "," THEN
         IF l_save == 0 THEN
            LET l_save = l_count
         END IF

         LET l_pos = l_pos + 1
         LET l_token = gt_4gl_next_token(l_pos)
         CONTINUE WHILE
      END IF

      IF gt_4gl_is_datatype(l_token) THEN
         IF l_save > 0 THEN
            FOR i = l_save TO l_count
               LET m_define[i].type = l_token
            END FOR

            LET l_save = 0
         ELSE
            LET m_define[l_count].type = l_token
         END IF
      END IF

      IF l_token.touppercase() == "ARRAY"
      OR l_token.touppercase() == "DYNAMIC" THEN
         LET l_pos = gt_4gl_parse_array(l_pos)
      END IF

      IF l_token.touppercase() == "RECORD" THEN
         LET l_pos = gt_4gl_parse_record(l_pos)
      END IF

      LET l_pos = l_pos + 1
      LET l_token = gt_4gl_next_token(l_pos)
   END WHILE

   RETURN l_pos

END FUNCTION

##
# This function parses the ARRAY statement.
# @param l_pos The position in the token array to start from.
# @return l_pos The position in the token array once parsing is complete.
#
FUNCTION gt_4gl_parse_array(l_pos)

DEFINE
   l_pos   INTEGER

DEFINE
   l_type        STRING,
   l_token       STRING,
   l_dimension   STRING

   LET l_token = gt_4gl_next_token(l_pos)

   IF l_token.touppercase() == "DYNAMIC" THEN
      LET l_pos = l_pos + 1
      LET l_token = gt_4gl_next_token(l_pos)

      IF l_token.touppercase() != "ARRAY" THEN
         RETURN l_pos
      END IF

      LET l_pos = l_pos + 1
      LET l_token = gt_4gl_next_token(l_pos)

      IF l_token.touppercase() != "OF" THEN
         RETURN l_pos
      END IF

      LET l_pos = l_pos + 1
      LET l_token = gt_4gl_next_token(l_pos)
   ELSE
      LET l_pos = l_pos + 1
      LET l_token = gt_4gl_next_token(l_pos)

      IF l_token.touppercase() != "OF" THEN
         RETURN l_pos
      END IF

      LET l_pos = l_pos + 1
      LET l_token = gt_4gl_next_token(l_pos)
   END IF

   IF l_token == "WITH" THEN
      LET l_pos = l_pos + 1
      LET l_token = gt_4gl_next_token(l_pos)

      IF l_token.touppercase() != "DIMENSION" THEN
         RETURN l_pos
      END IF

      LET l_pos = l_pos + 1
      LET l_token = gt_4gl_next_token(l_pos)
      LET l_dimension = l_token

      LET l_pos = l_pos + 1
      LET l_token = gt_4gl_next_token(l_pos)

      IF l_token.touppercase() != "OF" THEN
         RETURN l_pos
      END IF

      LET l_pos = l_pos + 1
      LET l_token = gt_4gl_next_token(l_pos)
   END IF

   IF l_token.touppercase() == "RECORD" THEN
      LET l_pos = gt_4gl_parse_record(l_pos)
   ELSE
      LET l_pos = gt_4gl_parse_define(l_pos)
   END IF

   RETURN l_pos

END FUNCTION

##
# This function parses the RECORD statement.
# @param l_pos The position in the token array to start from.
# @return l_pos The position in the token array once parsing is complete.
#

FUNCTION gt_4gl_parse_record(l_pos)

DEFINE
   l_pos   INTEGER

DEFINE
   l_token   STRING

   LET l_pos = l_pos + 1
   LET l_token = gt_4gl_next_token(l_pos)

   IF l_token.touppercase() == "LIKE" THEN
   ELSE
      LET l_pos = gt_4gl_parse_define(l_pos)
   END IF

   RETURN l_pos

END FUNCTION

##
# This function parses the RETURN statement.
# @param l_pos The position in the token array to start from.
# @return l_pos The position in the token array once parsing is complete.
#

FUNCTION gt_4gl_parse_return(l_pos)

DEFINE
   l_pos   INTEGER

   RETURN l_pos + 1

END FUNCTION

##
# This function parses the RETURNING statement.
# @param l_pos The position in the token array to start from.
# @return l_pos The position in the token array once parsing is complete.
#

FUNCTION gt_4gl_parse_returning(l_pos)

DEFINE
   l_pos   INTEGER

   RETURN l_pos + 1

END FUNCTION

##
# This function parses the SELECT statement.
# @param l_pos The position in the token array to start from.
# @return l_pos The position in the token array once parsing is complete.
#

FUNCTION gt_4gl_parse_select()
END FUNCTION

##
# This function parses the INSERT statement.
# @param l_pos The position in the token array to start from.
# @return l_pos The position in the token array once parsing is complete.
#

FUNCTION gt_4gl_parse_insert()
END FUNCTION

##
# This function parses the UPDATE statement.
# @param l_pos The position in the token array to start from.
# @return l_pos The position in the token array once parsing is complete.
#

FUNCTION gt_4gl_parse_update()
END FUNCTION

##
# This function parses the DELETE statement.
# @param l_pos The position in the token array to start from.
# @return l_pos The position in the token array once parsing is complete.
#

FUNCTION gt_4gl_parse_delete()
END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
