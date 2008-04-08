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
# POP3 Client Library (RFC 1939)
#
# This library does the physical connecting to the POP3 server and retrieving
# of the email messages on the server. (Normally you would never call any of
# these functions from within your code but would use the functions provided by
# the messaging library instead.)
#
# @category System Library
# @author Scott Newton
# @date April 2008
# @version $Id$
#

DEFINE
   m_socket_count   INTEGER,
   m_connections    FLOAT,
   m_bytesread      FLOAT,
   m_byteswritten   FLOAT,

   m_socket_list DYNAMIC ARRAY OF RECORD
      handle   STRING,
      socket   base.channel
   END RECORD,

   m_message_list DYNAMIC ARRAY OF RECORD
      number   INTEGER,
      size     INTEGER
   END RECORD

#------------------------------------------------------------------------------#
# Function to set the WHENEVER ANY ERROR function for this module.             #
#------------------------------------------------------------------------------#

FUNCTION libgt_pop3_client_id()

DEFINE
   l_id   STRING

   WHENEVER ANY ERROR CALL gt_system_error
   LET l_id = "$Id$"

END FUNCTION

##
# Function to initialize the POP3 client network statistics.
#

FUNCTION gt_pop3_client_init()

   LET m_connections = 0
   LET m_bytesread = 0
   LET m_byteswritten = 0

END FUNCTION

##
# FUnction to get the POP3 client network statistics. The bytes read and written
# only include the data read from and written to the socket connection. It does
# not include the TCP/IP header packet sizes.
# @return m_connections The number of connections that have been opened.
# @return m_bytesread The total number of bytes read.
# @return m_byteswritten The total number of bytes written.
#

FUNCTION gt_pop3_client_statistics()

   RETURN m_connections USING "<<<,<<<,<<<,<<<,<<<,<<<",
          m_bytesread USING "<<<,<<<,<<<,<<<,<<<,<<<",
          m_byteswritten USING "<<<,<<<,<<<,<<<,<<<,<<<"

END FUNCTION

##
# Function to establish the connect to the given POP3 server.
# @param l_popserver The popserver to connect to.
# @param l_port The port the popserver is listening on.
# @return l_ok Returns TRUE if the connection was successful, FALSE otherwise.
# @return l_sockethdl The handle to the opened socket.
#

FUNCTION gt_connect_to_pop3_server(l_popserver, l_port)

DEFINE
   l_popserver   STRING,
   l_port        INTEGER

DEFINE
   l_ok              SMALLINT,
   l_status          INTEGER,
   l_data            STRING,
   l_sockethdl       STRING,
   l_response_code   STRING,
   l_socket          base.Channel

   LET l_ok = FALSE
   LET l_status = 0
   LET l_sockethdl = NULL
   LET l_popserver = l_popserver.trim()

   LET l_socket = base.Channel.create()

   IF l_socket IS NOT NULL THEN
      LET m_socket_count = m_socket_count + 1
      LET l_sockethdl = gt_next_serial("SOCKET")
      LET m_socket_list[m_socket_count].handle = l_sockethdl
      LET m_socket_list[m_socket_count].socket = l_socket
   ELSE
      RETURN l_ok, l_sockethdl
   END IF

   CALL l_socket.setDelimiter("")
   CALL l_socket.openClientSocket(l_popserver, l_port, "ub", 10)

   IF STATUS == 0 THEN
      #------------------------------------------------------------------------#
      # Read the response from the mail server on connecting                   #
      #------------------------------------------------------------------------#
      LET m_connections = m_connections + 1

      CALL l_socket.read(l_data)
         RETURNING l_ok

      LET l_response_code = l_data.subString(1, 3)
      LET m_bytesread = m_bytesread + l_data.getLength()

      CASE
         WHEN l_response_code == "220"
            LET l_ok = TRUE

         OTHERWISE
            LET l_ok = FALSE
            LET l_socket = NULL
      END CASE
   ELSE
   END IF

   RETURN l_ok, l_sockethdl

END FUNCTION

##
# Function to send the STAT command to the POP3 server.
# @param l_sockethdl The handle to the open socket.
# @return l_ok Returns TRUE if the STAT was successful, FALSE otherwise.
# @return l_number The number of messages.
# @return l_size The size of the messages.
#

