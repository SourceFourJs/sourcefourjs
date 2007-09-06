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

##
# Emailing Library
#
# This library provides the functionality to create and send emails.
#
# @category System Program
# @author Scott Newton
# @date August 2007
# @version $Id$
#

IMPORT os

DEFINE
   m_smtp_port     INTEGER,
   m_email_count   INTEGER,
	m_smtp_server   STRING,

   m_email_list DYNAMIC ARRAY OF RECORD
      handle        STRING,
      from          STRING,
      to            STRING,
      cc            STRING,
      bcc           STRING,
      subject       STRING,
      body          STRING,
      attachment_list   DYNAMIC ARRAY OF RECORD
         name   STRING,
         data   STRING
      END RECORD
   END RECORD

#------------------------------------------------------------------------------#
# Function to set WHENEVER ANY ERROR for this module                           #
#------------------------------------------------------------------------------#

FUNCTION lib_email_id()

DEFINE
	l_id   STRING

	WHENEVER ANY ERROR CALL gt_system_error
	LET l_id = "$Id$"

END FUNCTION

##
# Function to set the SMTP server.
# @param l_smtp_server The SMTP server to use.
#

FUNCTION gt_set_smtp_server(l_smtp_server)

DEFINE
   l_smtp_server   STRING

   LET m_smtp_server = l_smtp_server.trim()

END FUNCTION

##
# Function to set the SMTP server port.
# @param l_smtp_port The SMTP server port to use.
#

FUNCTION gt_set_smtp_port(l_smtp_port)

DEFINE
   l_smtp_port   INTEGER

   LET m_smtp_port = l_smtp_port

END FUNCTION

##
# Function to create a new email.
# @return l_emailhdl The handle to the new email.
#

FUNCTION gt_create_email()

   LET m_email_count = m_email_count + 1
   LET m_email_list[m_email_count].handle = NULL
   LET m_email_list[m_email_count].from = ""
   LET m_email_list[m_email_count].to = ''
   LET m_email_list[m_email_count].cc = ""
   LET m_email_list[m_email_count].bcc = ""
   LET m_email_list[m_email_count].subject = ""
   LET m_email_list[m_email_count].body = ""
   CALL m_email_list[m_email_count].attachment_list.clear()

   RETURN m_email_list[m_email_count].handle

END FUNCTION

##
# Function to set the email's from address.
# @param l_emailhdl The emails handle.
# @param l_from The from address for the email.
#

FUNCTION gt_set_email_from_address(l_emailhdl, l_from)

DEFINE
   l_emailhdl   STRING,
   l_from       STRING

DEFINE
   l_ok    SMALLINT,
   i       INTEGER,
   l_pos   INTEGER

   LET l_ok = FALSE
   LET l_pos = p_gt_find_email(l_emailhdl)

   IF l_pos > 0 THEN
      LET m_email_list[l_pos].from = l_from.trim()
      LET l_ok = TRUE
   END IF

   RETURN l_ok

END FUNCTION

##
# Function to set the email's to address.
# @param l_emailhdl The emails handle.
# @param l_to The to address for the email.
#

FUNCTION gt_set_email_to_address(l_emailhdl, l_to)

DEFINE
   l_emailhdl   STRING,
   l_to         STRING

DEFINE
   l_ok    SMALLINT,
   i       INTEGER,
   l_pos   INTEGER

   LET l_ok = FALSE
   LET l_pos = p_gt_find_email(l_emailhdl)

   IF l_pos > 0 THEN
      IF m_email_list[l_pos].to.getLength() == 0 THEN
         LET m_email_list[l_pos].to = l_to.trim()
      ELSE
         LET m_email_list[l_pos].to = m_email_list[l_pos].to, ";", l_to.trim()
      END IF

      LET l_ok = TRUE
   END IF

   RETURN l_ok

END FUNCTION

##
# Function to set the email's cc address.
# @param l_emailhdl The emails handle.
# @param l_cc The cc address for the email.
#

