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
# SMTP Client Library (RFC 2821)
#
# This library does the physical connecting to the SMTP server and sending
# of the email message it has been given. Normally you would never call any of
# these functions from within your code but would use the functions provided by
# the emailing library instead.
#
# @category System Library
# @author Scott Newton
# @date June 2007
# @version $Id$
#

DEFINE
   m_connections    FLOAT,
   m_bytesread      FLOAT,
   m_byteswritten   FLOAT

#------------------------------------------------------------------------------#
# Function to set the WHENEVER ANY ERROR function for this module.             #
#------------------------------------------------------------------------------#

FUNCTION lib_smtp_client_id()

DEFINE
   l_id   STRING

   WHENEVER ANY ERROR CALL gt_system_error
   LET l_id = "$Id$"

END FUNCTION

##
# Function to initialize the SMTP client network statistics.
#

FUNCTION gt_smtp_client_init()

   LET m_connections = 0
   LET m_bytesread = 0
   LET m_byteswritten = 0

END FUNCTION

##
# FUnction to get the SMTP client network statistics. The bytes read and written
# only include the data read from and written to the socket connection. It does
# not include the TCP/IP header packet sizes.
# @return m_connections The number of connections that have been opened.
# @return m_bytesread The total number of bytes read.
# @return m_byteswritten The total number of bytes written.
#

FUNCTION gt_smtp_client_statistics()

   RETURN m_connections USING "<<<,<<<,<<<,<<<,<<<,<<<",
          m_bytesread USING "<<<,<<<,<<<,<<<,<<<,<<<",
          m_byteswritten USING "<<<,<<<,<<<,<<<,<<<,<<<"

END FUNCTION

##
# Function to establish the connect to the given SMTP server.
# @param l_mailserver The mailserver to connect to.
# @param l_port The port the mailserver is listening on.
# @return l_ok Returns TRUE if the connection was successful, FALSE otherwise.
# @return l_sockethdl The handle to the opened socket.
#

FUNCTION gt_connect_to_smtp_server(l_mailserver, l_port)

DEFINE
   l_mailserver   STRING,
   l_port         INTEGER

DEFINE
   l_ok              SMALLINT,
   i                 INTEGER,
   l_status          INTEGER,
   l_data            STRING,
   l_response_code   STRING,
   l_sockethdl       base.Channel

   LET l_ok = FALSE
   LET l_status = 0
   LET l_mailserver = l_mailserver.trim()

   LET l_sockethdl = base.Channel.create()
   CALL l_sockethdl.setDelimiter("")
   CALL l_sockethdl.openClientSocket(l_mailserver, "25", "ub", 10)

   IF STATUS == 0 THEN
      #------------------------------------------------------------------------#
      # Read the response from the mail server on connecting                   #
      #------------------------------------------------------------------------#
      LET m_connections = m_connections + 1

      CALL l_sockethdl.read(l_data)
         RETURNING l_ok

      LET l_response_code = l_data.subString(1, 3)
      LET m_bytesread = m_bytesread + l_data.getLength()

      CASE
         WHEN l_response_code == "220"
            LET l_ok = TRUE

         OTHERWISE
            LET l_ok = FALSE
            LET l_sockethdl = NULL
      END CASE
   ELSE
   END IF

   RETURN l_ok, l_sockethdl

END FUNCTION

##
# Function to send the HELO command to the SMTP server.
# @param l_sockethdl The handle to the open socket.
# @param l_domainname The domain to say hello from.
# @return l_ok Returns TRUE if the greeting was accepted, FALSE otherwise.
#

FUNCTION gt_smtp_helo(l_sockethdl, l_domainname)

DEFINE
   l_sockethdl    base.channel,
   l_domainname   STRING

DEFINE
   l_ok              SMALLINT,
   l_data            STRING,
   l_response_code   STRING

   LET l_ok = FALSE
   LET l_data = "HELO ", l_domainname

   CALL l_sockethdl.write(l_data)
   LET m_byteswritten = m_byteswritten + l_data.getLength()

   CALL l_sockethdl.read(l_data)
      RETURNING l_ok

   LET l_response_code = l_data.subString(1, 3)
   LET m_bytesread = m_bytesread + l_data.getLength()

   CASE
      WHEN l_response_code == "250"
         LET l_ok = TRUE

      OTHERWISE
         LET l_ok = FALSE
   END CASE

   RETURN l_ok

END FUNCTION

##
# Function to send the MAIL FROM command to the SMTP server.
# @param l_sockethdl The handle to the open socket.
# @param l_to The person from whom the email is sent.
# @return l_ok Returns TRUE if the from address was successfully set, FALSE
#              otherwise.
#

FUNCTION gt_smtp_mail_from(l_sockethdl, l_from)

DEFINE
   l_sockethdl   base.channel,
   l_from        STRING

DEFINE
   l_ok              SMALLINT,
   l_data            STRING,
   l_response_code   STRING

   LET l_ok = FALSe
   LET l_data = "MAIL FROM: <", l_from, ">"

   CALL l_sockethdl.write(l_data)
   LET m_byteswritten = m_byteswritten + l_data.getLength()

   CALL l_sockethdl.read(l_data)
      RETURNING l_ok

   LET l_response_code = l_data.subString(1, 3)
   LET m_bytesread = m_bytesread + l_data.getLength()

   CASE
      WHEN l_response_code == "250"
         LET l_ok = TRUE

      OTHERWISE
         LET l_ok = FALSE
   END CASE

   RETURN l_ok

END FUNCTION

##
# Function to send the RCPT TO command to the SMTP server.
# @param l_sockethdl The handle to the open socket.
# @param l_to The person to send the email to.
# @return l_ok Returns TRUE if the to address was successfully set, FALSE
#              otherwise.
#

