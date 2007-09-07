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

#------------------------------------------------------------------------------#
# Function to set WHENEVER ANY ERROR for this module                           #
#------------------------------------------------------------------------------#

FUNCTION libgt_string_test_id()

DEFINE
   l_id   STRING

   WHENEVER ANY ERROR CALL gt_system_error
   LET l_id = "$Id$"

END FUNCTION

##
# Function to test the get options library.
# @param l_ok Returns TRUE if successful, FALSE otherwise.
#

FUNCTION test_string_lib()

DEFINE
   l_string   STRING

   LET l_string = ""

   CALL gt_ut_log("Testing gt_string_is_empty with empty value...")

   IF gt_string_is_empty(l_string) == TRUE THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   LET l_string = NULL

   CALL gt_ut_log("Testing gt_string_is_empty with NULL value...")

   IF gt_string_is_empty(l_string) == TRUE THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_string_is_integer with integer value...")

   IF gt_string_is_integer("-0123456789") == TRUE THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_string_is_integer with non integer value...")

   IF gt_string_is_integer("012345.6789") == FALSE THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_string_is_alphabetic with alphabetic value...")

   IF gt_string_is_alphabetic("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ") == TRUE THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_string_is_alphabetic with non alphabetic value...")

   IF gt_string_is_alphabetic("012345.6789") == FALSE THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_string_is_alphanumeric with alphanumeric value...")

   IF gt_string_is_alphanumeric("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ") == TRUE THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_string_is_alphanumeric with non alphanumeric value...")

   IF gt_string_is_alphanumeric("012345.6789") == FALSE THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   LET l_string = "These older old bones"

   CALL gt_ut_log("Testing gt_string_find...")

   IF gt_string_find(l_string, "old") == 7 THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_string_rfind...")

   IF gt_string_rfind(l_string, "old") == 13 THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_string_replace with global TRUE...")

   IF gt_string_replace(l_string, "old", "new", TRUE) == "These newer new bones" THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_string_replace with global FALSE...")

   IF gt_string_replace(l_string, "old", "new", FALSE) == "These newer old bones" THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_string_reverse...")

   IF gt_string_reverse("string") == "gnirts" THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   RETURN TRUE

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