FUNCTION gt_set_email_cc_address(l_emailhdl, l_cc)

DEFINE
   l_emailhdl   STRING,
   l_cc         STRING

DEFINE
   l_ok    SMALLINT,
   i       INTEGER,
   l_pos   INTEGER

   LET l_ok = FALSE
   LET l_pos = p_gt_find_email(l_emailhdl)

   IF l_pos > 0 THEN
      IF m_email_list[l_pos].cc.getLength() == 0 THEN
         LET m_email_list[l_pos].cc = l_cc.trim()
      ELSE
         LET m_email_list[l_pos].cc = m_email_list[l_pos].cc, ";", l_cc.trim()
      END IF

      LET l_ok = TRUE
   END IF

   RETURN l_ok

END FUNCTION

##
# Function to set the email's bcc address.
# @param l_emailhdl The emails handle.
# @param l_bcc The bcc address for the email.
#

FUNCTION gt_set_email_bcc_address(l_emailhdl, l_bcc)

DEFINE
   l_emailhdl   STRING,
   l_bcc        STRING

DEFINE
   l_ok    SMALLINT,
   i       INTEGER,
   l_pos   INTEGER

   LET l_ok = FALSE
   LET l_pos = p_gt_find_email(l_emailhdl)

   IF l_pos > 0 THEN
      IF m_email_list[l_pos].bcc.getLength() == 0 THEN
         LET m_email_list[l_pos].bcc = l_bcc.trim()
      ELSE
         LET m_email_list[l_pos].bcc = m_email_list[l_pos].bcc, ";", l_bcc.trim()
      END IF

      LET l_ok = TRUE
   END IF

   RETURN l_ok

END FUNCTION

##
# Function to set the email's subject.
# @param l_emailhdl The emails handle.
# @param l_subject The subject for the email.
#

FUNCTION gt_set_email_subject(l_emailhdl, l_subject)

DEFINE
   l_emailhdl   STRING,
   l_subject    STRING

DEFINE
   l_ok    SMALLINT,
   i       INTEGER,
   l_pos   INTEGER

   LET l_ok = FALSE
   LET l_pos = p_gt_find_email(l_emailhdl)

   IF l_pos > 0 THEN
      LET m_email_list[l_pos].subject = l_subject.trim()
      LET l_ok = TRUE
   END IF

   RETURN l_ok

END FUNCTION

##
# Function to set the email's body.
# @param l_emailhdl The emails handle.
# @param l_subject The body for the email.
#

FUNCTION gt_set_email_body(l_emailhdl, l_body)

DEFINE
   l_emailhdl   STRING,
   l_body       STRING

DEFINE
   l_ok    SMALLINT,
   i       INTEGER,
   l_pos   INTEGER

   LET l_ok = FALSE
   LET l_pos = p_gt_find_email(l_emailhdl)

   IF l_pos > 0 THEN
      LET m_email_list[l_pos].body = l_body.trim()
      LET l_ok = TRUE
   END IF

   RETURN l_ok

END FUNCTION

##
# Function to set the email's body from a file.
# @param l_emailhdl The emails handle.
# @param l_file The file to use for the body of the email.
#

FUNCTION gt_set_email_body_from_file(l_emailhdl, l_file)

DEFINE
   l_emailhdl   STRING,
   l_file       STRING

DEFINE
   l_ok        SMALLINT,
   i           INTEGER,
   l_pos       INTEGER,
   l_body      STRING,
   l_filehdl   STRING

   LET l_ok = FALSE
   LET l_pos = p_gt_find_email(l_emailhdl)

   IF l_pos > 0 THEN
      IF gt_file_exists(l_file) THEN
         CALL gt_file_open(l_file, "r", "")
            RETURNING l_ok, l_filehdl

         IF l_ok THEN
            WHILE gt_file_read(l_filehdl)
            END WHILE
         ELSE
            CALL set_error(SFMT(%"Unable to open file %1", l_file))
            LET l_ok = FALSE
         END IF
      ELSE
         CALL set_error(SFMT(%"The file %1 does not exist", l_file))
         LET l_ok = FALSE
      END IF

      IF l_ok THEN
         LET l_body = "" # TODO
         LET m_email_list[l_pos].body = l_body.trim()
         LET l_ok = TRUE
      ELSE
      END IF
   END IF

   RETURN l_ok

