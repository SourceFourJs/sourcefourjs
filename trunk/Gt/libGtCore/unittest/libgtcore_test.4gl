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
# Test controller module for libgtcore.
# @category System Program
# @author Scott Newton
# @date August 2007
# @version $Id$
#

MAIN

DEFINE
	l_id   STRING

	WHENEVER ANY ERROR CALL system_error
	LET l_id = "$Id$"

   CALL ut_init()

END MAIN

##
# Function which controls the tests for libgtcore.
#

FUNCTION run_tests()

DEFINE
   l_all           SMALLINT,
   i               INTEGER,
   l_smtp_port     INTEGER,
   l_to            STRING,
   l_from          STRING,
   l_smtp_server   STRING

   LET l_all = FALSE

   IF find_argument("all") THEN
      LET l_all = TRUE
   END IF

   IF base.application.getargumentcount() == 0 THEN
      DISPLAY "Argument Count = ", base.application.getargumentcount()
      LET l_all = TRUE
   END IF

   IF l_all OR find_argument("binary") THEN
      CALL ut_log("******* Binary Library *******")

      IF test_binary_lib() THEN
         CALL ut_result("Binary Library", TRUE)
      ELSE
         CALL ut_result("Binary Library", FALSE)
         RETURN
      END IF
   END IF

   IF l_all OR find_argument("binary_utils_test") THEN
      CALL ut_log("******* Binary Utilities Library *******")

      IF test_binary_utils_lib() THEN
         CALL ut_result("Binary Utilities Library", TRUE)
      ELSE
         CALL ut_result("Binary Utilities Library", FALSE)
         RETURN
      END IF
   END IF

   IF l_all OR find_argument("encryption") THEN
      CALL ut_log("******* Encryption Library *******")

      IF test_encryption_lib() THEN
         CALL ut_result("Encryption Library", TRUE)
      ELSE
         CALL ut_result("Encryption_Library", FALSE)
         RETURN
      END IF
   END IF

   IF l_all OR find_argument("exception") THEN
      CALL ut_log("******* Exception Library *******")

      IF test_exception_lib() THEN
         CALL ut_result("Exception Library", TRUE)
      ELSE
         CALL ut_result("Exception Library", FALSE)
         RETURN
      END IF
   END IF

   IF l_all OR find_argument("getopt") THEN
      CALL ut_log("******* Getopt Library *******")

      IF NOT find_argument("no-of-arguments") THEN
         CALL ut_log("--no-of-arguments is required to test getopt")
         RETURN
      END IF

      IF test_getopt_lib() THEN
         CALL ut_result("Getopt Library", TRUE)
      ELSE
         CALL ut_result("Getopt Library", FALSE)
         RETURN
      END IF
   END IF

   IF l_all OR find_argument("md5") THEN
      CALL ut_log("******* MD5 Library *******")

      IF test_md5_lib() THEN
         CALL ut_result("MD5 Library", TRUE)
      ELSE
         CALL ut_result("MD5 Library", FALSE)
         RETURN
      END IF
   END IF

   IF l_all OR find_argument("smtp-client") THEN
      CALL ut_log("******* SMTP Client Library *******")

      IF find_argument("smtp-server") THEN
         LET l_smtp_server = get_argument("smtp-server")
      ELSE
         CALL ut_log("--smtp-server is required to test smtp-client")
         RETURN
      END IF

      IF find_argument("smtp-port") THEN
         LET l_smtp_port = get_argument("smtp-port")
      ELSE
         CALL ut_log("--smtp-port is required to test smtp-client")
         RETURN
      END IF

      IF find_argument("smtp-from") THEN
         LET l_from = get_argument("smtp-from")
      ELSE
         CALL ut_log("--smtp-from is required to test smtp-client")
         RETURN
      END IF

      IF find_argument("smtp-to") THEN
         LET l_to = get_argument("smtp-to")
      ELSE
         CALL ut_log("--smtp-to is required to test smtp-client")
         RETURN
      END IF

      IF test_smtp_client_lib(l_smtp_server, l_smtp_port, l_from, l_to) THEN
         CALL ut_result("SMTP Client Library", TRUE)
      ELSE
         CALL ut_result("SMTP Client Library", FALSE)
         RETURN
      END IF
   END IF

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#