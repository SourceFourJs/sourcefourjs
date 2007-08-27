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

DEFINE
    m_count   INTEGER,

    m_unittest DYNAMIC ARRAY OF RECORD
        module   STRING,
        name     STRING,
        result   STRING
    END RECORD

#------------------------------------------------------------------------------#
# Function to set WHENEVER ANY ERROR for this module                           #
#------------------------------------------------------------------------------#

FUNCTION lib_smtp_client_test_id()

DEFINE
   l_id   STRING

   WHENEVER ANY ERROR CALL system_error
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
   l_serverhdl      base.channel

   CALL ut_log("Testing smtp_client_init...")
   CALL smtp_client_init()

   CALL ut_log("Testing connect_to_smtp_server...")

   CALL connect_to_smtp_server(l_smtp_server, l_smtp_port)
      RETURNING l_ok, l_serverhdl

   IF l_ok THEN
      CALL ut_log("Passed")
   ELSE
      CALL ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL ut_log("Testing smtp_helo...")

   CALL smtp_helo(l_serverhdl, l_smtp_server)
      RETURNING l_ok

   IF l_ok THEN
      CALL ut_log("Passed")
   ELSE
      CALL ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL ut_log("Testing smtp_mail_from...")

   CALL smtp_mail_from(l_serverhdl, l_from)
      RETURNING l_ok

   IF l_ok THEN
      CALL ut_log("Passed")
   ELSE
      CALL ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL ut_log("Testing smtp_rcpt_to...")

   CALL smtp_rcpt_to(l_serverhdl, l_to)
      RETURNING l_ok

   IF l_ok THEN
      CALL ut_log("Passed")
   ELSE
      CALL ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL ut_log("Testing smtp_data...")

   LET l_email = "Subject: Test from lib_smtp_client_test\n\nThis is a test message."

   CALL smtp_data(l_serverhdl, l_email)
      RETURNING l_ok

   IF l_ok THEN
      CALL ut_log("Passed")
   ELSE
      CALL ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL ut_log("Testing smtp_quit...")

   CALL smtp_quit(l_serverhdl)
      RETURNING l_ok

   IF l_ok THEN
      CALL ut_log("Passed")
   ELSE
      CALL ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL ut_log("Testing get_smtp_client_statistics...")

   CALL get_smtp_client_statistics()
      RETURNING l_connections, l_bytesread, l_byteswritten

   CALL ut_log("SMTP Client Statistics:")
   CALL ut_log("No of Connections   : " || l_connections)
   CALL ut_log("Total Bytes Read    : " || l_bytesread)
   CALL ut_log("Total Bytes Written : " || l_byteswritten)

   RETURN TRUE

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#