END FUNCTION

##
# Function to add an attachment to the email.
# @param l_emailhdl The emails handle.
# @param l_attachment The attachment for the email.
#

FUNCTION gt_set_email_attachment(l_emailhdl, l_attachment)

DEFINE
   l_emailhdl     STRING,
   l_attachment   STRING

DEFINE
   l_ok    SMALLINT,
   i       INTEGER,
   l_pos   INTEGER

   LET l_ok = FALSE
   LET l_pos = p_gt_find_email(l_emailhdl)

   IF l_pos > 0 THEN
      #LET m_email_list[l_pos].attachment = l_attachment.trim()
      LET l_ok = TRUE
   END IF

   RETURN l_ok

END FUNCTION

##
# Function to send the given email.
# @param l_emailhdl The handle to the email to send.
# @return l_ok Returns TRUE is the email was successfully sent, FALSE otherwise.
#

FUNCTION gt_send_email(l_emailhdl)

DEFINE
   l_emailhdl   STRING

DEFINE
   l_ok    SMALLINT,
   i       INTEGER,
   l_pos   INTEGER

   LET l_ok = FALSE
   LET l_pos = p_gt_find_email(l_emailhdl)

   IF l_pos > 0 THEN
      IF dispatch_email(l_pos) THEN
         LET l_ok = TRUE
      ELSE
         LET l_ok = FALSE
      END IF
   END IF

   RETURN l_ok

END FUNCTION

##
# Function to send all the emails in the email list.
# @return l_ok Returns TRUE is the emails were successfully sent, FALSE otherwise.
#

FUNCTION gt_send_all_emails()

DEFINE
   l_ok   SMALLINT,
   i      INTEGER

   LET l_ok = FALSE

   IF dispatch_email(0) THEN
      LET l_ok = TRUE
   END IF

   RETURN l_ok

END FUNCTION

##
# Function to send an email notification. This is for when you do not want the
# overhead of setting up a full email.
# @param l_from The from address for the email.
# @param l_to The to address(es) for the email.
# @param l_cc The cc address(es) for the email.
# @param l_bcc The bcc address(es) for the email.
# @param l_subject The subject for the email.
# @param l_body The body for the email.
# @return l_ok Returns TRUE if the email was successfully sent, FALSE otherwise.
#

FUNCTION gt_send_email_notification(l_from, l_to, l_cc, l_bcc, l_subject, l_body)

DEFINE
   l_from      STRING,
   l_to        STRING,
   l_cc        STRING,
   l_bcc       STRING,
   l_subject   STRING,
   l_body      STRING

DEFINE
   l_ok   SMALLINT

   LET l_ok = FALSE

   RETURN l_ok

END FUNCTION

##
# Function to send an email with attachments.
#

FUNCTION gt_send_email_with_attachments(l_from, l_to, l_cc, l_bcc, l_subject, l_body, l_attachment)

DEFINE
   l_from         STRING,
   l_to           STRING,
   l_cc           STRING,
   l_bcc          STRING,
   l_subject      STRING,
   l_body         STRING,
   l_attachment   STRING

DEFINE
   l_ok   SMALLINT

   LET l_ok = FALSE

   RETURN l_ok

END FUNCTION

##
# Function to do a simple mail merge.
# @param l_csv_file The csv file to use for the mail merge. The first line
#                   should contain the fieldnames of the fields to replace. The
#                   field names may not have spaces.
# @param l_template The template letter to use for sending. The fieldnames in
#                   the letter should be delimited by <>.
#

