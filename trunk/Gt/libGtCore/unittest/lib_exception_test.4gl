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

FUNCTION lib_exception_test_id()

DEFINE
   l_id   STRING

   WHENEVER ANY ERROR CALL system_error
   LET l_id = "$Id$"

END FUNCTION

##
# Function to test the exception library.
# @param l_ok Returns TRUE if successful, FALSE otherwise.
#

FUNCTION test_exception_lib()

DEFINE
   l_ok   SMALLINT

   LET l_ok = FALSE

   CALL ut_log("Populating exception list...")

   CALL set_message("INFORMATIONAL", "First Message")
   CALL set_warning("WARNING", "First Warning")
   CALL set_error("ERROR", "First Error")

   CALL set_message("INFORMATIONAL", "Second Message")
   CALL set_warning("WARNING", "Second Warning")
   CALL set_error("ERROR", "Second Error")

   CALL set_message("INFORMATIONAL", "Third Message")
   CALL set_warning("WARNING", "Third Warning")
   CALL set_error("ERROR", "Third Error")

   CALL ut_log("Testing get_exception_count...")

   IF get_exception_count() == 9 THEN
      CALL ut_log("Passed")
   ELSE
      CALL ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL ut_log("Testing get_error_count...")

   IF get_error_count() == 3 THEN
      CALL ut_log("Passed")
   ELSE
      CALL ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL ut_log("Testing get_warning_count...")

   IF get_warning_count() == 3 THEN
      CALL ut_log("Passed")
   ELSE
      CALL ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL ut_log("Testing get_message_count...")

   IF get_message_count() == 3 THEN
      CALL ut_log("Passed")
   ELSE
      CALL ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL ut_log("Testing get_last_message...")

   IF get_last_message() == "Third Message" THEN
      CALL ut_log("Passed")
   ELSE
      CALL ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL ut_log("Testing get_last_warning...")

   IF get_last_warning() == "Third Warning" THEN
      CALL ut_log("Passed")
   ELSE
      CALL ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL ut_log("Testing get_last_error...")

   IF get_last_error() == "Third Error" THEN
      CALL ut_log("Passed")
   ELSE
      CALL ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL ut_log("Testing get_exception...")

   IF get_exception(5) == "Second Warning" THEN
      CALL ut_log("Passed")
   ELSE
      CALL ut_log("FAILED")
      RETURN FALSE
   END IF

   RETURN TRUE

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#