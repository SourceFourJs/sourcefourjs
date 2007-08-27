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

#------------------------------------------------------------------------------#
# Function to set WHENEVER ANY ERROR for this module                           #
#------------------------------------------------------------------------------#

FUNCTION lib_getopt_test_id()

DEFINE
   l_id   STRING

   WHENEVER ANY ERROR CALL system_error
   LET l_id = "$Id$"

END FUNCTION

##
# Function to test the get options library.
# @param l_ok Returns TRUE if successful, FALSE otherwise.
#

FUNCTION test_getopt_lib()

   CALL ut_log("Testing find_argument...")

   IF find_argument("no-of-arguments") THEN
      CALL ut_log("Passed")
   ELSE
      CALL ut_log("FAILED")
      RETURN
   END IF

   CALL ut_log("Testing get_argument...")

   IF get_argument("no-of-arguments") == base.application.getargumentcount() THEN
      CALL ut_log("Passed")
   ELSE
      CALL ut_log("FAILED")
      RETURN
   END IF

   RETURN TRUE

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#