FUNCTION gt_simple_mail_merge(l_csv_file, l_template)

DEFINE
   l_csv_file   STRING,
   l_template   STRING

DEFINE
   l_ok           SMALLINT,
   i              INTEGER,
   l_body         STRING,
   l_token        STRING,
   l_fields       STRING,
   l_tokens       STRING,
   l_filehdl      base.channel,
   l_text         base.stringbuffer,
   l_tokenizer    base.stringtokenizer,
   l_field_list   DYNAMIC ARRAY OF STRING

   LET l_ok = FALSE

   #---------------------------------------------------------------------------#
   # Read in the template file                                                 #
   #---------------------------------------------------------------------------#

   IF gt_file_exists(l_template) THEN
      CALL gt_file_open(l_template, "r", "")
         RETURNING l_ok, l_filehdl

      IF l_ok THEN
         LET l_text = base.stringbuffer.create()

         WHILE gt_file_read(l_filehdl)
            CALL l_text.append(gt_file_buffer(l_filehdl))
         END WHILE
      ELSE
         CALL set_error(SFMT("%Unable to open file %1", l_template))
         LET l_ok = FALSE
      END IF
   ELSE
      CALL set_error(SFMT(%"The template file %1 does not exist", l_template))
      LET l_ok = FALSE
   END IF

   #---------------------------------------------------------------------------#
   # Read the field names from the csv file                                    #
   #---------------------------------------------------------------------------#

   IF l_ok THEN
      IF gt_file_exists(l_csv_file) THEN
         CALL gt_file_open(l_csv_file, "r", "")
            RETURNING l_ok, l_filehdl

         IF l_ok THEN
            IF gt_file_read(l_filehdl) THEN
               LET i = 0
               LET l_fields = gt_file_buffer(l_filehdl)
               LET l_tokenizer = base.stringtokenizer.create(l_fields.trim(), ",")

               WHILE l_tokenizer.hasmoretokens()
                  LET i = i + 1
                  LET l_field_list[i] = l_tokenizer.nexttoken()
               END WHILE
            ELSE
               CALL set_error(SFMT(%"Unable to read file %1", l_csv_file))
            END IF
         ELSE
            CALL set_error(SFMT(%"Unable to open file %1", l_csv_file))
            LET l_ok = FALSE
         END IF
      ELSE
         CALL set_error(SFMT(%"The csv file %1 does not exist", l_csv_file))
         LET l_ok = FALSE
      END IF
   END IF

   #---------------------------------------------------------------------------#
   # Iterate over the lines in the csv file                                    #
   #---------------------------------------------------------------------------#

   IF l_ok THEN
      WHILE gt_file_read(l_filehdl)
         LET l_body = l_text.toString()
         LET l_tokens = gt_file_buffer(l_filehdl)
         LET l_tokenizer = base.stringtokenizer.createext(l_tokens.trim(), ",", "", TRUE)

         WHILE l_tokenizer.hasmoretokens()
            LET l_token = l_tokenizer.nexttoken()
            # TODO Create this function
            #LET l_body = gt_string_replace(l_body, l_field_list[i], l_token, TRUE)
         END WHILE

         #LET l_ok = gt_send_email_notification(l_from, l_to, l_cc, l_bcc, l_subject, l_body)
      END WHILE
   END IF

   RETURN l_ok

END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

##
# Function to find a particular email in the list.
# @private
# @param l_emailhdl The handle to the email.
# @return l_pos The position of the email in the list, 0 if not found.
#

FUNCTION p_gt_find_email(l_emailhdl)

DEFINE
   l_emailhdl   STRING

DEFINE
   i       INTEGER,
   l_pos   INTEGER

   LET l_pos = 0

   FOR i = 1 TO m_email_count
      IF m_email_list[i].handle == l_emailhdl THEN
         LET l_pos = i
         EXIT FOR
      END IF
   END FOR

   RETURN l_pos

END FUNCTION

