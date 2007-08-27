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
# Get Options Library
# @category System Library
# @author Scott Newton
# @date August 2007
# @version $Id$
#

DEFINE
   m_parsed   SMALLINT,
   m_count    INTEGER,

   m_argument_list DYNAMIC ARRAY OF RECORD
      argument   STRING,
      value      STRING
   END RECORD

#------------------------------------------------------------------------------#
# Function to set WHENEVER ANY ERROR for this module                           #
#------------------------------------------------------------------------------#

FUNCTION lib_getopt_id()

DEFINE
	l_id   STRING

	WHENEVER ANY ERROR CALL system_error
	LET l_id = "$Id$"

END FUNCTION

##
# This function searches for a given argument.
# @param l_argument The argument to search for.
# @return l_exists Returns TRUE if the argument exists, FALSE otherwise.
#

FUNCTION find_argument(l_argument)

DEFINE
   l_argument   STRING

DEFINE
   i         INTEGER,
   l_exists  STRING

   LET l_exists = FALSE

   IF NOT m_parsed THEN
      CALL p_parse_arguments()
   END IF

   IF l_argument.substring(1,2) == "--" THEN
      LET l_argument = l_argument.substring(3,l_argument.getLength())
   END IF

   IF l_argument.substring(1,1) == "-" THEN
      LET l_argument = l_argument.substring(2,l_argument.getLength())
   END IF

   FOR i = 1 TO m_count
      IF m_argument_list[i].argument == l_argument THEN
         LET l_exists = TRUE
         EXIT FOR
      END IF
   END FOR

   RETURN l_exists

END FUNCTION

##
# This function returns the value for the given argument.
# @param l_argument The argument to search for.
# @return l_value Returns the value of the argument if found, NULL otherwise.
#

FUNCTION get_argument(l_argument)

DEFINE
   l_argument   STRING

DEFINE
   i        INTEGER,
   l_value  STRING

   LET l_value = NULL

   IF NOT m_parsed THEN
      CALL p_parse_arguments()
   END IF

   IF l_argument.substring(1,2) == "--" THEN
      LET l_argument = l_argument.substring(3,l_argument.getLength())
   END IF

   IF l_argument.substring(1,1) == "-" THEN
      LET l_argument = l_argument.substring(2,l_argument.getLength())
   END IF

   FOR i = 1 TO m_count
      IF m_argument_list[i].argument == l_argument THEN
         LET l_value = m_argument_list[i].value
         EXIT FOR
      END IF
   END FOR

   RETURN l_value

END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

##
# This function parses the command line arguments.
# @private
#

FUNCTION p_parse_arguments()

DEFINE
   i            INTEGER,
   l_value      STRING,
   l_argument   STRING

   LET m_count = 0

   FOR i = 1 TO base.application.getargumentcount()
      LET l_argument = base.application.getargument(i)

      #------------------------------------------------------------------------#
      # If the argument starts with "-" assume it is an argument flag
      #------------------------------------------------------------------------#

      IF l_argument.substring(1,1) == "-" THEN
         LET m_count = m_count + 1

         IF l_argument.subString(1,2) == "--" THEN
            LET m_argument_list[m_count].argument = l_argument.subString(3,l_argument.getLength())
         ELSE
            LET m_argument_list[m_count].argument = l_argument.subString(2,l_argument.getLength())
         END IF

         LET l_value = base.application.getargument(i + 1)

         IF l_value.substring(1,1) == "-" THEN
            LET m_argument_list[m_count].value = TRUE
         ELSE
            LET m_argument_list[m_count].value = l_value
            LET i = i + 1
         END IF
      ELSE
         CALL set_error("ERROR", SFMT(%"Unknown argument found %1", l_argument))
      END IF
   END FOR

   LET m_parsed = TRUE

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
