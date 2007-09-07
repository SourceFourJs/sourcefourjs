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

FUNCTION libgt_email_test_id()

DEFINE
   l_id   STRING

   WHENEVER ANY ERROR CALL gt_system_error
   LET l_id = "$Id$"

END FUNCTION

##
# Function to test the email library.
# @param l_ok Returns TRUE if successful, FALSE otherwise.
#

FUNCTION test_email_lib(l_smtp_server, l_smtp_port)

DEFINE
   l_smtp_server   STRING,
   l_smtp_port     INTEGER

DEFINE
   l_cc         STRING,
   l_to         STRING,
   l_bcc        STRING,
   l_from       STRING,
   l_body       STRING,
   l_subject    STRING,
   l_emailhdl   STRING

   LET l_from = "me@example.com"
   LET l_to = "you@example.com"
   LET l_cc = "cc@example.com"
   LET l_bcc = "bcc@example.com"
   LET l_subject = "libgt_email_test subject (notification + with_attachment)"
   LET l_body = "libgt_email_test body"

   CALL gt_ut_log("Testing gt_set_smtp_server...")
   CALL gt_set_smtp_server(l_smtp_server)
   CALL gt_ut_log("Passed")

   CALL gt_ut_log("Testing gt_set_smtp_port...")
   CALL gt_set_smtp_port(l_smtp_port)
   CALL gt_ut_log("Passed")

   CALL gt_ut_log("Testing gt_create_email...")

   CALL gt_create_email()
      RETURNING l_emailhdl

   IF l_emailhdl IS NOT NULL THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_set_email_from_address...")

   IF gt_set_email_from_address(l_emailhdl, l_from) THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_set_email_to_address...")

   IF gt_set_email_to_address(l_emailhdl, l_to) THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_set_email_cc_address...")

   IF gt_set_email_cc_address(l_emailhdl, l_cc) THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_set_email_bcc_address...")

   IF gt_set_email_bcc_address(l_emailhdl, l_bcc) THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_set_email_subject...")

   IF gt_set_email_subject(l_emailhdl, "libgt_email_test email (body as text)") THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_set_email_body...")

   IF gt_set_email_body(l_emailhdl, "libgt_email_test body") THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_send_email...")

   IF gt_send_email(l_emailhdl) THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_create_email...")

   CALL gt_create_email()
      RETURNING l_emailhdl

   IF l_emailhdl IS NOT NULL THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_set_email_from_address...")

   IF gt_set_email_from_address(l_emailhdl, l_from) THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_set_email_to_address...")

   IF gt_set_email_to_address(l_emailhdl, l_to) THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_set_email_cc_address...")

   IF gt_set_email_cc_address(l_emailhdl, l_cc) THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_set_email_bcc_address...")

   IF gt_set_email_bcc_address(l_emailhdl, l_bcc) THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_set_email_subject...")

   IF gt_set_email_subject(l_emailhdl, "libgt_email_test email (body from file)") THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_set_email_body_from_file...")

   IF gt_set_email_body_from_file(l_emailhdl, "libgt_email_test_template.txt") THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_send_email...")

   IF gt_send_email(l_emailhdl) THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_create_email...")

   CALL gt_create_email()
      RETURNING l_emailhdl

   IF l_emailhdl IS NOT NULL THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_set_email_from_address...")

   IF gt_set_email_from_address(l_emailhdl, l_from) THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_set_email_to_address...")

   IF gt_set_email_to_address(l_emailhdl, l_to) THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_set_email_cc_address...")

   IF gt_set_email_cc_address(l_emailhdl, l_cc) THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_set_email_bcc_address...")

   IF gt_set_email_bcc_address(l_emailhdl, l_bcc) THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_set_email_subject...")

   IF gt_set_email_subject(l_emailhdl, "libgt_email_test email (with attachments)") THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_set_email_body...")

   IF gt_set_email_body(l_emailhdl, "libgt_email_test body") THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_set_email_attachment...")

   IF gt_set_email_attachment(l_emailhdl, "libgt_email_test_template.txt") THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_send_email...")

   IF gt_send_email(l_emailhdl) THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_send_email_notification...")

   IF gt_send_email_notification(l_from, l_to, l_cc, l_bcc, l_subject, l_body) THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_send_email_with_attachment...")

   IF gt_send_email_with_attachment(l_from, l_to, l_cc, l_bcc, l_subject, l_body, "libgt_email_test_template.txt") THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_mail_merge...")

   IF gt_mail_merge("libgt_email_test_csv.txt", "libgt_email_test_template.txt") THEN
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