FUNCTION gt_pop3_status(l_sockethdl)

DEFINE
   l_sockethdl   STRING

DEFINE
   l_ok              SMALLINT,
   l_size            INTEGER,
   l_number          INTEGER,
   l_data            STRING,
   l_response_code   STRING,
   l_socket          base.Channel,
   l_tokenizer       base.StringTokenizer

   LET l_size = 0
   LET l_number = 0
   LET l_ok = FALSE
   LET l_data = "STAT"

   LET l_socket = p_gt_find_pop3_client_socket(l_sockethdl)

   IF l_socket IS NULL THEN
      CALL gt_set_error("ERROR", SFMT(%"The given sockethdl %1 is not valid", l_sockethdl))
      RETURN FALSE, l_number, l_size
   END IF

   CALL l_socket.write(l_data)
   LET m_byteswritten = m_byteswritten + l_data.getLength()

   CALL l_socket.read(l_data)
      RETURNING l_ok

   LET m_bytesread = m_bytesread + l_data.getLength()

   LET l_tokenizer = base.StringTokenizer.create(l_data, " ")
   LET l_response_code = l_tokenizer.nextToken()

   CASE
      WHEN l_response_code.toUpperCase() == "+OK"
         LET l_ok = TRUE
         LET l_number = l_tokenizer.nextToken()
         LET l_size = l_tokenizer.nextToken()

      OTHERWISE
         LET l_ok = FALSE
   END CASE

   RETURN l_ok, l_number, l_size

END FUNCTION

##
# Function to send the LIST command to the POP3 server.
# @param l_sockethdl The handle to the open socket.
# @param l_number The number of the message summaries to retrieve, 0 for a
#                 summary of all messages.
# @return l_ok Returns TRUE if the LIST was successful, FALSE otherwise.
# @return m_message_list.getLength() The number of message summaries retrieved.
#

FUNCTION gt_pop3_list(l_sockethdl, l_number)

DEFINE
   l_sockethdl   STRING,
   l_number      INTEGER

DEFINE
   l_ok              SMALLINT,
   i                 INTEGER,
   l_data            STRING,
   l_response_code   STRING,
   l_socket          base.Channel,
   l_tokenizer       base.StringTokenizer

   LET l_ok = FALSE
   LET l_data = "LIST"
   CALL m_message_list.clear()

   IF l_number > 0 THEN
      LET l_data = l_data, " ", l_number
   END IF

   LET l_socket = p_gt_find_pop3_client_socket(l_sockethdl)

   IF l_socket IS NULL THEN
      CALL gt_set_error("ERROR", SFMT(%"The given sockethdl %1 is not valid", l_sockethdl))
      RETURN FALSE, m_message_list.getLength()
   END IF

   CALL l_socket.write(l_data)
   LET m_byteswritten = m_byteswritten + l_data.getLength()

   CALL l_socket.read(l_data)
      RETURNING l_ok

   LET m_bytesread = m_bytesread + l_data.getLength()

   LET l_tokenizer = base.StringTokenizer.create(l_data, " ")
   LET l_response_code = l_tokenizer.nextToken()

   CASE
      WHEN l_response_code.toUpperCase() == "+OK"
         LET l_ok = TRUE

         IF l_number == 0 THEN
            LET l_number = l_tokenizer.nextToken()

            FOR i = 1 TO l_number
               CALL l_socket.read(l_data)
                  RETURNING l_ok

               LET m_bytesread = m_bytesread + l_data.getLength()

               LET l_tokenizer = base.StringTokenizer.create(l_data, " ")
               LET m_message_list[i].number = l_tokenizer.nextToken()
               LET m_message_list[i].size = l_tokenizer.nextToken()
            END FOR
         ELSE
            LET m_message_list[1].number = l_tokenizer.nextToken()
            LET m_message_list[1].size = l_tokenizer.nextToken()
         END IF

      OTHERWISE
         LET l_ok = FALSE
   END CASE

   RETURN l_ok, m_message_list.getLength()

END FUNCTION

