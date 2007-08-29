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

FUNCTION lib_md5_test_id()

DEFINE
   l_id   STRING

   WHENEVER ANY ERROR CALL gt_system_error
   LET l_id = "$Id$"

END FUNCTION

##
# Function to test the MD5 library.
# @return l_ok Returns TRUE if successful, FALSE otherwise.
#

FUNCTION test_md5_lib()

DEFINE
   l_count                INTEGER,
   l_encrypted_string     STRING,
   l_unencrypted_string   STRING,
   l_interval             INTERVAL MINUTE TO FRACTION(3),
   l_end_time             DATETIME MINUTE TO FRACTION(3),
   l_start_time           DATETIME MINUTE TO FRACTION(3)

   CALL gt_ut_log("Testing MD5 with \"\"...")

   IF gt_md5string("") == "D41D8CD98F00B204E9800998ECF8427E" THEN
    	CALL gt_ut_log("Passed")
   ELSE
   	CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

	CALL gt_ut_log("Testing MD5 with \"a\"...")

	IF gt_md5string("a") == "0CC175B9C0F1B6A831C399E269772661" THEN
		CALL gt_ut_log("Passed")
	ELSE
		CALL gt_ut_log("FAILED")
		RETURN FALSE
	END IF

 	CALL gt_ut_log("Testing MD5 with \"abc\"...")

 	IF gt_md5string("abc") == "900150983CD24FB0D6963F7D28E17F72" THEN
 		CALL gt_ut_log("Passed")
 	ELSE
 		CALL gt_ut_log("FAILED")
 		RETURN FALSE
 	END IF

 	CALL gt_ut_log("Testing MD5 with \"message digest\"...")

 	IF gt_md5string("message digest") == "F96B697D7CB7938D525A2F31AAF161D0" THEN
 		CALL gt_ut_log("Passed")
 	ELSE
 		CALL gt_ut_log("FAILED")
 		RETURN FALSE
 	END IF

 	CALL gt_ut_log("Testing MD5 with \"abcdefghijklmnopqrstuvwxyz\"...")

 	IF gt_md5string("abcdefghijklmnopqrstuvwxyz") == "C3FCD3D76192E4007DFB496CCA67E13B" THEN
 		CALL gt_ut_log("Passed")
 	ELSE
 		CALL gt_ut_log("FAILED")
 		RETURN FALSE
 	END IF

	CALL gt_ut_log("Testing MD5 with \"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789\"...")

	IF gt_md5string("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789") == "D174AB98D277D9F5A5611C2C9F419D9F" THEN
		CALL gt_ut_log("Passed")
	ELSE
		CALL gt_ut_log("FAILED")
		RETURN FALSE
	END IF

 	CALL gt_ut_log("Testing MD5 with \"12345678901234567890123456789012345678901234567890123456789012345678901234567890\"...")

 	IF gt_md5string("12345678901234567890123456789012345678901234567890123456789012345678901234567890") == "57EDF4A22BE3C955AC49DA2E2107B67A" THEN
 		CALL gt_ut_log("Passed")
 	ELSE
 		CALL gt_ut_log("FAILED")
 		RETURN FALSE
 	END IF

   CALL gt_ut_log("Load testing encryption of MD5 type... (20 iterations)")
   CALL gt_ut_log("Please wait...")

   LET l_count = 0
   LET l_start_time = CURRENT

   WHILE TRUE
      LET l_count = l_count + 1
      LET l_encrypted_string = "F96B697D7CB7938D525A2F31AAF161D0"
      LET l_unencrypted_string = "message digest"

      IF gt_md5string(l_unencrypted_string) != l_encrypted_string THEN
         CALL gt_ut_log(l_count || " - FALSE")
         RETURN FALSE
      END IF

      IF l_count > 20 THEN
         EXIT WHILE
      END IF
   END WHILE

   LET l_end_time = CURRENT
   LET l_interval = l_end_time - l_start_time

   CALL gt_ut_log("Passed")
   CALL gt_ut_log("Iterations took " || l_interval || " seconds")
   CALL gt_ut_log("Time per iteration:" || l_interval / 20 || " seconds")

   RETURN TRUE

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