##
# Function to create the email message with the headers etc that will be sent
# via the gt_smtp_data function.
# @param l_pos
# @return l_email The email source to send.

FUNCTION p_gt_create_email_message(l_pos)

DEFINE
   l_pos   INTEGER

DEFINE
   l_email   base.stringbuffer

   LET l_email = base.stringbuffer.create()

   CALL l_email.append("From: ")
   CALL l_email.append(m_email_list[l_pos].from)
   CALL l_email.append("\r\n")

   CALL l_email.append("To: ")
   CALL l_email.append("\r\n")

   CALL l_email.append("Cc: ")
   CALL l_email.append("\r\n")

   CALL l_email.append("Subject: ")
   CALL l_email.append(m_email_list[l_pos].subject)
   CALL l_email.append("\r\n")

   CALL l_email.append("Date: ") #Date: Wed, 29 Aug 2007 21:50:46 -0600
   CALL l_email.append("\r\n")

   CALL l_email.append("User-Agent: GtMailer/1.0")
   CALL l_email.append("\r\n")

   CALL l_email.append("\r\n")

   CALL l_email.append(m_email_list[l_pos].body)
   CALL l_email.append("\r\n")

   RETURN l_email.tostring()

END FUNCTION

##
# Function to do the actual sending of the email(s).
# @private
# @param l_pos
# @return l_ok TRUE is email(s) successfully sent, FALSE otherwise.
#

FUNCTION p_gt_dispatch_email(l_pos)

DEFINE
   l_pos   INTEGER

DEFINE
   l_ok           SMALLINT,
   l_dummy        SMALLINT,
   i              INTEGER,
   l_from         STRING,
   l_to           STRING,
   l_cc           STRING,
   l_bcc          STRING,
   l_subject      STRING,
   l_body         STRING,
   l_attachment   STRING,
   l_sockethdl    base.channel

   LET l_ok = FALSE

   CALL gt_connect_to_smtp_server(m_smtp_server, m_smtp_port)
      RETURNING l_ok, l_sockethdl

   #---------------------------------------------------------------------------#
   # If l_pos is zero then we want to send all the queued emails               #
   #---------------------------------------------------------------------------#

   IF l_pos == 0 THEN
      FOR i = 1 TO m_email_count
         IF l_ok THEN
            IF gt_smtp_mail_from(l_sockethdl, l_from) THEN
               LET l_ok = TRUE
            ELSE
               LET l_ok = FALSE
            END IF
         END IF

         IF l_ok THEN
            IF gt_smtp_rcpt_to(l_sockethdl, l_to) THEN
               LET l_ok = TRUE
            ELSE
               LET l_ok = FALSE
            END IF
         END IF

         IF l_ok THEN
            IF gt_smtp_mail_data(l_sockethdl, p_gt_create_email_message(l_pos)) THEN
               LET l_ok = TRUE
            ELSE
               LET l_ok = FALSE
            END IF
         END IF
      END FOR
   ELSE
      IF l_ok THEN
         IF gt_smtp_mail_from(l_sockethdl, l_from) THEN
            LET l_ok = TRUE
         ELSE
            LET l_ok = FALSE
         END IF
      END IF

      IF l_ok THEN
         IF gt_smtp_rcpt_to(l_sockethdl, l_to) THEN
            LET l_ok = TRUE
         ELSE
            LET l_ok = FALSE
         END IF
      END IF

      IF l_ok THEN
         IF gt_smtp_mail_data(l_sockethdl, p_gt_create_email_message(l_pos)) THEN
            LET l_ok = TRUE
         ELSE
            LET l_ok = FALSE
         END IF
      END IF
   END IF

   #---------------------------------------------------------------------------#
   # RFC 2821 requires that we send quit even if something goes wrong          #
   #---------------------------------------------------------------------------#

   CALL gt_smtp_quit(l_sockethdl)
      RETURNING l_dummy

   RETURN l_ok

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