##
# Function to send the RETR command to the POP3 server.
# @param l_sockethdl The handle to the open socket.
# @param l_number The number of the message to retrieve.
# @return l_ok Returns TRUE if the RETR was successful, FALSE otherwise.
# @return l_size The size of the message.
# @return l_message The entire message.
#

FUNCTION gt_pop3_retrieve(l_sockethdl, l_number)

DEFINE
   l_sockethdl   STRING,
   l_number      INTEGER

DEFINE
   l_ok              SMALLINT,
   l_size            INTEGER,
   l_data            STRING,
   l_message         STRING,
   l_response_code   STRING,
   l_socket          base.Channel,
   l_tokenizer       base.StringTokenizer

   LET l_size = 0
   LET l_message = ""
   LET l_ok = FALSE
   LET l_data = "RETR ", l_number

   LET l_socket = p_gt_find_pop3_client_socket(l_sockethdl)

   IF l_socket IS NULL THEN
      CALL gt_set_error("ERROR", SFMT(%"The given sockethdl %1 is not valid", l_sockethdl))
      RETURN FALSE, l_number, l_size
   END IF

   CALL l_socket.write(l_data)
   LET m_byteswritten = m_byteswritten + l_data.getLength()

   CALL l_socket.read(l_data)
      RETURNING l_ok

   LET m_bytesread = m_bytesread + l_data.getLength()

   LET l_tokenizer = base.StringTokenizer.create(l_data, " ")
   LET l_response_code = l_tokenizer.nextToken()

   CASE
      WHEN l_response_code.toUpperCase() == "+OK"
         LET l_ok = TRUE
         LET l_size = l_tokenizer.nextToken()

         CALL l_socket.read(l_message)
            RETURNING l_ok

         LET m_bytesread = m_bytesread + l_message.getLength()

      OTHERWISE
         LET l_ok = FALSE
   END CASE

   RETURN l_ok, l_size, l_message

END FUNCTION

##
# Function to send the DELE command to the POP3 server.
# @param l_sockethdl The handle to the open socket.
# @param l_number The number of the message to delete.
# @return l_ok Returns TRUE if the DELE was successful, FALSE otherwise.
#

FUNCTION gt_pop3_delete(l_sockethdl, l_number)

DEFINE
   l_sockethdl   STRING,
   l_number      INTEGER

DEFINE
   l_ok              SMALLINT,
   l_data            STRING,
   l_response_code   STRING,
   l_socket          base.Channel,
   l_tokenizer       base.StringTokenizer

   LET l_ok = FALSE
   LET l_data = "DELE ", l_number

   LET l_socket = p_gt_find_pop3_client_socket(l_sockethdl)

   IF l_socket IS NULL THEN
      CALL gt_set_error("ERROR", SFMT(%"The given sockethdl %1 is not valid", l_sockethdl))
      RETURN FALSE
   END IF

   CALL l_socket.write(l_data)
   LET m_byteswritten = m_byteswritten + l_data.getLength()

   CALL l_socket.read(l_data)
      RETURNING l_ok

   LET m_bytesread = m_bytesread + l_data.getLength()

   LET l_tokenizer = base.StringTokenizer.create(l_data, " ")
   LET l_response_code = l_tokenizer.nextToken()

   CASE
      WHEN l_response_code.toUpperCase() == "+OK"
         LET l_ok = TRUE

      OTHERWISE
         LET l_ok = FALSE
   END CASE

   RETURN l_ok

END FUNCTION

##
# Function to send the QUIT command to the POP3 server.
# @param l_sockethdl The handle to the open socket.
# @return l_ok Returns TRUE is the socket was successfully disconnected, FALSE
#              otherwise.
#

FUNCTION gt_pop3_quit(l_sockethdl)

DEFINE
   l_sockethdl   STRING