FUNCTION gt_smtp_rcpt_to(l_sockethdl, l_to)

DEFINE
   l_sockethdl   base.channel,
   l_to          STRING

DEFINE
   l_ok              SMALLINT,
   l_data            STRING,
   l_response_code   STRING

   LET l_ok = FALSE
   LET l_data = "RCPT TO: <", l_to, ">"

   CALL l_sockethdl.write(l_data)
   LET m_byteswritten = m_byteswritten + l_data.getLength()

   CALL l_sockethdl.read(l_data)
      RETURNING l_ok

   LET l_response_code = l_data.subString(1, 3)
   LET m_bytesread = m_bytesread + l_data.getLength()

   CASE
      WHEN l_response_code == "250"
         LET l_ok = TRUE

      OTHERWISE
         LET l_ok = FALSE
   END CASE

   RETURN l_ok

END FUNCTION

##
# Function to send the DATA command and data to the SMTP server.
# @param l_sockethdl The handle to the open socket.
# @param l_email The text of the email.
# @return l_ok Returns TRUE if the email was successfully sent, FALSE otherwise.
#

FUNCTION gt_smtp_data(l_sockethdl, l_email)

DEFINE
   l_sockethdl   base.channel,
   l_email       STRING

DEFINE
   l_ok              SMALLINT,
   l_data            STRING,
   l_response_code   STRING

   LET l_ok = FALSE
   LET l_data = "DATA"
   LET l_email = l_email

   CALL l_sockethdl.write(l_data)
   LET m_byteswritten = m_byteswritten + l_data.getLength()

   CALL l_sockethdl.read(l_data)
      RETURNING l_ok

   LET l_response_code = l_data.subString(1, 3)
   LET m_bytesread = m_bytesread + l_data.getLength()

   CASE
      WHEN l_response_code == "354"
         LET l_ok = TRUE

      OTHERWISE
         RETURN FALSE
   END CASE

   #---------------------------------------------------------------------------#
   # Send the email                                                            #
   #---------------------------------------------------------------------------#

   CALL l_sockethdl.write(l_email)
   CALL l_sockethdl.write("\r\n")
   CALL l_sockethdl.write(".")
   LET m_byteswritten = m_byteswritten + l_email.getLength() + 3

   CALL l_sockethdl.read(l_data)
      RETURNING l_ok

   LET l_response_code = l_data.subString(1, 3)
   LET m_bytesread = m_bytesread + l_data.getLength()

   CASE
      WHEN l_response_code == "250"
         LET l_ok = TRUE

      OTHERWISE
         LET l_ok = FALSE
   END CASE

   RETURN l_ok

END FUNCTION

##
# Function to send the QUIT command to the SMTP server.
# @param l_sockethdl The handle to the open socket.
# @return l_ok Returns TRUE is the socket was successfully disconnected, FALSE
#              otherwise.
#

FUNCTION gt_smtp_quit(l_sockethdl)

DEFINE
   l_sockethdl   base.channel

DEFINE
   l_ok              SMALLINT,
   l_data            STRING,
   l_response_code   STRING

   LET l_ok = FALSE
   LET l_data = "QUIT"

   CALL l_sockethdl.write(l_data)
   LET m_byteswritten = m_byteswritten + l_data.getLength()

   CALL l_sockethdl.read(l_data)
      RETURNING l_ok

   LET l_response_code = l_data.subString(1, 3)
   LET m_bytesread = m_bytesread + l_data.getLength()

   CASE
      WHEN l_response_code == "221"
         LET l_ok = TRUE

      OTHERWISE
         LET l_ok = FALSE
   END CASE

   CALL l_sockethdl.close()

   RETURN l_ok

END FUNCTION

##
# Function to send the RSET command to the SMTP server.
# @param l_sockethdl The handle to the open socket.
# @return l_ok Returns TRUE is the socket was successfully reset, FALSE
#              otherwise.
#

FUNCTION gt_smtp_reset(l_sockethdl)

DEFINE
   l_sockethdl   base.channel

DEFINE
   l_ok              SMALLINT,
   l_data            STRING,
   l_response_code   STRING

   LET l_ok = FALSE
   LET l_data = "RSET"

   CALL l_sockethdl.write(l_data)
   LET m_byteswritten = m_byteswritten + l_data.getLength()

   CALL l_sockethdl.read(l_data)
      RETURNING l_ok

   LET l_response_code = l_data.subString(1, 3)
   LET m_bytesread = m_bytesread + l_data.getLength()

   CASE
      WHEN l_response_code == "250"
         LET l_ok = TRUE

      OTHERWISE
         LET l_ok = FALSE
   END CASE

   RETURN l_ok

END FUNCTION

##
# Function to send the NOOP command to the SMTP server.
# @param l_sockethdl The handle to the open socket.
# @return l_ok Returns TRUE is the NOOP was successful, FALSE otherwise.
#

FUNCTION gt_smtp_noop(l_sockethdl)

DEFINE
   l_sockethdl   base.channel

DEFINE
   l_ok              SMALLINT,
   l_data            STRING,
   l_response_code   STRING

   LET l_ok = FALSE
   LET l_data = "NOOP"

   CALL l_sockethdl.write(l_data)
   LET m_byteswritten = m_byteswritten + l_data.getLength()

   CALL l_sockethdl.read(l_data)
      RETURNING l_ok

   LET l_response_code = l_data.subString(1, 3)
   LET m_bytesread = m_bytesread + l_data.getLength()

   CASE
      WHEN l_response_code == "250"
         LET l_ok = TRUE

      OTHERWISE
         LET l_ok = FALSE
   END CASE

   RETURN l_ok

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
