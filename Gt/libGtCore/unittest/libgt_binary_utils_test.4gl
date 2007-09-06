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

FUNCTION lib_binary_utils_test_id()

DEFINE
   l_id   STRING

   WHENEVER ANY ERROR CALL gt_system_error
   LET l_id = "$Id$"

END FUNCTION

##
# Function to test the binary utils library.
# @param l_ok Returns TRUE if successful, FALSE otherwise.
#

FUNCTION test_binary_utils_lib()

   CALL gt_ut_log("Testing gt_asc...")

   IF gt_asc("G") == 71 THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_chr...")

   IF gt_chr(71) == "G" THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing of gt_xorstring function is done with the encryption testing...")

   CALL gt_ut_log("Testing gt_hex2dec...")

   IF gt_hex2dec("FF") == 255 THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_dec2hex...")

   IF gt_dec2hex(255) == "FF" THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_num2BCD...")

   IF gt_num2BCD(42) == "*" THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_BCD2num...")

   IF gt_BCD2num("*") == 42 THEN
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