DEFINE
   l_ok              SMALLINT,
   i                 INTEGER,
   l_data            STRING,
   l_response_code   STRING,
   l_socket          base.Channel,
   l_tokenizer       base.StringTokenizer

   LET l_ok = FALSE
   LET l_data = "QUIT"

   LET l_socket = p_gt_find_pop3_client_socket(l_sockethdl)

   IF l_socket IS NULL THEN
      CALL gt_set_error("ERROR", SFMT(%"The given sockethdl %1 is not valid", l_sockethdl))
      RETURN FALSE
   END IF

   CALL l_socket.write(l_data)
   LET m_byteswritten = m_byteswritten + l_data.getLength()

   CALL l_socket.read(l_data)
      RETURNING l_ok

   LET l_tokenizer = base.StringTokenizer.create(l_data, " ")
   LET l_response_code = l_tokenizer.nextToken()

   CASE
      WHEN l_response_code == "+OK"
         LET l_ok = TRUE

      OTHERWISE
         LET l_ok = FALSE
   END CASE

   CALL l_socket.close()

   FOR i = 1 TO m_socket_list.getlength()
      IF m_socket_list[i].handle = l_sockethdl THEN
         CALL m_socket_list.deleteelement(i)
         LET m_socket_count = m_socket_count - 1
         EXIT FOR
      END IF
   END FOR

   RETURN l_ok

END FUNCTION

##
# Function to send the RSET command to the POP3 server.
# @param l_sockethdl The handle to the open socket.
# @return l_ok Returns TRUE is the socket was successfully reset, FALSE
#              otherwise.
#

FUNCTION gt_pop3_reset(l_sockethdl)

DEFINE
   l_sockethdl   STRING

DEFINE
   l_ok              SMALLINT,
   l_data            STRING,
   l_response_code   STRING,
   l_socket          base.Channel,
   l_tokenizer       base.StringTokenizer

   LET l_ok = FALSE
   LET l_data = "RSET"

   LET l_socket = p_gt_find_pop3_client_socket(l_sockethdl)

   IF l_socket IS NULL THEN
      CALL gt_set_error("ERROR", SFMT(%"The given sockethdl %1 is not valid", l_sockethdl))
      RETURN FALSE
   END IF

   CALL l_socket.write(l_data)
   LET m_byteswritten = m_byteswritten + l_data.getLength()

   CALL l_socket.read(l_data)
      RETURNING l_ok

   LET l_tokenizer = base.StringTokenizer.create(l_data, " ")
   LET l_response_code = l_tokenizer.nextToken()

   CASE
      WHEN l_response_code == "+OK"
         LET l_ok = TRUE

      OTHERWISE
         LET l_ok = FALSE
   END CASE

   RETURN l_ok

END FUNCTION

##
# Function to send the NOOP command to the POP3 server.
# @param l_sockethdl The handle to the open socket.
# @return l_ok Returns TRUE is the NOOP was successful, FALSE otherwise.
#

FUNCTION gt_pop3_noop(l_sockethdl)

DEFINE
   l_sockethdl   STRING

DEFINE
   l_ok              SMALLINT,
   l_data            STRING,
   l_response_code   STRING,
   l_socket          base.Channel,
   l_tokenizer       base.StringTokenizer

   LET l_ok = FALSE
   LET l_data = "NOOP"

   LET l_socket = p_gt_find_pop3_client_socket(l_sockethdl)

   IF l_socket IS NULL THEN
      CALL gt_set_error("ERROR", SFMT(%"The given sockethdl %1 is not valid", l_sockethdl))
      RETURN FALSE
   END IF

   CALL l_socket.write(l_data)
   LET m_byteswritten = m_byteswritten + l_data.getLength()

   CALL l_socket.read(l_data)
      RETURNING l_ok

   LET l_tokenizer = base.StringTokenizer.create(l_data, " ")
   LET l_response_code = l_tokenizer.nextToken()

   CASE
      WHEN l_response_code.toUpperCase() == "+OK"
         LET l_ok = TRUE

      OTHERWISE
         LET l_ok = FALSE
   END CASE

   RETURN l_ok

END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

##
# Function to find the socket associated with the given handle.
# @param l_sockethdl The given sockethdl.
# @return l_socket The actual socket to use.
#

FUNCTION p_gt_find_pop3_client_socket(l_sockethdl)

DEFINE
   l_sockethdl   STRING

DEFINE
   i          INTEGER,
   l_socket   base.channel

   LET l_socket = NULL

   FOR i = 1 TO m_socket_list.getlength()
      IF m_socket_list[i].handle = l_sockethdl THEN
         LET l_socket = m_socket_list[i].socket
         EXIT FOR
      END IF
   END FOR

   RETURN l_socket

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
