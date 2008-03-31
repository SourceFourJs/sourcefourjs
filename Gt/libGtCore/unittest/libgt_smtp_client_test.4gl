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

FUNCTION libgt_smtp_client_test_id()

DEFINE
   l_id   STRING

   WHENEVER ANY ERROR CALL gt_system_error
   LET l_id = "$Id$"

END FUNCTION

##
# Function to test the SMTP client library.
# @return l_ok Returns TRUE if successful, FALSE otherwise.
#

FUNCTION test_smtp_client_lib(l_smtp_server, l_smtp_port, l_from, l_to)

DEFINE
   l_smtp_server   STRING,
   l_smtp_port     INTEGER,
   l_from          STRING,
   l_to            STRING

DEFINE
   l_ok             SMALLINT,
   l_connections    STRING,
   l_bytesread      STRING,
   l_byteswritten   STRING,
   l_email          STRING,
   l_serverhdl      STRING

   CALL gt_ut_log("Testing gt_smtp_client_init...")
   CALL gt_smtp_client_init()

   CALL gt_ut_log("Testing gt_connect_to_smtp_server...")

   CALL gt_connect_to_smtp_server(l_smtp_server, l_smtp_port)
      RETURNING l_ok, l_serverhdl

   IF l_ok THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_smtp_helo...")

   CALL gt_smtp_helo(l_serverhdl, l_smtp_server)
      RETURNING l_ok

   IF l_ok THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_smtp_mail_from...")

   CALL gt_smtp_mail_from(l_serverhdl, l_from)
      RETURNING l_ok

   IF l_ok THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_smtp_rcpt_to...")

   CALL gt_smtp_rcpt_to(l_serverhdl, l_to)
      RETURNING l_ok

   IF l_ok THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_smtp_data...")

   LET l_email = "Subject: Test from lib_smtp_client_test\n\nThis is a test message."

   CALL gt_smtp_data(l_serverhdl, l_email)
      RETURNING l_ok

   IF l_ok THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_smtp_quit...")

   CALL gt_smtp_quit(l_serverhdl)
      RETURNING l_ok

   IF l_ok THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_smtp_client_statistics...")

   CALL gt_smtp_client_statistics()
      RETURNING l_connections, l_bytesread, l_byteswritten

   CALL gt_ut_log("SMTP Client Statistics:")
   CALL gt_ut_log("No of Connections   : " || l_connections)
   CALL gt_ut_log("Total Bytes Read    : " || l_bytesread)
   CALL gt_ut_log("Total Bytes Written : " || l_byteswritten)

   RETURN TRUE

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
